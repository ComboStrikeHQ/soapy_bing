desc 'Start the IRB console (short-cut alias: "c")'
task :console do
  sh 'irb -I .  -I ./lib -I ./spec  -r ./spec/spec_helper.rb'
end
task c: :console
