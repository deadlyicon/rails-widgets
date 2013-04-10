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

}();
