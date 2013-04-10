// Usages
// $('.footer').widget().reload(); // only works on the first element
// $('.footer').widget('reload');  // works for all elements
!function(){
  this.Rails = this.Rails || {};


  Rails.widgets = {};

  Rails.widget = function(name, block){
    if (arguments.length === 0) return;

    var widget = Rails.widgets[name];

    if (widget === undefined){
      if (typeof block !== 'function') throw new Error('Widget '+name+' not defined.');
      Rails.widgets[name] = widget = createWidget(name);
    }

    if (block) block.call(widget.prototype, widget);
    return widget;
  };


  Rails.Widget = function(node){
    this.node = node;
    this.data = node.data();
    this.data.widget = this;
    this.initialize();
  };

  Rails.Widget.prototype.initialize = $.noop;

  jQuery.fn.widget = function(method){
    if (arguments.length === 0) return instantiateWidget(this);

    var args = toArray(arguments);
    var method = args.shift();

    var widgets = this.map(function(){ return $(this).widget(); });

    if (method === 'initialize') return this

    $.unique(widgets).each(function(i, widget){
      var func = widget[method];
      if (typeof func !== 'function')
        throw new Error(method+' is not a function on the '+widget.constructor.classname+' widget');
      func.apply(widget, args);
    });

    return this;
  }




  // private

  function createWidget(name) {
    function Widget(){ Rails.Widget.apply(this, arguments); }
    Widget.initialize = $.noop;
    Widget.prototype = Object.create(Rails.Widget.prototype);
    Widget.prototype.constructor = Widget;
    Widget.classname = name;
    Widget.selector = '.'+name;
    return Widget;
  };

  function instantiateWidget(element){
    element = $(element).first().closest('[widget]');
    var widget = element.data('widget');
    if (widget) return widget;
    var widget_name = element.attr('widget');
    if (!widget_name) return undefined;
    widget = Rails.widgets[widget_name]
    if (!widget) return undefined;
    widget = new widget(element);
    element.data('widget', widget);
    return widget;
  }

  function toArray(array) {
    return Array.apply(this, array)
  };


}();
