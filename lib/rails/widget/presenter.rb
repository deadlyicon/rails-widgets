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

  def self.arguments *names
    @arguments = names if names.present?
    @arguments ||= []
  end

  def self.options *options
    if options.present?
      @options = {}
      @options.merge! options.extract_options!
      options.each{|key| @options[key] = nil }
    end
     @options ||= {}
  end

  def self.locals
    @locals ||= {}
  end

  def self.local name, &block
    locals[name] = block
  end

  def self.node_type node_type=nil
    @node_type = node_type unless node_type.nil?
    @node_type || :div
  end

  def self.classname *classname
    @classname = HtmlOptions::Classnames.new + classname if classname.present?
    @classname || HtmlOptions::Classnames.new
  end

  def initialize view, *arguments, &block
    @view           = view
    @arguments      = arguments
    @block          = block
    @html_options   = HtmlOptions.new arguments.extract_options!
    @html_options.add_classname(self.name)
    @html_options[:class] += self.class.classname
    process_arguments!
    extract_options!
    populate_locals!
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
    @view.capture do
      @view.content_tag(self.class.node_type, html_options) do
        @view.concat begin
          @view.render(
            partial: "widgets/#{name}",
            locals: locals,
            formats: @view.formats + [:html],
            &block
          )
        end
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

  def extract_options!
    extracted_options, @html_options = @html_options, @html_options.slice!(*self.class.options.keys)
    locals.merge! extracted_options

    self.class.options.
      each{ |key, value|
        next unless locals[key].nil?
        next if value.is_a? Proc
        locals[key] = value
      }.
      each{ |key, value|
        next unless locals[key].nil?
        next unless value.is_a? Proc
        locals[key] = instance_eval(&value)
      }
  end

  def populate_locals!
    self.class.locals.each do |key, block|
      locals[key] = instance_eval(&block)
    end
  end

end
