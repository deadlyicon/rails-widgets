require "rails/widgets/version"
require 'rails'

module Rails::Widgets

  def self.setup!
    generate_sass!
  end

  def self.generate_sass!
    Rails.root.join('app/assets/stylesheets/_widgets.sass').open('w') do |file|
      Rails::Widget.all.each do |widget|
        next unless widget.paths.sass.exist?
        file.write %(.#{widget.name}\n  @import "widgets/#{widget.name}"\n)
      end
    end
  end

end

require 'rails/widgets/engine'
require 'rails/widgets/railtie'

require 'rails/widget'
require 'rails/widget/presenter'
