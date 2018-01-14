Gem::Specification.new do |s|
  s.name        = 'model'
  s.version     = '1.0.0'
  s.date        = '2016-05-21'
  s.summary     = 'Model objects for TUPP'
  s.description = 'Model objects for TUPP'
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = Dir['{lib}/**/*.rb']
  s.license     = 'MIT'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.x'
end
