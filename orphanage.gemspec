Gem::Specification.new do |s|
  s.name        = 'orphanage'
  s.version     = '0.0.0'
  s.date        = '2017-03-30'
  s.summary     = "A simple library for storing temporary orphan records."
  s.description = "A simple library for storing temporary orphan records."
  s.authors     = ["Jacob Stoebel"]
  s.email       = 'jstoebel@gmail.com'
  s.files       = ["lib/orphanage.rb"]
  s.homepage    =
    'https://github.com/jstoebel/orphanage'
  s.license       = 'MIT'

  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
end
