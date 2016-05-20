Gem::Specification.new do |s|
  s.name        = 'application'
  s.version     = '1.0.0'
  s.date        = '2016-04-17'
  s.summary     = 'Convenience classes for TUPP applications'
  s.description = 'Convenience classes for TUPP applications'
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = ['lib/application.rb']
  s.license     = 'MIT'

  s.add_runtime_dependency 'bunny'
end
