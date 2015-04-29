root = exports ? this
createAccessors = (visExport) ->
  for n of visExport.opts
    continue  unless visExport.opts.hasOwnProperty(n)
    visExport[n] = ((n) ->
      (v) ->
        (if arguments.length then (visExport.opts[n] = v
        this
        ) else visExport.opts[n])
    )(n)
  return

# http://gomakethings.com/vanilla-javascript-version-of-jquery-extend/
extend = (defaults, options) ->
  extended = {}
  prop = undefined
  for prop of defaults
    `prop = prop`
    if Object::hasOwnProperty.call(defaults, prop)
      extended[prop] = defaults[prop]
  for prop of options
    `prop = prop`
    if Object::hasOwnProperty.call(options, prop)
      extended[prop] = options[prop]
  extended



d3.table = (data) ->
  table = ["<b>", data.state, "</b>", "<table style='line-height:2em;'>"]
  d3.entries(data).forEach (d) ->
    table.push("<tr><td>" + d.key + "</td><td>&nbsp</td><td>" + d.value + "</td></tr>")
  table.join("") + "</table>"


d3.uniq = (data, fun) ->
  if typeof fun is 'function'
    v_ = data.map(fun)
  else
    v_ = data.map (d) -> d[fun]
  d3.set(v_).values()


d3.selection.prototype.appendOnce = (name) ->
   that = this.selectAll(name).data([{}])
   that.enter().append(name)
   return that

d3.selection.prototype.dataAppend = (data, name) ->
   that = this.selectAll(name).data(data)
   that.enter().append(name)

d3.ui = d3.ui || {}
d3.ui.panel = () ->
  defaults = {panels: ["heading", "body"], type: "default"}
  opts = arguments[0] || defaults
  exports = (selection) ->
    selection.each (data) ->
      panel = d3.select(@).selectAll("div.panel.panel-#{opts.type}").data([{}])
      panelEnter = panel.enter().append("div.panel.panel-#{opts.type}")
      subPanels = panelEnter.selectAll("div").data(opts.panels)
      subPanels.enter().append("div")
      
      subPanels.attr
        class: (d) -> "panel-#{d}"
      ###
      d3.select(@)
        .appendOnce("div.panel.panel-#{opts.type}")
        .dataAppend(opts.panels, "div")
        .attr
           class: (d) -> "panel-#{d}"
      ###
      panel
  exports.opts = opts; createAccessors(exports)
  exports

d3.ui.select = ->
  opts = {text: "text", value: "value"}
  event_handlers = {}
  exports = (selection) ->
    selection.each (data) ->

      # Start of body
      select = d3.select(@)
        .appendOnce("select.form-control.col")
      select.dataAppend(data, "option")
      select.selectAll("option")
        .attr
          value: (d) -> d[opts.value] || d
        .text (d) -> d[opts.text] || d
      # End of body

      for event of event_handlers
        select.on event, event_handlers[event]
  exports.on = (event, fun) ->
    if arguments.length == 1
      return event_handlers[event]
    event_handlers[event] = fun
    exports
  exports.opts = opts; createAccessors(exports)
  exports


d3.ui.paginate = ->
  opts = {callback: (d, i) -> return d}
  exports = (selection) ->
    selection.each (data) ->

      nav = d3.select(@)
      nav.appendOnce("ul.pagination")
        .dataAppend(data, "li")
        .classed("active", (d, i) -> i is 0)
        .append("a").text (d) -> d
      li = nav.selectAll("li")
      li.on "click", (d, i) ->
        li.classed("active", false)
        d3.select(@).classed("active", true)
        opts.callback(d, i)

   exports.opts = opts; createAccessors(exports)
   exports


state_coords = (state) ->
  {"AK":[{"row":7,"col":1}],"AL":[{"row":7,"col":8}],"AR":[{"row":6,"col":6}],"AZ":[{"row":6,"col":3}],"CA":[{"row":5,"col":2}],"CO":[{"row":5,"col":4}],"CT":[{"row":4,"col":11}],"DC":[{"row":6,"col":10}],"DE":[{"row":5,"col":11}],"FL":[{"row":8,"col":10}],"GA":[{"row":7,"col":9}],"HI":[{"row":8,"col":1}],"IA":[{"row":4,"col":6}],"ID":[{"row":3,"col":3}],"IL":[{"row":3,"col":7}],"IN":[{"row":4,"col":7}],"KS":[{"row":6,"col":5}],"KY":[{"row":5,"col":7}],"LA":[{"row":7,"col":6}],"MA":[{"row":3,"col":11}],"MD":[{"row":5,"col":10}],"ME":[{"row":1,"col":12}],"MI":[{"row":3,"col":8}],"MN":[{"row":3,"col":6}],"MO":[{"row":5,"col":6}],"MS":[{"row":7,"col":7}],"MT":[{"row":3,"col":4}],"NC":[{"row":6,"col":8}],"ND":[{"row":3,"col":5}],"NE":[{"row":5,"col":5}],"NH":[{"row":2,"col":12}],"NJ":[{"row":4,"col":10}],"NM":[{"row":6,"col":4}],"NV":[{"row":4,"col":3}],"NY":[{"row":3,"col":10}],"OH":[{"row":4,"col":8}],"OK":[{"row":7,"col":5}],"OR":[{"row":4,"col":2}],"PA":[{"row":4,"col":9}],"RI":[{"row":4,"col":12}],"SC":[{"row":6,"col":9}],"SD":[{"row":4,"col":5}],"TN":[{"row":6,"col":7}],"TX":[{"row":8,"col":5}],"UT":[{"row":5,"col":3}],"VA":[{"row":5,"col":9}],"VT":[{"row":2,"col":11}],"WA":[{"row":3,"col":2}],"WI":[{"row":2,"col":7}],"WV":[{"row":5,"col":8}],"WY":[{"row":4,"col":4}]}[state][0]

d3.heatmap = (S, A) ->
  defaults = {}
  opts = extend(defaults, arguments[0])
  exports = (selection) ->
    selection.each (data) ->
      S.x.domain d3.uniq(data, A.x)
      S.y.domain d3.uniq(data, A.y)
      S.c.domain d3.extent(data, A.z)
      cell = d3.select(@).selectAll(".cell").data(data, A.id)
      cellEnter = cell.enter().append("g.cell")
      cellEnter.append("rect.state")
      cellEnter.append("text.state")
      
      cell.attr
        transform: (d) -> "translate(#{S.x A.x(d)}, #{S.y A.y(d)})"
        
      cell.select("rect.state")
        .attr
           x: 0
           y: 0
           width: S.x.rangeBand()
           height: S.y.rangeBand()
        .style
           fill: (d) -> S.c A.z(d)
      cell
  exports.opts = opts; createAccessors(exports)
  exports
  

d3.hexmap = (S, A) ->
  defaults = {}
  hexbin = d3.hexbin().radius(18.5)
  opts = extend(defaults, arguments[0])
  exports = (selection) ->
    selection.each (data) ->
      S.x.domain d3.uniq(data, A.x)
      S.y.domain d3.uniq(data, A.y)
      S.c.domain d3.extent(data, A.z)
      cell = d3.select(@).selectAll(".cell").data(data, A.id)
      cellEnter = cell.enter().append("g.cell")
      cellEnter.append("path.hexagon")
      cellEnter.append("text.state")
      
      cell.attr
        transform: (d) ->
          x = A.x(d)
          y = A.y(d)
          if (y % 2 is 0)
            offset = S.x.rangeBand()/2
          else
            offset = 0
          "translate(#{S.x(x) + offset}, #{S.y(y)})"
          
        
      cell.select("path.hexagon")
        .attr
           transform: "translate(15, 15)"
           d: (d) -> hexbin.hexagon(hexbin.radius())
        .style
           fill: (d) -> S.c A.z(d)
      cell
  exports.opts = opts; createAccessors(exports)
  exports



d3.render = {} || d3.render
d3.render.legend = ->
  mylegend = d3.svg.legend()
    .units("")
    .cellWidth(40)
    .cellHeight(10)
  exports = (selection) ->
    selection.each (data) ->
      legend = d3.select(this)
        .appendOnce("g.legend")
        .translate(5, 0)
      # HACK: ensures that we dont end up with multiple
      #       legends on update
      legend.select(".mutLegendGroup").remove()
      legend.call(mylegend)
  d3.rebind(exports, mylegend, "inputScale")
  exports

d3.render.tip = (sel, html) ->
  tip = d3.tip()
    .attr("class", "d3-tip light")
    .html html || d3.table

  sel.call(tip)
  sel.on "mouseover", tip.show
  sel.on "mouseout", tip.hide


d3.statemap = (S, A) ->
  opts = {}
  exports = (selection) ->
    selection.each (data) ->
       cell = d3.select(this).call(d3.heatmap(S, A))
       cell.selectAll("rect.state").call(d3.render.tip)
       legend = d3.render.legend().inputScale(S.c)
       d3.select(this).call(legend)
       cell.selectAll("text.state")
        .attr
           dx: S.x.rangeBand()/2
           dy: S.y.rangeBand()/2
        .text (d) -> d.state
       
  exports.opts = opts; createAccessors(exports)
  exports
  
d3.hexstatemap = (S, A) ->
  opts = {}
  exports = (selection) ->
    selection.each (data) ->
       cell = d3.select(this).call(d3.hexmap(S, A))
       cell.selectAll(".cell").call(d3.render.tip)
       legend = d3.render.legend().inputScale(S.c)
       d3.select(this).call(legend)
       cell.selectAll("text.state")
        .attr
           dx: S.x.rangeBand()/2
           dy: S.y.rangeBand()/2
        .text (d) -> d.state
       
  exports.opts = opts; createAccessors(exports)
  exports



d3.container = (sel, o) ->
  o.margin = o.margin || {top: 20, bottom: 40, left: 40, right: 20}
  o.W = o.width + o.margin.left + o.margin.right
  o.H = o.height + o.margin.top + o.margin.bottom
  svg = sel.appendOnce("svg")
     .attr({"width": o.W, "height": o.H})
     .appendOnce("g.main")
     .attr
        transform: "translate(#{o.margin.left}, #{o.margin.top})"
  svg

root.statemap = ->
    defaults =
      x: "state"
      y: "count"
      facet: null
      width: 400
      height: 400/1.7
      margin: {top: 20, right: 80, bottom: 50, left: 50}
      colors: colorbrewer.Blues[7]
      heading: "Statebins"
      footer: "This is a statebin chart"
      units: ""
      control: 'dropdown'
      type: 'rect'

    opts = extend(defaults, arguments[0])

    exports = (selection) ->
      selection.each (data) ->
        A =
          x: (d) -> state_coords(d[opts.x]).col
          y: (d) -> state_coords(d[opts.x]).row
          z: (d) -> d[opts.y]
          id: (d) -> d[opts.x]
        S =
          x: d3.scale.ordinal().rangeRoundBands([0, opts.width], 0.02)
          y: d3.scale.ordinal().rangeRoundBands([0, opts.height], 0.02)
          c: d3.scale.quantize().range(opts.colors)

        panel1 = d3.ui.panel()
          .panels(['heading', 'body', 'footer'])

        mypanel1 = d3.select(this).call(panel1)
        #console.log mypanel1.data()
        mypanel1.select('.panel-heading').html(opts.heading)

        pbody = mypanel1.select(".panel-body")

        if opts.facet
            #console.log("Group is defined")
            switch opts.control
                when "steps"
                  choices = d3.ui.paginate()
                    .callback (d, i) ->  update(d)
                  #active = d3.select(this)
                  #  .select('.steps .active a')
                  #  .text()
                when "dropdown"
                  choices = d3.ui.select()
                    .text("description")
                    .value("code")
                    .on "change", (d, i) -> update(@value)

            pbody
              .appendOnce("div.#{opts.control}")
              .datum(d3.uniq(data, opts.facet))
              .call(choices)

        mypanel1.select(".panel-footer").html(opts.footer)

        update =  (grp) ->
          data_ = data.filter (d) -> 
            if opts.facet
              return d[opts.facet] is grp
            else
              return true
          if opts.type is 'rect'
            d3.container(pbody, opts)
              .datum(data_, A.id)
              .call(d3.statemap(S, A))
          else
            d3.container(pbody, opts)
              .datum(data_, A.id)
              .call(d3.hexstatemap(S, A))

        if opts.facet
          update d3.uniq(data, opts.facet)[0]
        else
          update()

     exports.opts = opts
     createAccessors(exports)
     exports
