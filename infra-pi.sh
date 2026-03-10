#!/bin/bash

CHAVE_WEB="key-web"
CHAVE_DB="key-db"
CHAVE_API="key-api"

IMAGEM_EC2="ami-0360c520857e3138f"

##### Criacao da Vpc de Subnets #####

echo "Criando VPC..."
VPC_ID=$(aws ec2 create-vpc \
            --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=vpc-01}]" \
            --cidr-block "10.0.0.0/26" \
            --query "Vpc.VpcId" \
            --output "text") 

echo "Criando subnet publica..."
SUBNET_PUBL_ID=$(aws ec2 create-subnet \
                --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=subnet-publica}]" \
                --cidr-block "10.0.0.0/27" \
                --vpc-id "$VPC_ID" \
                --query "Subnet.SubnetId" \
                --output "text")

echo "Criando subnet privada..."
SUBNET_PRIV_ID=$(aws ec2 create-subnet \
                --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=subnet-privada}]" \
                --cidr-block "10.0.0.32/27" \
                --vpc-id "$VPC_ID" \
                --query "Subnet.SubnetId" \
                --output "text")


##### Criacao dos pares de chaves #####

EXISTE_KEY_WEB=$(aws ec2 describe-key-pairs \
  --key-names "$CHAVE_WEB" \
  2>/dev/null)
if [ -z "$EXISTE_KEY_WEB" ]; then
  echo "Criando Par de Chaves $CHAVE_WEB..."
  aws ec2 create-key-pair \
    --key-name "$CHAVE_WEB" \
    --region "us-east-1" \
    --query "KeyMaterial" \
    --output text >"$CHAVE_WEB".pem
  chmod 400 "$CHAVE_WEB.pem"
else
  echo "Par de Chaves $CHAVE_WEB já existe!"
fi

EXISTE_KEY_DB=$(aws ec2 describe-key-pairs \
  --key-names "$CHAVE_DB" \
  2>/dev/null)
if [ -z "$EXISTE_KEY_DB" ]; then
  echo "Criando Par de Chaves $CHAVE_DB..."
  aws ec2 create-key-pair \
    --key-name "$CHAVE_DB" \
    --region "us-east-1" \
    --query "KeyMaterial" \
    --output text >"$CHAVE_DB".pem
  chmod 400 "$CHAVE_DB.pem"
else
  echo "Par de Chaves $CHAVE_DB já existe!"
fi

EXISTE_KEY_API=$(aws ec2 describe-key-pairs \
  --key-names "$CHAVE_API" \
  2>/dev/null)
if [ -z "$EXISTE_KEY_API" ]; then
  echo "Criando Par de Chaves $CHAVE_API..."
  aws ec2 create-key-pair \
    --key-name "$CHAVE_API" \
    --region "us-east-1" \
    --query "KeyMaterial" \
    --output text >"$CHAVE_API".pem
  chmod 400 "$CHAVE_API.pem"
else
  echo "Par de Chaves $CHAVE_API já existe!"
fi

##### Criacao das ec2 #####

echo "Criando grupo de segurança"
SG_ID=$(aws ec2 create-security-group \
    --vpc-id "$VPC_ID" \
    --group-name "grupo-seguranca-web" \
    --description "created $(date +%F)" \
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=sg-01}]" \
    --query "GroupId" \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --no-cli-pager \
    --ip-permissions \
    IpProtocol=tcp,FromPort=8080,ToPort=8080,IpRanges='[{CidrIp=0.0.0.0/0}]' \
    IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0}]'

# servidor publico
EXISTE_WEB=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=serv-web" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)
if [ -z "$EXISTE_WEB" ]; then
echo "Criando servidor web..."
aws ec2 run-instances \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=serv-web}]" \
    --image-id "$IMAGEM_EC2" \
    --instance-type "t2.micro" \
    --subnet-id "$SUBNET_PUBL_ID" \
    --key-name "$CHAVE_WEB" \
    --associate-public-ip-address \
    --security-group-ids "$SG_ID" \
    --no-cli-pager
else
    echo "Servidor web já existe!"
fi

# servidor api
EXISTE_API=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=serv-api" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)
if [ -z "$EXISTE_API" ]; then
echo "Criando servidor api..."
aws ec2 run-instances \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=serv-api}]" \
    --image-id "$IMAGEM_EC2" \
    --instance-type "t2.micro" \
    --subnet-id "$SUBNET_PRIV_ID" \
    --key-name "$CHAVE_API" \
    --no-associate-public-ip-address \
    --no-cli-pager
else
    echo "Servidor api já existe!"
fi

# servidor banco de dados
EXISTE_DB=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=serv-db" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)
if [ -z "$EXISTE_DB" ]; then
echo "Criando servidor db..."
aws ec2 run-instances \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=serv-db}]" \
    --image-id "$IMAGEM_EC2" \
    --instance-type "t2.micro" \
    --subnet-id "$SUBNET_PRIV_ID" \
    --key-name "$CHAVE_DB" \
    --no-associate-public-ip-address \
    --no-cli-pager
else
    echo "Servidor db já existe!"
fi

##### Criando internet gateway #####

IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=igw-01}]" \
    --query InternetGateway.InternetGatewayId \
    --output text)

aws ec2 attach-internet-gateway \
    --internet-gateway-id "$IGW_ID" \
    --vpc-id "$VPC_ID"

##### Criando route table publica #####

echo "Criando route table publica..."
RTB_PUBL_ID=$(aws ec2 create-route-table \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=rt-publica}]" \
    --vpc-id "$VPC_ID" \
    --query 'RouteTable.RouteTableId' \
    --output text)

echo "Associando route table a subnet publica..."
aws ec2 associate-route-table \
    --route-table-id "$RTB_PUBL_ID" \
    --subnet-id "$SUBNET_PUBL_ID" 

echo "Criando rota..."
aws ec2 create-route \
    --route-table-id "$RTB_PUBL_ID" \
    --destination-cidr-block "0.0.0.0/0" \
    --gateway-id "$IGW_ID"

##### Criando NAT gateway #####

echo "Criando ip elastico..."
ALLOC_ID=$(aws ec2 allocate-address \
    --query "AllocationId" \
    --output text)

echo "Criando nat gateawy..."
NAT_GW_ID=$(aws ec2 create-nat-gateway \
    --subnet-id "$SUBNET_PUBL_ID" \
    --allocation-id "$ALLOC_ID" \
    --query 'NatGateway.NatGatewayId' \
    --output text)

##### Criando route table privada #####

echo "Criando route table privada..."
RTB_PRIV_ID=$(aws ec2 create-route-table \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=rt-privada}]" \
    --vpc-id "$VPC_ID" \
    --query 'RouteTable.RouteTableId' \
    --output text)

echo "Associando route table a subnet privada..."
aws ec2 associate-route-table \
    --route-table-id "$RTB_PRIV_ID" \
    --subnet-id "$SUBNET_PRIV_ID" 

echo "Criando rota..."
aws ec2 create-route \
    --route-table-id "$RTB_PRIV_ID" \
    --destination-cidr-block "0.0.0.0/0" \
    --nat-gateway-id "$NAT_GW_ID"

echo "Fim!"
