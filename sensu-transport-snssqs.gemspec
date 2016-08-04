Gem::Specification.new do |g|
  g.name = 'sensu-transport-snssqs'
  g.version = '2.0.3'
  g.summary = 'Sensu transport over Amazon SNS & SQS'
  g.authors = 'Tom Wanielista'
  g.files = ['lib/sensu/transport/snssqs.rb']
  g.homepage = 'https://github.com/SimpleFinance/sensu-transport-snssqs'
  g.add_dependency('aws-sdk')
  g.add_dependency('eventmachine')
  g.add_dependency('statsd-ruby')
end
