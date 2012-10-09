require 'rubygems'
require 'bundler/setup'
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
  self.post_install_message = "!! Installed \"tw\" command. => http://shokai.github.com/tw"
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['oauth','>= 0.4.7', '< 1.0.0'],
                             ['twitter', '>= 4.0.0', '< 5.0.0'],
                             ['userstream', '>= 1.2.0', '< 1.3.0'],
                             ['json', '>= 1.7.5', '< 1.8.0'],
                             ['args_parser', '>= 0.1.1'],
                             ['rainbow', '>= 1.1.4', '< 2.0.0'],
                             ['parallel', '>= 0.5.18', '< 1.0.0']]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
