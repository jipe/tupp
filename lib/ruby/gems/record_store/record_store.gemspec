Gem::Specification.new do |s|
  s.name        = 'record_store'
  s.version     = '1.0.0'
  s.date        = '2017-12-08'
  s.summary     = 'Storage functionality for TUPP models'
  s.description = 'Storage functionality for TUPP models'
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = Dir['{lib}/**/*.rb']
  s.license     = 'MIT'

  s.add_runtime_dependency 'model'
  s.add_runtime_dependency 'mongo'
end
