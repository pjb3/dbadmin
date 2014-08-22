# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Barry"]
  gem.email         = ["mail@paulbarry.com"]
  gem.description   = %q{A web-based DB GUI for MySQL, Postgres, SQLite, etc.}
  gem.summary       = %q{A web-based DB GUI for MySQL, Postgres, SQLite, etc.}
  gem.homepage      = "http://github.com/pjb3/dbadmin"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "dbadmin"
  gem.require_paths = ["lib"]
  gem.version       = "0.2.0"

  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "sequel"
  gem.add_runtime_dependency "sinatra"
end
