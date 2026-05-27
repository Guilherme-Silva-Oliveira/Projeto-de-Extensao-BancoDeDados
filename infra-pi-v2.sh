#!/bin/bash
set -e
export AWS_PAGER=""

### VARIÁVEIS ###
CIDR_VPC="10.0.0.0/24"
CIDR_SUBNET_PUBL="10.0.0.0/26"
CIDR_SUBNET_PUBL_2="10.0.0.64/26"
CIDR_SUBNET_PRIV="10.0.0.128/26"

AZ_1="us-east-1a"
AZ_2="us-east-1b"

AMI="ami-0360c520857e3138f"

echo "Criando VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $CIDR_VPC --query 'Vpc.VpcId' --output text)

echo "Criando Subnets..."
SUBNET_PUB1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $CIDR_SUBNET_PUBL --availability-zone $AZ_1 --query 'Subnet.SubnetId' --output text)

SUBNET_PUB2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $CIDR_SUBNET_PUBL_2 --availability-zone $AZ_2 --query 'Subnet.SubnetId' --output text)

SUBNET_PRIV=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $CIDR_SUBNET_PRIV --availability-zone $AZ_1 --query 'Subnet.SubnetId' --output text)

aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUB1 --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUB2 --map-public-ip-on-launch

echo "Internet Gateway..."
IGW=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW --vpc-id $VPC_ID

echo "Route Table Pública..."
RTB_PUB=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)

aws ec2 create-route --route-table-id $RTB_PUB --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW

aws ec2 associate-route-table --route-table-id $RTB_PUB --subnet-id $SUBNET_PUB1
aws ec2 associate-route-table --route-table-id $RTB_PUB --subnet-id $SUBNET_PUB2

echo "NAT Gateway..."
EIP=$(aws ec2 allocate-address --query AllocationId --output text)
NAT=$(aws ec2 create-nat-gateway --subnet-id $SUBNET_PUB1 --allocation-id $EIP --query 'NatGateway.NatGatewayId' --output text)

sleep 60

echo "Route Table Privada..."
RTB_PRIV=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)

aws ec2 create-route --route-table-id $RTB_PRIV --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT
aws ec2 associate-route-table --route-table-id $RTB_PRIV --subnet-id $SUBNET_PRIV

echo "Security Groups..."

SG_SSH=$(aws ec2 create-security-group --group-name grupo-ssh --description ssh --vpc-id $VPC_ID --query GroupId --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_SSH --protocol tcp --port 22 --cidr 0.0.0.0/0

SG_HTTP=$(aws ec2 create-security-group --group-name grupo-http --description http --vpc-id $VPC_ID --query GroupId --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_HTTP --protocol tcp --port 80 --cidr 0.0.0.0/0

echo "Subindo WEB 1..."
WEB1=$(aws ec2 run-instances \
--image-id $AMI \
--instance-type t2.micro \
--subnet-id $SUBNET_PUB1 \
--associate-public-ip-address \
--security-group-ids $SG_SSH $SG_HTTP \
--query 'Instances[0].InstanceId' \
--output text \
--user-data '#!/bin/bash
apt update -y
apt install nginx -y
echo "WEB 1" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx')

echo "Subindo WEB 2..."
WEB2=$(aws ec2 run-instances \
--image-id $AMI \
--instance-type t2.micro \
--subnet-id $SUBNET_PUB2 \
--associate-public-ip-address \
--security-group-ids $SG_SSH $SG_HTTP \
--query 'Instances[0].InstanceId' \
--output text \
--user-data '#!/bin/bash
apt update -y
apt install nginx -y
echo "WEB 2" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx')

echo "Subindo API (privada)..."
API=$(aws ec2 run-instances \
--image-id $AMI \
--instance-type t2.micro \
--subnet-id $SUBNET_PRIV \
--no-associate-public-ip-address \
--security-group-ids $SG_SSH \
--query 'Instances[0].InstanceId' \
--output text)

echo "Subindo DB (privada)..."
DB=$(aws ec2 run-instances \
--image-id $AMI \
--instance-type t2.micro \
--subnet-id $SUBNET_PRIV \
--no-associate-public-ip-address \
--security-group-ids $SG_SSH \
--query 'Instances[0].InstanceId' \
--output text)

echo "Esperando WEBs..."
aws ec2 wait instance-running --instance-ids $WEB1 $WEB2

sleep 20

IP1=$(aws ec2 describe-instances --instance-ids $WEB1 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
IP2=$(aws ec2 describe-instances --instance-ids $WEB2 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)

echo "Subindo Load Balancer..."

LB=$(aws ec2 run-instances \
--image-id $AMI \
--instance-type t2.micro \
--subnet-id $SUBNET_PUB1 \
--associate-public-ip-address \
--security-group-ids $SG_SSH $SG_HTTP \
--query 'Instances[0].InstanceId' \
--output text \
--user-data "#!/bin/bash
apt update -y
apt install nginx -y

cat <<EOF > /etc/nginx/sites-available/default
upstream backend {
    server $IP1;
    server $IP2;
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
    }
}
EOF

systemctl restart nginx
systemctl enable nginx
")

sleep 10

LB_IP=$(aws ec2 describe-instances --instance-ids $LB --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "-----------------------------------"
echo "LOAD BALANCER:"
echo "http://$LB_IP"
echo "-----------------------------------"