jQuery.fn.widget = function(method){
  var element, widget, widget_name, args, method, widgets;

  if (arguments.length === 0){
    element = this.first().closest('[widget]');

    widget = element.data('widget');
    if (widget) return widget;

    widget_name = element.attr('widget');
    if (!widget_name) return undefined;

    widget = Rails.widgets[widget_name]
    if (!widget) return undefined;

    widget = new widget(element);

    element.data('widget', widget);
    return widget;
  }

  args = Array.apply(this, arguments);
  method = args.shift();

  widgets = this.map(function(){ return $(this).widget(); });

  if (method !== 'initialize'){
    $.unique(widgets).each(function(i, widget){
      var func = widget[method];
      if (typeof func !== 'function')
        throw new Error(method+' is not a function on the '+widget.constructor.classname+' widget');
      func.apply(widget, args);
    });
  }

  return this;
};
