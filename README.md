# sensu-transport-snssqs

`sensu-transport-snssqs` is a Sensu transport that produces messages over Amazon SNS and consumes messages from Amazon SQS, providing simplified monitoring of AWS environments using Sensu. 

Messages flow from hosts onto an Amazon SNS topic. It is up to the operator to ensure that messages from the SNS topic flow to one SQS queue for consumption by the Sensu server.

### Architecture

![architecture diag](arch.png)

Messages flow only one way: from the hosts being monitored to the Sensu server. In this diagram, there is an SNS topic created per environment. Hosts within these environments publish messages onto their environment's SNS topic. All of these SNS topics place messages onto one SQS queue. This singular SQS queue is used by our Sensu cluster to act on messages.

### Caveat

Subscription-based checks are not supported. Sensu subscriptions require the transport to be two-way: The Sensu server must be able to send a message through the transport to a specific host. SQS has no way of filtering messages in an SQS queue. Therefore, to use this transport, you must only use `standalone` checks.

## Installation

To use this `snssqs` transport, this gem must be in your Sensu installation's ruby include path.

If you're installing Sensu via Chef, you can use the `sensu_gem` resource to ensure the gem is in Sensu's ruby include path:

```
sensu_gem 'sensu-transport-snssqs' do
  action :install
end
```

Otherwise, if you're running Sensu via bundler, add this line to your Sensu installation's Gemfile:

```
gem 'sensu-transport-snssqs'
```

That should place this gem into the include path.

## Configuration

First, we need to enable the `snssqs` transport. To do so, ensure that the following `transport` clause is in your configuration:

```json
{
  "transport": {
    "name": "snssqs",
    "reconnect_on_error": true,
   }
}
```
Now that the SNSSQS transport has been enabled, configure it using an `snssqs` clause:

```json
{
  "snssqs": {
    "max_number_of_messages": 10,
    "wait_time_seconds": 2,
    "region": "{{ AWS_REGION }}",
    "consuming_sqs_queue_url": "{{ SENSU_QUEUE_URL }}",
    "publishing_sns_topic_arn": "{{ SENSU_SNS_ARN }}",
    },
}
```

What the settings do are described here:

| Setting                  | Description                                                                                                                                                                                                                                                                                                                  |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| max_number_of_messages   | The maximum number of messages to consume when consuming from SQS. This option is piped directly to the SQS client's `receive_message` call. Setting this to the maximum possible value is probably the best bet.                                                                                                                                                                                 |
| wait_time_seconds        | The number of seconds to wait while polling for messages from SQS. This option is a balancing act, as keeping it too high will cause Sensu's EventMachine reactor to block while waiting for messages. You typically want to set this to a low value. This option is piped directly to the SQS client's `receive_message` call. |
| region                   | The region to specify when initializing the AWS SNS and SQS clients.                                                                                                                                                                                                                                                         |
| consuming_sqs_queue_url  | The SQS Queue URL for which you want Sensu to consume from.                                                                                                                                                                                                                                                                  |
| publishing_sns_topic_arn | The SNS Topic ARN for which you want Sensu to publish messages to.                                                                                                                                                                                                                                                           |
