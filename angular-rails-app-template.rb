def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# Gemfile manipulations

gem 'sass', '3.2.19'
gem 'bower-rails'
gem 'angular-rails-templates'

gem 'foreman'
gem_group :production, :staging do
  gem 'rails_12factor'
  gem 'rails_stdout_logging'
  gem 'rails_serve_static_assets'
end

gsub_file 'Gemfile', /^gem\s+["']turbolinks["'].*$/,''

# Bower

copy_file 'Bowerfile'

run 'bundle install'

rake 'bower:install'

application do <<-CODE
    config.assets.paths << Rails.root.join("vendor","assets","bower_components")
    config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")
    config.assets.precompile << %r(.*.(?:eot|svg|ttf|woff|woff2)$)
  CODE
end

# git

append_file '.gitignore', '/node_modules'

# Templates and files

inside 'app' do
  inside 'views' do
    inside 'home' do
      template 'index.html.erb'
    end
  end

  inside 'controllers' do
    copy_file 'home_controller.rb'
  end

  inside 'assets' do
    inside 'javascripts' do
      inside 'controllers' do 
        copy_file 'IndexController.coffee'
      end

      inside 'templates' do
        template 'index.html'
      end

      template 'app.coffee'
      gsub_file 'application.js', /^\/\/=\s+require\s+turbolinks.*$/, ''
      insert_into_file 'application.js', :before => '//= require_tree .' do <<-CODE
//= require angular/angular
//= require angular-route/angular-route
//= require angular-rails-templates
//= require angular-resource/angular-resource
//= require angular-flash/dist/angular-flash
//= require app
      CODE
      end
    end

    inside 'stylesheets' do
      copy_file 'application.css.scss'
      remove_file 'application.css'
    end
  end
end

# Routes

route "root 'home#index'"

