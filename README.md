# TUPP - The Unified Processing Pipeline

TUPP is the unified processing pipeline for DTU Library operations. This mostly revolves around fetching, processing and
indexing of metadata records for scientific publications.

## Running a local development setup

Be sure to install Docker Engine and Docker Compose (see https://docs.docker.com/compose/install/).

Run `docker-compose up` from the project root folder. You should now have the following services:

| Service             | URL                                    | IP         |
|---------------------|----------------------------------------|------------|
| RabbitMQ            | amqp://guest:guest@172.16.1.2:5672     | 172.16.1.2 |
| RabbitMQ Management | http://guest:guest@172.16.1.2:15672    | 172.16.1.2 |
| PostgreSQL          | postgresql://tupp:tupp@172.16.1.3:5432 | 172.16.1.3 |
| TUPP Management     | http://172.16.1.4:3000                 | 172.16.1.4 |

### Services

#### RabbitMQ

The message queueing system used for flow control throughout the application.

#### RabbitMQ Management

The administrative frontend for the RabbitMQ service. Here you can watch queues and associated performance bottlenecks.

#### PostgreSQL

The database management system used by the application.

#### TUPP Management

Administrative web application for triggering harvests, watching status, ...

### Operation

#### Overview

1.  A harvest request is published to the "requests" exchange with routing key "harvest".
2.  Harvesting receives the harvest request, instantiates the appropriate harvester and delegates execution to it.
3.  The harvester starts harvesting, publishing the original file(s) to the "requests" exchange with routing keys "store" and "extract"
    (perhaps the original file is not published but merely a reference to it).
4.  Record extraction receives the original file, instantiates the appropriate extractor and delegates execution to it.
5.  The record extractor extracts single records, publishing them to the "requests" exchange with routing key "validate.original".
6.  Record validation receives records to be validated, instantiates the appropriate validator and delegates execution to it.
7.  The record validator checks whether the records conform to the constraints for the provider. If a record is found to be valid,
    it is published to the "requests" exchange with routing key "transform". If it is found to be invalid, it is published to the
    "errors" exchange with routing key "validate.original".
8.  Record transformation receives records to be transformed, instantiates the appropriate transformer and
    delegates execution to it.
9.  The record transformer transforms the records to a unified format, publishing the results to the "requests" exchange with routing
    key "validate.unified".
10. Unified record validation receives the records to be validated and checks that they conform to the unified format specification.
    If a record is found to be valid, it is published to the "requests" exchange with routing keys "group.indicate" and "publish". 
    If it is found to be invalid, it is published to the "errors" exchange with routing key "validate.unified".
11. The grouping indicator receives records and tries to find similar records in any of the previously processed records. If a
    record is found, the new record is given the same grouping key as the found record. If more records with different grouping
    keys are found, the new record is given the oldest grouping key, and the records are updated with the oldest grouping key
    as well. Results are published to the "requests" exchange with routing keys "publish" and "group.generate".

#### 1. Harvest requests

#### 2. Instantiation of harvesters

#### 3. Harvesting behavior
