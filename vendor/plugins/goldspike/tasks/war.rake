#
# Rake tasks for building a war file
#

# add the lib to the load path
plugin_dir = File.dirname(File.dirname(File.expand_path(__FILE__)))
$LOAD_PATH <<  File.join(plugin_dir, 'lib')

# load the library
require 'create_war'
require 'run'

# aliases for the tasks
task 'create_war' => ['war:standalone:create']
task 'create_war:standalone' => ['war:standalone:create']
task 'create_war:shared' => ['war:shared:create']
task 'war:create' => ['war:standalone:create']
task 'war:standalone' => ['war:standalone:create']
task 'war:shared' => ['war:shared:create']
task 'tmp:war:clean' => ['tmp:war:clear']

# create a standalone package
desc 'Create a self-contained Java war'
task 'war:standalone:create' do
  creator = War::Creator.new
  creator.standalone = true
  creator.create_war_file
end

# assemble the files for a standalone package
task 'war:standalone:assemble' do
  creator = War::Creator.new
  creator.standalone = true
  creator.assemble
end

# create a shared package
desc 'Create a war for use on a Java server where JRuby is available'
task 'war:shared:create' do
  creator = War::Creator.new
  creator.standalone = false
  creator.create_war_file
end

# clean up
desc "Clears all files used in the creation of a war"
task 'tmp:war:clear' do
  War::Creator.new.clean_war
end

# run the war file with jetty
desc "Run the webapp in Jetty"
task 'war:standalone:run' => ['war:standalone:assemble'] do
  War::Runner.new.run_standalone
end