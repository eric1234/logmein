Gem::Specification.new do |s|
  s.name = 'logmein'
  s.version = '0.2.2'
  s.homepage = 'http://wiki.github.com/eric1234/logmein/'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rails', '> 3'
  s.add_dependency 'authlogic'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'test_engine'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.files = Dir['**/*.rb'] + Dir['**/*.erb']
  s.has_rdoc = true
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Sits on top of authlogic to provide app authentication'
  s.description = <<-DESCRIPTION
    A UI plugin that sits on top of authlogic to provide basic security
    (i.e. restricted access to certain actions) and a login screen to
    allow the user to get through security.
  DESCRIPTION
end
