module Rails::Widgets::Helpers

  def render_widget name, *args, &block
    Rails::Widget[name].render(self, *args, &block)
  end

end
