desc 'Run specs and collect code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].invoke
end
task cov: :coverage
