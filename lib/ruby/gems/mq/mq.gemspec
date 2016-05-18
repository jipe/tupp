Gem::Specification.new do |s|
  s.name        = 'mq'
  s.version     = '1.0.0'
  s.date        = '2016-05-13'
  s.summary     = 'Application specific wrapper or 3rd party message queue'
  s.description = ''
  s.authors     = ['Jimmy Petersen']
  s.email       = 'jipe@dtu.dk'
  s.files       = ['lib/mq.rb']
  s.license     = 'MIT'

  s.add_runtime_dependency 'bunny'
end
