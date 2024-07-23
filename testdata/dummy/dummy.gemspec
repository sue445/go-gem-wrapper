# frozen_string_literal: true

require_relative "lib/dummy/version"

Gem::Specification.new do |spec|
  spec.name = "dummy"
  spec.version = Dummy::VERSION
  spec.authors = ["sue445"]
  spec.email = ["sue445@sue445.net"]

  spec.summary = "This is dummy gem for go-gem-wrapper test"
  spec.description = "This is dummy gem for go-gem-wrapper test"
  spec.homepage = "https://github.com/sue445/go-gem-wrapper"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["allowed_push_host"] = "https://do-not-push-this-gem.example.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/dummy/extconf.rb"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop_auto_corrector"
  spec.add_development_dependency "steep"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
