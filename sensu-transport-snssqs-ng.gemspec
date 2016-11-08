Gem::Specification.new do |g|
  g.name = 'sensu-transport-snssqs-ng'
  g.version = '2.0.4'
  g.summary = 'Sensu transport over Amazon SNS & SQS'
  g.authors = ['Troy Ready']
  g.email = 'troy.ready+gems@gmail.com'
  g.cert_chain  = ['certs/troyreadygems.pem']
  g.signing_key = File.expand_path('~/.gem/gem-private_key.pem') if $0 =~ /gem\z/
  g.files = ['lib/sensu/transport/snssqs.rb']
  g.homepage = 'https://github.com/troyready/sensu-transport-snssqs-ng'
  g.licenses = ['Apache-2.0']
  g.add_dependency('aws-sdk')
  g.add_dependency('eventmachine')
  g.add_dependency('statsd-ruby')
end
