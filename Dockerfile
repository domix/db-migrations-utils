ARG FW_IMAGE=flyway/flyway:8.5.13
FROM $FW_IMAGE

ARG DB_MIGRATION_DIR=./migrations

ADD $DB_MIGRATION_DIR /flyway/sql
