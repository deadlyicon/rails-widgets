module Rails::Widgets::Rspec::PresenterExampleGroup

  extend ActiveSupport::Concern

  included do
    include ActionView::TestCase::Behavior

    let(:view){ @controller.view_context }
    let(:arguments){ [] }
    let(:html_options){ {} }
    let(:node_type){ :div }
    let(:block){ nil }
    let(:presenter){ described_class.new(view, *arguments, html_options, &block) }
    let(:classnames){ HtmlOptions::Classnames.new + presenter.html_options[:class] }
    let(:widget_name){ described_class.widget_name }

    subject{ presenter }

    define_method(:render){
      presenter.render(*arguments, html_options, &block)
    }

    it_should_behave_like "a widget presenter"
  end

  RSpec.configure do |config|
    config.include self,
      type: :widget,
      example_group: { file_path: %r(spec/widgets) }
  end

end
