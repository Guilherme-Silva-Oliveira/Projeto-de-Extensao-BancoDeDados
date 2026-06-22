FROM mysql:8.0.26
COPY ./script_V4.sql /docker-entrypoint-initdb.d/
