Gem::Specification.new do |s|
  s.name        = 'tupp_model'
  s.version     = '1.0.0'
  s.date        = '2016-05-21'
  s.summary     = 'Business model for TUPP'
  s.description = 'Business model for TUPP'
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = ['lib/tupp.rb']
  s.license     = 'MIT'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.x'
end
