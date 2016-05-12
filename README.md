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
| DS2                 |                                        | 172.16.1.4 |
| Datastore           |                                        | 172.16.1.5 |

### Services

#### RabbitMQ

Description pending.

#### RabbitMQ Management

Description pending.

#### PostgreSQL

Description pending.

#### DS2

Description pending.

#### Datastore

Description pending.

### Operation

1. A harvest request is added to the "requests" queue with routing key "harvest".
2. Harvesting receives the harvest request, instantiates the appropriate harvester and delegates execution to it.
3. The harvester starts harvesting, publishing the original file(s) to the "requests" queue with routing keys "store" and "extract"
   (perhaps the original file is not published but merely a reference to it).
4. Record extraction receives the original file and instantiates the appropriate extractor and delegates execution to it.
5. The record extractor extracts single records, publishing them to the "requests" queue with routing key "batch".
6. Batch generation receives the single records and batches them together with some predetermined batch size. The batches are then
   published to the "requests" queue with routing key "validate".
