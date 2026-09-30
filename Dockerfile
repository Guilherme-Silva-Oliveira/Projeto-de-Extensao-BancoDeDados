FROM mysql:8.0.26
ARG SCRIPT=./scripts/V3_sax_script.sql
COPY ${SCRIPT} /docker-entrypoint-initdb.d/
ARG SEED
COPY ${SEED} /docker-entrypoint-initdb.d/

