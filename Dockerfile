FROM mysql:8.0.26
COPY ./script_V3_sax.sql /docker-entrypoint-initdb.d/
