
- create new rails project without test unit `rails new my_app -T`
- `git init; git add .; git commit -m "initial commit"`
- add bitbucket project & push up. **Make sure you're in the BBL account, not your personal account!**
- [uninstall turbolink](http://blog.steveklabnik.com/posts/2013-06-25-removing-turbolinks-from-rails-4)

# Set up Devise (Administrators and Users)

1. [Install devise](https://github.com/plataformatec/devise#getting-started)

Generate devise models for Administrator and User (if you need it):
`rails generate devise Administrator`
`rails generate devise User`
`rake db:migrate`

In `config/initializers/devise.rb`:

- Set the `config.scoped_views` to `true`. (We'll want `Users` and `Administrators`)
- Set the `config.default_scope` to `administrator`.

In `app/models/administrator.rb`, remove `:registerable`

-----

# Install the BBL admin gem:

    `gem 'bbl_admin', github: 'joshuapaling/bbl_admin', tag: 'vx.x.x`

You should specify a tag until the gem gets into a stable release.

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


