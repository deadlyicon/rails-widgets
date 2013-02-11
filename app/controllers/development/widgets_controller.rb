class Development::WidgetsController < ApplicationController

  def index
    @widgets = ::Rails::Widget.all
  end

  def show
    @widget = ::Rails::Widget[params[:id]]
  end

end
