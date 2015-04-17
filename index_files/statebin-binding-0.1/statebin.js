HTMLWidgets.widget({

  name: 'statebin',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {
     x.data = HTMLWidgets.dataframeToD3(x.data)
     var mystatemap = statemap(x.opts)
     d3.select(el)
      .datum(x.data)
      .call(mystatemap)

  },

  resize: function(el, width, height, instance) {

  }

});
