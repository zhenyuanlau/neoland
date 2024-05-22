# RabbitMQ

## CLI

```shell
rabbitmqctl add_vhost test

rabbitmqctl set_permissions -p test admin ".*" ".*" ".*"

rabbitmqadmin -V test list exchanges

rabbitmqadmin -V test declare exchange name=test-fanout-exchange type=fanout -u admin -p admin

rabbitmqadmin -V test publish exchange=test-fanout-exchange routing_key=""  payload="{\"a\": 1, \"b\": [1,2]}"
```
