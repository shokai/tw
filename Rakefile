require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/tw'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'tw' do
  self.developer 'Sho Hashimoto', 'hashimoto@shokai.org'
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['oauth','>= 0.4.7', '< 1.0.0'],
                            ['twitter', '>= 3.7.0', '< 4.0.0'],
                            ['rainbow', '>= 1.1.4', '< 2.0.0']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
