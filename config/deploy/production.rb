server 'studentkickoff.be', user: 'events', roles: %w{web app db}

set :rails_env, 'production'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
