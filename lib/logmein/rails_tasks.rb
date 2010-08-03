# Some glue to make it easy to include Rails-specific rake tasks in
# your Rails application. Simply put the following at the bottom of
# your Rakefile:
#
#   require 'logmein/rails_tasks'
glob = "#{Gem.searcher.find('logmein').full_gem_path}/lib/tasks/*.rake"
Dir[glob].each {|ext| load ext}