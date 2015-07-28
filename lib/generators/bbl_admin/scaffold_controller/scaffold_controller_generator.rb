require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module BblAdmin
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: "Controller"

      check_class_collision suffix: "ControllerTest"

      class_option :orm, banner: "NAME", type: :string, required: true,
                   desc: "ORM to generate the controller for"

      class_option :html, type: :boolean, default: true,
                   desc: "Generate a scaffold with HTML output"

      class_option :prefix_name, banner: "admin", type: :string, default: "admin",
                   desc: "Define the prefix of controller"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def initialize(args, *options) #:nodoc:
        super
      end

      hook_for :resource_route, in: :rails do |resource_route|
        invoke resource_route, [prefixed_class_name]
      end

      def create_controller_files
        template "controllers/railties/controller.rb.erb", File.join('app/controllers', prefix, class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :helper, in: :rails do |helper|
        # We don't want helpers, so override the superclass and do nothing.
        # invoke helper, [prefixed_controller_class_name]
      end

      def create_views_root_folder
        empty_directory File.join("app/views", prefix, controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template_path = "views/#{handler}/#{filename}.erb"
          template template_path, File.join("app/views", prefix, controller_file_path, filename)
        end
      end

      protected

      def prefix
        options[:prefix_name]
      end

      def prefixed_class_name
        "#{prefix.capitalize}::#{class_name}"
      end

      def prefixed_controller_class_name
        "#{prefix.capitalize}::#{controller_class_name}"
      end

      def prefixed_route_url
        "/#{prefix}#{route_url}"
      end

      def prefixed_plain_model_url
        "#{prefix}_#{singular_table_name}"
      end

      def prefixed_index_helper
        "#{prefix}_#{index_helper}"
      end

      def available_views
        %w(index edit _form)
      end

      def format
        :html
      end

      def handler
        :erb
      end

      def filename_with_extensions(name)
        [name, format, handler].compact.join(".")
      end

      # Add a class collisions name to be checked on class initialization. You
      # can supply a hash with a :prefix or :suffix to be tested.
      #
      # ==== Examples
      #
      #   check_class_collision suffix: "Decorator"
      #
      # If the generator is invoked with class name Admin, it will check for
      # the presence of "AdminDecorator".
      #
      def self.check_class_collision(options={})
        define_method :check_class_collision do
          name = if self.respond_to?(:prefixed_controller_class_name) # for ScaffoldBase
            prefixed_controller_class_name
          elsif self.respond_to?(:prefixed_controller_class_name) # for ScaffoldBase
            controller_class_name
          else
            class_name
          end

          class_collisions "#{options[:prefix]}#{name}#{options[:suffix]}"
        end
      end

    end
  end
end
