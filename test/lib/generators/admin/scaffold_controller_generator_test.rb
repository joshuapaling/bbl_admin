require 'test_helper'

module BblAdmin
  module Generators
    class ScaffoldControllerGeneratorTest < Rails::Generators::TestCase
      destination File.join(Rails.root)
      tests BblAdmin::Generators::ScaffoldControllerGenerator
      arguments %w(User name:string age:integer)

      setup :prepare_destination
      setup :copy_routes

      def test_controller_matches_expected
        run_generator

        assert_file "app/controllers/admin/users_controller.rb" do |content|
          path = File.expand_path('../../../../expected_files/users_controller.rb', __FILE__)
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

      def test_erb_views_are_generated
        run_generator

        %w(index edit new show).each do |view|
          assert_file "app/views/admin/users/#{view}.html.erb"
        end
      end

      # def test_functional_tests
      #   run_generator ["User", "name:string", "age:integer", "organization:references{polymorphic}"]

      #   assert_file "test/controllers/admin/users_controller_test.rb" do |content|
      #     assert_match(/class Admin::UsersControllerTest < ActionController::TestCase/, content)
      #     assert_match(/test "should get index"/, content)
      #     assert_match(/post :create, user: \{ age: @user\.age, name: @user\.name, organization_id: @user\.organization_id, organization_type: @user\.organization_type \}/, content)
      #     assert_match(/patch :update, id: @user, user: \{ age: @user\.age, name: @user\.name, organization_id: @user\.organization_id, organization_type: @user\.organization_type \}/, content)
      #   end
      # end

      # def test_functional_tests_without_attributes
      #   run_generator ["User"]

      #   assert_file "test/controllers/admin/users_controller_test.rb" do |content|
      #     assert_match(/class Admin::UsersControllerTest < ActionController::TestCase/, content)
      #     assert_match(/test "should get index"/, content)
      #     assert_match(/post :create, user: \{  \}/, content)
      #     assert_match(/patch :update, id: @user, user: \{  \}/, content)
      #   end
      # end

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
