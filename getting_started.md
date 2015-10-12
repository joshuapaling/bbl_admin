Here's steps on how to start a new project "the BBL way". This is WIP. To get it really good, we'd have to spend a day or so creating "fake" new projects using the steps this guide, and just repeat till it's all smooth.

- create new rails project without test unit `rails new my_app -T`

- add the following to `.gitignore` (before your first commit!)

```
/public/uploads
/config/secrets.yml
/config/database.yml
/coverage
```

- `git init; git add .; git commit -m "initial commit"`
- add bitbucket project & push up. **Make sure you're in the BBL account, not your personal account!**
- [uninstall turbolink](http://blog.steveklabnik.com/posts/2013-06-25-removing-turbolinks-from-rails-4)
- set up postgres database: add `gem 'pg'`, remove `gem 'sqlite3'`, edit `database.yml`, and run `rake db:create` (also rake `db:create RAILS_ENV=test`):

```
# database.yml
default: &default
  adapter: postgresql
  pool: 5
  host: localhost
  timeout: 5000
  user: joshuapaling # your username

development:
  <<: *default
  database: my_app_dev

test:
  <<: *default
  database: my_app_test
```

# Set up Devise (Administrators and Users)

1. [Install devise](https://github.com/plataformatec/devise#getting-started)

Once installed, Generate devise models for Administrator and User (if you need it):
`rails generate devise Administrator`
`rails generate devise User`
`rake db:migrate`

In `config/initializers/devise.rb`:

- Set the `config.scoped_views` to `true`. (We'll want `Users` and `Administrators`)
- Set the `config.default_scope` to `administrator`.

In `app/models/administrator.rb`, remove `:registerable`

Add your first admin user:

`rails c`
`Administrator.create!({:email => "guy@gmail.com", :password => "12345678", :password_confirmation => "12345678" })`


Next, copy the following files from another existing BBL project:
`app/controllers/admin/base_controller.rb`
`app/views/admin/administrators/*`
`app/views/layouts/admin/*`
`app/views/layouts/admin.html.erb`

You should add required devise stuff to your `ApplicationController` - it should look something like:

```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  abstract!
  protect_from_forgery with: :exception
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :administrator
      'admin'
    elsif !current_user
      'signed_out'
    else
      'application'
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :administrator
      new_administrator_session_path
    else
      new_user_session_path
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a? Administrator
      admin_root_path
    else
      root_path
    end
  end

end
```

Create:
`app/assets/javascripts/admin.js` (all extra javascript files for admin should go in a /admin folder)
 with the contents:

```
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree ./admin/
```

create an empty folder at `app/assets/javascripts/admin/`

create
`app/assets/stylesheets/admin.scss` (all extra scss admin fiels should go int a /admin folder)
with the contents:

```
@import "bootstrap-sprockets";
@import "bbl_admin_bootstrap_vars";
@import "bootstrap";
@import "bbl_admin";
// @import "admin/your_other_styles";
```

Add to routes.rb:

```
  namespace :admin do
    resources :administrators, except: [:show]
    root 'administrators#index' # change this later
  end
```

Install `simple_form`:

`gem 'simple_form'`
then:
`rails generate simple_form:install —bootstrap`

Install bootstrap:

`gem 'bootstrap-sass', '~> 3.3.5'`

# Install the BBL admin gem:

    `gem 'bbl_admin', github: 'joshuapaling/bbl_admin', tag: 'vx.x.x`

You should specify a tag until the gem gets into a stable release.

### Controller

Generate controllers like so:

    rails generate controller namespace_name/controller_name

Use `admin` for the `namespace_name`. This will generate the admin folder and views. It will also add the admin namespace to the routes.rb file.

# Other stuff

Precompile additional assets - in  `config/initializers/assets.rb`:

```
Rails.application.config.assets.precompile += %w(
  admin.css
  admin.js
)
```

# Get the sign in page looking right

See: https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts

Don't forget to actually call the protected method. This method can be found in `application_controller.rb`

# Gems to use

For the sake of consistency between projects and minimising context switching penalty, when multiple gems fulfill a purpose we try and make the same choices between projects. This includes:

* Templating: erb. NOT slim, haml, etc.
* Image uploads: carrierwave
* Image manipulation: mini_magick
* Pagination: kaminari
* Ansible, if any "infrastructure as code" tool is used.

Handy Development gems:

```
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
```
