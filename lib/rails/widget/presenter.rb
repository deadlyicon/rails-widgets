require 'html_options'

class Rails::Widget::Presenter

  def self.widget_name
    @widget_name ||= name[/(^.+?)Widget$/,1].try(:underscore) if name
    @widget_name
  end

  def self.widget_name= widget_name
    @widget_name = widget_name
  end

  def self.render *arguments, &block
    new(*arguments, &block).render
  end


  def self.arguments *arguments
    unless defined?(@arguments)
      @arguments = []
      @arguments += superclass.arguments if superclass.respond_to? :arguments
    end
    if arguments.present?
      arguments.map(&:to_sym).each do |argument|
        @arguments << argument
        define_method(argument){ locals[argument] }
      end
    end
    @arguments
  end


  def self.options
    unless defined?(@options)
      @options = {}
      @options.merge! superclass.options if superclass.respond_to? :options
    end
    @options
  end

  def self.option(option, default_value=nil, &block)
    option = option.to_sym
    options[option] = block || default_value
    define_method(option){ locals[option] }
  end


  def self.html_options
    unless defined?(@html_options)
      @html_options = {}
      @html_options.merge! superclass.html_options if superclass.respond_to? :html_options
    end
    @html_options
  end

  def self.html_option(html_option, default_value=nil, &block)
    html_option = html_option.to_sym
    html_options[html_option] = block || default_value
    define_method(html_option){ locals[html_option] }
  end


  def self.node_type node_type=nil
    @node_type = node_type unless node_type.nil?
    @node_type || :div
  end

  def self.classname *classname
    @classname ||= HtmlOptions::Classnames.new
    @classname += classname if classname.present?
    @classname
  end

  def initialize view, *arguments, &block
    @view           = view
    @arguments      = arguments
    @block          = block
    @html_options   = HtmlOptions.new arguments.extract_options!
    @html_options.add_classname(self.name)
    @html_options[:class] += self.class.classname
    @html_options[:widget] = self.name
    process_arguments!
    process_options!
    process_html_options!
    init
  end

  def init
  end

  attr_reader :view, :block, :html_options

  def name
    self.class.widget_name
  end

  def locals
    @locals ||= {
      presenter: self,
      block: block,
    }
  end

  def render
    content = @view.render(
      partial: "widgets/#{name}",
      locals: locals,
      formats: @view.formats + [:html]
    )
    @view.capture do
      @view.content_tag(self.class.node_type, html_options) do
        @view.concat(content)
      end
    end
  end

  def inspect
    @arguments.present? ?
      %[#<#{self.class} #{@arguments.map(&:inspect).join(' ')}>] :
      %[#<#{self.class}>]
  end

  private

  def process_arguments!
    if @arguments.length != self.class.arguments.length
      raise ArgumentError, "wrong number of arguments. Expected #{self.class.arguments.inspect}.", caller(1)
    end
    self.class.arguments.zip(@arguments).each do |name, value|
      locals[name] = value
    end
  end

  def process_options!
    extracted_options, @html_options = @html_options, @html_options.slice!(*self.class.options.keys)
    locals.merge! extracted_options

    self.class.options.each{ |key, value|
      next if locals.has_key? key
      locals[key] = value.respond_to?(:to_proc) ? instance_eval(&value) : value
    }
  end

  def process_html_options!
    self.class.html_options.each{ |key, value|
      next if html_options.has_key? key
      html_options[key] = value.respond_to?(:to_proc) ? instance_eval(&value) : value
    }
  end

end
