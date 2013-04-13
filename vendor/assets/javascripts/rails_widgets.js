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


  Rails.Widget = {
    create: function(node){
      widget = Object.create(this.prototype);
      widget.node = node;
      widget.data = node.data();
      widget.data.widget = this;
      widget.initialize();
      return widget;
    },
    initialize: noop,
    eventHandlerProxy: function(attr){
      var args = Array.prototype.slice.call(arguments, 1);
      var Widget = this;
      return function(){
        var widget = $(this).widget(Widget);
        widget[attr].apply(widget, args);
      }
    }
  };

  Rails.Widget.prototype = {
    initialize: noop
  };

  // private

  function createWidget(name) {
    // function Widget(){ Rails.Widget.apply(this, arguments); }
    Widget = Object.create(Rails.Widget);
    Widget.prototype = Object.create(Rails.Widget.prototype);
    Widget.classname = name;
    Widget.selector = '.'+name;
    return Widget;
  };

  function noop(){};

}();
