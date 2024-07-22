namespace :ruby do
  desc "Build testdata/dummy/"
  task :build_dummy do
    Dir.chdir(File.join(__dir__, "testdata", "dummy")) do
      sh "bundle config set --local path 'vendor/bundle'"
      sh "bundle install"
      sh "bundle exec rake all"
    end
  end
end

namespace :go do
  desc "Run go test"
  task :test do
    sh "go test -count=1 ${TEST_ARGS}"
  end

  desc "Run go test -race"
  task :testrace do
    sh "go test -count=1 ${TEST_ARGS} -race"
  end

  desc "Run go fmt"
  task :fmt do
    sh "go fmt ./..."
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
