class Rails::Widgets::Railtie < Rails::Railtie
  # # Rails-3.0.1 requires config.app_generators instead of 3.0.0's config.generators
  # generators = config.respond_to?(:app_generators) ? config.app_generators : config.generators
  # generators.integration_tool :rspec
  # generators.test_framework   :rspec

  rake_tasks do
    load "rspec/rails/tasks/rspec.rake"
  end

  generators do
    require 'rails/widget/generator'
  end

  initializer "rails_widgets.configure_rails_initialization" do |app|
    require 'rails/widgets/helpers'
    ActionView::Base.send :include, Rails::Widgets::Helpers
  end

  config.to_prepare do
    Rails::Widgets.setup!
  end
end
