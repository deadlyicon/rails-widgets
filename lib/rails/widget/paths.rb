class Rails::Widget::Paths

  include Enumerable

  NAMES = %w{
    view
    view_spec
    example
    example_spec
    presenter
    presenter_spec
    javascript
    javascript_spec
    sass
  }.map(&:to_sym).freeze

  def initialize name
    @name = name
  end

  def view
    root + "app/views/widgets/_#{@name}.html.haml"
  end

  def view_spec
    root + "spec/views/widgets/#{@name}_spec.rb"
  end

  def example
    root + "app/views/development/widgets/examples/_#{@name}.html.haml"
  end

  def example_spec
    root + "spec/views/development/widgets/examples/#{@name}_spec.rb"
  end

  def presenter
    root + "app/widgets/#{@name}_widget.rb"
  end

  def presenter_spec
    root + "spec/widgets/#{@name}_widget_spec.rb"
  end

  def javascript
    root + "app/assets/javascripts/widgets/#{@name}.js"
  end

  def javascript_spec
    root + "spec/javascripts/widgets/#{@name}_spec.js"
  end

  def sass
    root + "app/assets/stylesheets/widgets/_#{@name}.sass"
  end

  def each(&block)
    NAMES.map(&method(:send)).each(&block)
  end

  def required
    required_paths  = [view, view_spec, example, example_spec]
    required_paths += [javascript, javascript_spec] if javascript.exist?
    required_paths += [presenter, presenter_spec] if presenter.exist?
    required_paths
  end

  private

  def root
    Rails.root
  end

end

