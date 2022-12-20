require 'gem2deb/rake/testtask'

spec=Dir.glob("/usr/share/rubygems-integration/**/specifications/eventmachine*.gemspec").first
if ENV["AUTOPKGTEST_TMP"]
  GEMSPEC=Gem::Specification.load(spec)
else
  GEMSPEC=Gem::Specification.load(File.expand_path("../../eventmachine.gemspec", __FILE__))
end

disabled_tests= [
  'tests/test_idle_connection.rb',
  'tests/test_get_sock_opt.rb',
  'tests/test_set_sock_opt.rb',
]

ENV['TESTOPTS'] = '-v'

Gem2Deb::Rake::TestTask.new(:spec) do |t|
  t.libs = ['tests']
  t.test_files = FileList['tests/**/test_*.rb'] - disabled_tests
  t.verbose = true
end

task :default do
  ipv4 = IO.popen(["ip", "-4", "addr", "show", "lo"]).read
  if ipv4.empty?
    puts "W: loopback interface has no ipv4 stack, skipping tests"
  else
    Rake::Task[:spec].invoke
  end
end
