Gem::Specification.new do |s|
  s.name        = 'datastore'
  s.version     = '1.0.0'
  s.date        = '2016-04-17'
  s.summary     = 'API for talking to the DTIC datastore'
  s.description = 'API for talking to the DTIC datastore'
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = ['lib/datastore.rb']
  s.license     = 'MIT'

  s.add_runtime_dependency 'bunny', '~> 2.3.x'
end
