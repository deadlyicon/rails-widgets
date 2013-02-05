module Rails::Widgets::Rspec::ViewExampleGroup

  extend ActiveSupport::Concern

  included do

    before do
      controller.class.helper Rails::Widgets::Helpers
    end

    let(:return_value){ view.render partial: "widgets/#{widget_name}", locals: locals }
    let(:html){ Nokogiri::HTML.fragment(return_value) }

    subject{ html }
  end

  def locals
    {}
  end

  def widget_name
    metadata = example.metadata
    while metadata[:example_group].present?
      metadata = metadata[:example_group]
    end
    return metadata[:description_args].first
  end

  RSpec.configure do |config|
    config.include self, example_group: { file_path: %r(spec/views/widgets) }
  end

end
