require 'gem2deb/rake/testtask'

spec=Dir.glob("/usr/share/rubygems-integration/**/specifications/eventmachine*.gemspec").first
if ENV["AUTOPKGTEST_TMP"]
  GEMSPEC=Gem::Specification.load(spec)
else
  GEMSPEC=Gem::Specification.load(File.expand_path("../../eventmachine.gemspec", __FILE__))
end

disabled_tests= [
  'tests/test_exc.rb',
  'tests/test_get_sock_opt.rb',
  'tests/test_httpclient2.rb',
  'tests/test_httpclient.rb',
  'tests/test_idle_connection.rb',
  'tests/test_inactivity_timeout.rb',
  'tests/test_kb.rb',
  'tests/test_pending_connect_timeout.rb',
  'tests/test_resolver.rb',
  'tests/test_set_sock_opt.rb',
  'tests/test_unbind_reason.rb',
]

ENV['TESTOPTS'] = '-v'

Gem2Deb::Rake::TestTask.new(:spec) do |t|
  t.libs = ['tests']
  t.test_files = FileList['tests/**/test_*.rb'] - disabled_tests
  t.verbose = true
end

task :default do
  ipv4 = `ip -4 address | grep inet | wc -l`.strip.to_i
  if ipv4 <= 1
    puts "W: just loopback interface or none has IPv4 address, this might be a IPv6 builder. Skipping tests..."
  else
    Rake::Task[:spec].invoke
  end
end
