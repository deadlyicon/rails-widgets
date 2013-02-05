class Rails::Widget

  Error = Class.new(StandardError)

  def self.all
    Dir[Rails.root.join('app/views/widgets/*.*.*')].
      map{|path| path[%r{/_([^/]+)\..*\..*\.*$}, 1] }.
      compact.
      map{|name| new(name) }
  end

  def self.[] name
    new(name).present?
  end

  def initialize name
    @name = name.to_s.underscore
  end

  attr_reader :name

  NotFoundError = Class.new(Error)
  def present?
    raise NotFoundError, name unless paths.view.exist?
    return self
  end

  InvalidError = Class.new(Error)
  def valid?
    raise InvalidError, name unless paths.required.all?(&:exist?)
    return self
  end

  def render view, *arguments, &block
    presenter.render(view, *arguments, &block)
  end

  def paths
    @paths ||= Paths.new name
  end

  def inspect
    %[#<#{self.class} #{name}>]
  end

  def presenter
    @presenter ||= begin
      "#{name.camelize}Widget".constantize
    rescue NameError
      Class.new(Rails::Widget::Presenter).tap{|presenter|
        presenter.widget_name = name
      }
    end
  end

end

require 'rails/widget/paths'
