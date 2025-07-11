# Capfile

# 1. Basic Capistrano setup
require "capistrano/setup"
require "capistrano/deploy"

# 2. SCM choice
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# 3. Ruby & Bundler integration
require "capistrano/rbenv"       # or RVM/chruby if you prefer
require "capistrano/bundler"

# 4. Rails helpers (assets & migrations)
#require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# 5. Puma (using capistrano3-puma)
require "capistrano/puma"

# 6. Any custom tasks
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
