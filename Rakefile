# frozen_string_literal: true

require "rubocop/rake_task"

RuboCop::RakeTask.new("ruby:rubocop")

namespace :ruby do
  namespace :example do
    desc "Build ruby/testdata/example/"
    task :build do
      Dir.chdir(File.join(__dir__, "ruby", "testdata", "example")) do
        sh "bundle exec rake all"
      end
    end
  end

  namespace :rbs do
    desc "`rbs collection install` and `git commit`"
    task :install do
      sh "rbs collection install"
      sh "git add rbs_collection.lock.yaml"
      sh "git commit -m 'rbs collection install' || true"
    end
  end

  desc "Check rbs"
  task :rbs do
    sh "rbs validate"
    sh "steep check"
  end

  desc "Run all build tasks in ruby"
  task build_all: %w[example:build rubocop rbs]
end

# @return [Hash<String, String>]
def env_vars
  ldflags = "-L#{RbConfig::CONFIG["libdir"]} -l#{RbConfig::CONFIG["RUBY_SO_NAME"]}"

  case `#{RbConfig::CONFIG["CC"]} --version` # rubocop:disable Lint/LiteralAsCondition
  when /Free Software Foundation/
    ldflags << " -Wl,--unresolved-symbols=ignore-all"
  when /clang/
    ldflags << " -undefined dynamic_lookup"
  end

  cflags = "#{RbConfig::CONFIG["CFLAGS"]} -I#{RbConfig::CONFIG["rubyarchhdrdir"]} -I#{RbConfig::CONFIG["rubyhdrdir"]}"

  # FIXME: Workaround for GitHub Actions
  if ENV["GITHUB_ACTIONS"]
    cflags.gsub!("-Wno-self-assign", "")
    cflags.gsub!("-Wno-parentheses-equality", "")
    cflags.gsub!("-Wno-constant-logical-operand", "")
    cflags.gsub!("-Wsuggest-attribute=format", "")
    cflags.gsub!("-Wold-style-definition", "")
    cflags.gsub!("-Wsuggest-attribute=noreturn", "")
    ldflags.gsub!("-Wl,--unresolved-symbols=ignore-all", "")
  end

  ld_library_path = RbConfig::CONFIG["libdir"]

  {
    "CGO_CFLAGS"      => cflags,
    "CGO_LDFLAGS"     => ldflags,
    "LD_LIBRARY_PATH" => ld_library_path,
  }
end

namespace :go do
  desc "Run go test"
  task :test do
    sh env_vars, "go test -mod=readonly -count=1 #{ENV["GO_TEST_ARGS"]} ./..."
  end

  desc "Run go test -race"
  task :testrace do
    sh env_vars, "go test -mod=readonly -count=1 #{ENV["GO_TEST_ARGS"]} -race  ./..."
  end

  desc "Run go fmt"
  task :fmt do
    sh "go fmt ./..."
  end

  desc "Run golangci-lint"
  task :lint do
    sh "which golangci-lint" do |ok, _|
      raise "golangci-lint isn't installed. See. https://golangci-lint.run/welcome/install/" unless ok
    end
    sh env_vars, "golangci-lint run"
  end

  desc "Run all build tasks in go"
  task build_all: %i[test fmt lint]
end

namespace :patch_for_go_gem do
  desc "Run _tools/patch_for_go_gem test"
  task :test do
    Dir.chdir(File.join(__dir__, "_tools", "patch_for_go_gem")) do
      sh "rspec"
    end
  end
end

namespace :ruby_h_to_go do
  desc "Run _tools/ruby_h_to_go test"
  task :test do
    Dir.chdir(File.join(__dir__, "_tools", "ruby_h_to_go")) do
      sh "rspec"
    end
  end
end

namespace :go_gem do
  desc "Run go_gem test"
  task :test do
    Dir.chdir(File.join(__dir__, "gem")) do
      sh "rspec"
    end
  end
end

desc "Run _tools/ruby_h_to_go"
task :ruby_h_to_go do
  sh "./_tools/ruby_h_to_go/exe/ruby_h_to_go"
end

desc "Release package"
task :release do
  Dir.chdir(File.join(__dir__, "gem")) do
    sh "rake release"
  end
end

task build_all: %w[ruby:build_all go:build_all go_gem:test ruby_h_to_go:test patch_for_go_gem:test]

task default: :build_all
