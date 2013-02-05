class Rails::WidgetGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../generator/templates', __FILE__)

  argument :name, :type => :string

  Rails::Widget::Paths::NAMES.each do |file_name|
    class_option file_name, type: :boolean, default: true, desc: "Generate #{file_name}"

    define_method(file_name) do
      return unless options[file_name]
      template "#{file_name}", widget.paths.send(file_name)
    end
  end

  private

  def widget
    @widget ||= Rails::Widget.new(name)
  end

  def app_name
    @app_name ||= Rails.application.class.name.split('::').first
  end

  def javascript_object_name
    "#{app_name}.#{widget.name.camelize}Widget"
  end

end
