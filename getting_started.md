
- create new rails project without test unit `rails new my_app -T`
- `git init; git add .; git commit -m "initial commit"`
- add bitbucket project & push up
- [uninstall turbolink](http://blog.steveklabnik.com/posts/2013-06-25-removing-turbolinks-from-rails-4)

# Setting up Gems

1. Install the Devise gem. See their [Getting Started](https://github.com/plataformatec/devise#getting-started) guide.

We need to customise the Devise files. In `config/initializers/devise.rb`.

- Set the `config.scoped_views` to `true`.
- Set the `config.default_scope` to `administrator`.

2. Install the BBL admin gem. Via the command:
    `gem 'bbl_admin', github: 'joshuapaling/bbl_admin', tag: 'vx.x.x`

You should probably specify a tag until the gem gets into a stable release.

(If you want to read more about installing gems from git repos. Check out the bundler guide: http://bundler.io/git.html).

# Generating the models and controllers

## Generating Admin model and controller

### Model
1. Run `rails generate devise Administrator` to set up the administrator model.
2. Run the migrations `rake db:migrate`.
3. Remove `:registerable` option from `administrator.rb`.

### Controller

Generate controllers like so:

    rails generate controller namespace_name/controller_name

Use `admin` for the `namespace_name`. This will generate the admin folder and views. It will also add the admin namespace to the routes.rb file.

### Plugging the admin model into bbl admin area

Assuming you have already generated controllers/views with the bbl_admin gem.

1. Copy the `controllers/administrators_controller.rb` file to `controllers/admin` directory.
2. Copy the `views/administrators` folder into `views/admin` directory.

Make sure whatever your route controller is inherits from `Admin::BaseController` rather than application controller. You know if it's inheriting from application controller if your footer and header is the same as the front end. *(probably need to rewrite this sentence)*

# Other stuff

Add a flag to precompile additional assets.

    Rails.application.config.assets.precompile += %w(
      admin.css
      admin.js
    )

You will need to edit the admin top bar to fit the menu for your project.

Copy the `controller?` action from `helper/application_helper.rb`. Otherwise stuff breaks. (It's not a built in rails method).

# Get the sign in page looking right

See: https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts

Don't forget to actually call the protected method. This method can be found in `application_controller.rb`


