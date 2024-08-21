namespace :ruby do
  desc "Build testdata/example/"
  task :build_example do
    Dir.chdir(File.join(__dir__, "testdata", "example")) do
      sh "bundle config set --local path 'vendor/bundle'"
      sh "bundle install"
      sh "bundle exec rake all"
    end
  end
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

  ld_library_path = "#{RbConfig::CONFIG["libdir"]}:#{ENV["LD_LIBRARY_PATH"]}"

  {
    "CGO_CFLAGS" => cflags,
    "CGO_LDFLAGS" => ldflags,
    "LD_LIBRARY_PATH" => ld_library_path,
  }
end

namespace :go do
  desc "Run go test"
  task :test do
    sh env_vars, "go test -count=1 ${TEST_ARGS}"
  end

  desc "Run go test -race"
  task :testrace do
    sh env_vars, "go test -count=1 ${TEST_ARGS} -race"
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
end

namespace :patch_for_go_gem do
  desc "Run _tools/patch_for_go_gem test"
  task :test do
    Dir.chdir(File.join(__dir__, "_tools", "patch_for_go_gem")) do
      sh "bundle config set --local path 'vendor/bundle'"
      sh "bundle install"
      sh "bundle exec rspec"
    end
  end
end

desc "Create and push tag"
task :tag do
  version = File.read("VERSION")
  sh "git tag -a #{version} -m Release #{version}"
  sh "git push --tags"
end

desc "Release package"
task release: :tag do
  sh "git push origin main"
end

task default: "ruby:build_example"
