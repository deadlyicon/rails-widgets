shared_examples_for "a widget presenter" do

  describe "#name" do
    subject{ presenter.name }
    it { should == widget_name }
  end

  describe ".node_type" do
    subject{ described_class.node_type }
    it { should == node_type }
  end

  describe "#render" do
    it "should render widgets/#{described_class.widget_name}" do

      action_view_missing_template = Class.new(ActionView::MissingTemplate){ def initialize(*); end }

      view.should_receive(:render).with(
        partial: "widgets/#{widget_name}",
        locals: presenter.locals,
        formats: view.formats + [:html],
        &presenter.block
      ).and_return('WIDGET CONTENT')

      presenter.render.should == view.content_tag(node_type, presenter.html_options){ 'WIDGET CONTENT' }
    end
  end

end

shared_examples_for "a widget example" do

  it "should render at least one example" do
    html.css(".#{widget_name}").should be_present
  end

end

