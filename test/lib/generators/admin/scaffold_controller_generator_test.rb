require 'test_helper'

module BblAdmin
  module Generators
    class ScaffoldControllerGeneratorTest < Rails::Generators::TestCase
      destination File.join(Rails.root)
      tests BblAdmin::Generators::ScaffoldControllerGenerator
      arguments %w(BlogPost title:string content:text published:boolean category:references)

      setup :prepare_destination
      setup :copy_routes

      def test_controller_matches_expected
        run_generator

        assert_file "app/controllers/admin/blog_posts_controller.rb" do |content|
          path = File.expand_path('../../../../expected_files/blog_posts_controller.rb', __FILE__)
          expected_content = File.open(path, "rb").read
          assert_equal(expected_content, content)
        end
      end

      def test_dont_use_require_or_permit_if_there_are_no_attributes
        run_generator ["User"]

        assert_file "app/controllers/admin/users_controller.rb" do |content|
          assert_match(/def user_params/, content)
          assert_match(/params\[:user\]/, content)
        end
      end

      def test_index_view_matches_expected
        run_generator

        assert_file "app/views/admin/blog_posts/index.html.erb" do |content|
          path = File.expand_path('../../../../expected_files/index.html.erb', __FILE__)
          expected_content = File.open(path, "rb").read
          assert_equal(expected_content, content)
        end
      end

      def test_edit_view_matches_expected
        run_generator

        assert_file "app/views/admin/blog_posts/edit.html.erb" do |content|
          path = File.expand_path('../../../../expected_files/edit.html.erb', __FILE__)
          expected_content = File.open(path, "rb").read
          assert_equal(expected_content, content)
        end
      end

      def test_form_view_matches_expected
        run_generator

        assert_file "app/views/admin/blog_posts/_form.html.erb" do |content|
          path = File.expand_path('../../../../expected_files/_form.html.erb', __FILE__)
          expected_content = File.open(path, "rb").read
          assert_equal(expected_content, content)
        end
      end

      def test_only_wanted_views_are_generated
        run_generator

        %w(index edit _form).each do |view|
          assert_file "app/views/admin/blog_posts/#{view}.html.erb"
        end

        # For BBL Admin, we explicitly don't want show (we don't use it) and new (we use edit for that purpose)
        %w(show new).each do |view|
          assert_no_file "app/views/admin/blog_posts/#{view}.html.erb"
        end
      end

      def test_helpers_are_never_generated
        run_generator ["User", "name:string", "age:integer"] # explicitly DON'T include the "--no-helper" option; we never want it to include a helper, regardless of that option
        assert_no_file "app/helpers/admin/users_helper.rb"
        assert_no_file "test/helpers/admin/users_helper_test.rb"
      end

      def test_with_prefix_name
        run_generator ["User", "name:string", "age:integer", "--prefix_name=manager"]
        assert_file "app/controllers/manager/users_controller.rb" do |content|
          assert_match(/Manager\:\:UsersController/, content)
        end
      end

    end
  end
end
