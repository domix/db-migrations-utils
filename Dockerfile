ARG FW_IMAGE=flyway/flyway:8.5.13
ARG DB_MIGRATION_DIR=./migrations
FROM $FW_IMAGE

ADD $DB_MIGRATION_DIR /flyway/sql
