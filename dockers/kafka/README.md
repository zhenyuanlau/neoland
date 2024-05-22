# Kafka

## CLI

```shell
# docker run --rm -it --network=kafka-tutorial edenhill/kcat:1.7.1 kcat -b kafka:9092 -L
# docker exec -it $(docker ps -q --filter "label=com.docker.compose.service=kafka") /bin/bash
docker exec broker \
kafka-topics --bootstrap-server broker:9092 \
             --create \
             --topic quickstart

kcat -L -b localhost:9092 -t quickstart

kcat -C -b localhost:9092 -t test
```
