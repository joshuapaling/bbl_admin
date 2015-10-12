Here's (WIP) steps on how to start a new project "the BBL way".

- create new rails project without test unit `rails new my_app -T`
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

- add the following to `.gitignore`

```
/public/uploads
/config/secrets.yml
/config/database.yml
/coverage
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

And create:
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



# Install the BBL admin gem:

    `gem 'bbl_admin', github: 'joshuapaling/bbl_admin', tag: 'vx.x.x`

You should specify a tag until the gem gets into a stable release.

### Controller

Generate controllers like so:

    rails generate controller namespace_name/controller_name

Use `admin` for the `namespace_name`. This will generate the admin folder and views. It will also add the admin namespace to the routes.rb file.

# Other stuff

Add a flag to precompile additional assets.

    Rails.application.config.assets.precompile += %w(
      admin.css
      admin.js
    )

Copy the `controller?` action from `helper/application_helper.rb`. Otherwise stuff breaks. (It's not a built in rails method).

# Get the sign in page looking right

See: https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts

Don't forget to actually call the protected method. This method can be found in `application_controller.rb`

# Gems to use

For the sake of consistency between projects and minimising context switching penalty, when multiple gems fulfill a purpose we try and make the same choices between projects. This includes:

* Templating: erb. NOT slim, haml, etc.
* Image uploads: carrierwave
* Pagination: kaminari
* Ansible, if any "infrastructure as code" tool is used.

