Gem::Specification.new do |s|
  s.name        = 'orphanage'
  s.version     = '0.2.0'
  s.date        = '2017-03-30'
  s.summary     = "A simple library for storing temporary orphan records."
  s.description = s.summary
  s.authors     = ["Jacob Stoebel"]
  s.email       = 'jstoebel@gmail.com'
  s.files =     Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/jstoebel/orphanage'
  s.license     = 'MIT'

  s.add_development_dependency 'activerecord', '~> 5.0', '>= 5.0.2'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  s.add_development_dependency 'pry', '~> 0.10.4'
  s.add_development_dependency 'rails', '~> 5.0'
end
