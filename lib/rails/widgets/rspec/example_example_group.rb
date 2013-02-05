module Rails::Widgets::Rspec::ExampleExampleGroup

  extend ActiveSupport::Concern

  included do

    before do
      controller.class.helper Rails::Widgets::Helpers
    end

    let(:widget_name){
      metadata = example.metadata
      metadata = metadata[:example_group] while metadata[:example_group].present?
      metadata[:description_args].first.scan(/^(.+) example$/).first.first
    }

    let(:widget){ Rails::Widget[widget_name] }

    subject{
      view.render partial: "development/widgets/examples/#{widget_name}"
    }

    let(:html){ Nokogiri::HTML.fragment(subject) }

  end

  RSpec.configure do |config|
    config.include self, example_group: { file_path: %r(spec/views/development/widgets) }
  end

end
