if Meteor.isClient
  Meteor.startup ->
    Session.set 'finalyet', false
    Session.set 'analysis', false
    window.answers = []

  Handlebars.registerHelper "TabActive", (route) ->
    url = Session.get 'url'
    if url is route
      "active"

  Template.header.rest = ->
    Session.equals 'rest', false

  Template.home.rendered = ->
    Session.set 'rest', true
    controller = $.superscrollorama
      triggerAtCenter: false
      playoutAnimations: true

    controller.addTween('#fade', 
      TweenMax.from($('#fade'), .5, {css:{opacity:0}}), 0, -500)

  Template.home.events
    'click .finish': ->
      Router.go '/analysis'

  Template.howweinvest.rendered = ->
    Session.set 'rest', false
    $('body').scrollTop(0)

  Template.whoarewe.rendered = ->
    Session.set 'rest', false
    $('body').scrollTop(0)

  Template.questionaire.questions = ->
    Questions.find()

  Template.questionaire.created = ->
    console.log 'created'
    Session.set 'rest', true
    if Session.equals 'finalyet', false
      console.log 'wow'
      setTimeout ->
        window.deck = bespoke.from "#presentation", progress: true
      , 500

  Template.questionaire.events 

    "click .next": ->
      # template data, if any, is available in 'this'
      answers.push Session.get 'answer'
      Session.set 'finalanswers', answers
      deck.next()

    "click .finish": (e, t) ->
      #console.log t.find('#amount').value
      Session.set 'amount', t.find('#amount').value
      $('.loading').fadeIn()
      deck.next()
      setTimeout ->
        $('.loading').fadeOut()
        deck.next()
        Session.set 'finalyet', true
      , 3000

    'change input[type=radio]': (e, t) ->
      console.log @
      Session.set 'answer', @

  Template.finalslide.finalyet = ->
    Session.equals 'finalyet', true

  Template.finalslide.final = ->
    Session.get 'finalanswers'

  Template.finalslide.test = (percent) ->
    amount = Session.get 'amount'
    invest = amount * parseFloat(percent)
    invest.toFixed(2)

  Template.finalslide.rendered = ->
    if Session.equals 'finalyet', true
      $('.loading').show()
      setTimeout ->
        $('.loading').hide()
      , 5000

      w = 450 #width
      h = 350 #height
      r = 100 #radius
      labelr = r + 20
      color = d3.scale.category20c() #builtin range of colors

      breakdown = [
        {"name":"SPY", "value":0.23},
        {"name":"IWD", "value":0.07}, 
        {"name":"EFA", "value":0.2}, 
        {"name":"VWO", "value":0.05}, 
        {"name":"TLT", "value":0.1}, 
        {"name":"LQD", "value":0.12}, 
        {"name":"HYG", "value":0.05}, 
        {"name":"BWX", "value":0.13}, 
        {"name":"CASH", "value":0.05}
      ]

      data = _.map(breakdown, (i) ->
        label : i.name
        value : i.value * (Session.get 'amount')
      )

      vis = d3.select("#pie").append("svg:svg")
        .data([data])
          .attr("width", w)
          .attr("height", h)
            .append("svg:g")
              .attr("transform", "translate(#{w/2-50}, #{h/2})")
      
      arc = d3.svg.arc().outerRadius(r)
      
      pie = d3.layout.pie().value((d) ->
        d.value
      )
      
      arcs = vis.selectAll("g.slice").data(pie).enter().append("svg:g").attr("class", "slice") #allow us to style things in the slices (like text)
      
      arcs.append("svg:path").attr("fill", (d, i) -> #this creates the actual SVG path using the associated data (pie) with the arc drawing function
        color i
      ).attr "d", arc

      arcs.append('svg:text').attr("transform", (d) ->
        d.innerRadius = 0
        d.outerRadius = r
        c = arc.centroid(d)
        x = c[0]
        y = c[1]
        h = Math.sqrt(x * x + y * y)
        "translate(" + (x / h * labelr) + "," + (y / h * labelr) + ")"
      )
      .attr('font-size', '12px')
      .attr "text-anchor", (d) ->
        # are we past the center?
        (if (d.endAngle + d.startAngle) / 2 > Math.PI then "end" else "start")
      .text (d, i) ->
        console.log data[i], 'asdfasdf'
        "$#{data[i].value.toFixed 2}"

      legend = vis.selectAll(".legend")
        .data(data).enter()
        .append("g").attr("class", "legend")
        .attr("transform", (d, i) ->
          "translate(#{r+100}, #{(i * 20)-r+10})"
        )

      legend.append("rect")
        .attr("width", 12)
        .attr("height", 12)
        .style "fill", (d, i) ->
          color i

      legend.append("text")
        .attr("x", 24)
        .attr("y", 6)
        .attr("dy", ".35em")
        .attr('font-size', 12)
        .text (d, i) ->
          console.log i,  data[i].label, 'text legend'
          data[i].label

  Template.finalslidev2.finalyet = ->
    Session.equals 'finalyet', true

  Template.finalslidev2.rendered = ->
    console.log 'finalslide2'
    w = 400
    h = 400
    r = 150
    inner = 50
    color = d3.scale.category20c()

    breakdown = [
      {"name":"SPY", "value":0.23},
      {"name":"IWD", "value":0.07}, 
      {"name":"EFA", "value":0.2}, 
      {"name":"VWO", "value":0.05}, 
      {"name":"TLT", "value":0.1}, 
      {"name":"LQD", "value":0.12}, 
      {"name":"HYG", "value":0.05}, 
      {"name":"BWX", "value":0.13}, 
      {"name":"CASH", "value":0.05}
    ]

    data = _.map(breakdown, (i) ->
      label : i.name
      value : i.value * (Session.get 'amount')
    )

    total = d3.sum(data, (d) ->
      d3.sum d3.values(d)
    )

    vis = d3.select("#chart1")
      .append("svg:svg")
      .data([data])
        .attr("width", w)
        .attr("height", h)
      .append("svg:g")
        .attr("transform", "translate(" + 200 + "," + 200 + ")")
    
    textTop = vis.append("text")
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .attr("class", "textTop")
      .text("TOTAL")
      .attr("y", -10)
    
    textBottom = vis.append("text")
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .attr("class", "textBottom")
      .text(total.toFixed(2))
      .attr("y", 10)
    
    arc = d3.svg.arc()
      .innerRadius(inner)
      .outerRadius(r)
    
    arcOver = d3.svg.arc()
      .innerRadius(inner + 5)
      .outerRadius(r + 5)
    
    pie = d3.layout.pie().value((d) ->
      d.value
    )

    arcs = vis.selectAll("g.slice")
      .data(pie).enter()
      .append("svg:g")
        .attr("class", "slice")
        .on("mouseover", (d, i) ->
          console.log i
          d3.select(this).select("path")
            .transition()
            .duration(200)
            .attr "d", arcOver
            textTop.text(d3.select(this).datum().data.label).attr("y", -10).attr('color')
            textBottom.text("$" + d3.select(this).datum().data.value.toFixed(2)).attr "y", 10
            return
          )
        .on("mouseout", (d) ->
          d3.select(this).select("path").transition().duration(100).attr "d", arc
          textTop.text("TOTAL").attr "y", -10
          textBottom.text "$" + total.toFixed(2)
          return
        )

    arcs.append("svg:path")
      .attr("fill", (d, i) ->
        color i
      ).attr "d", arc

    legend = d3.select("#chart1").append("svg")
      .attr("class", "legend")
      .attr("width", 100)
      .attr("height", r * 2)
    .selectAll("g")
      .data(data).enter()
      .append("g")
        .attr "transform", (d, i) ->
          "translate(0," + i * 25 + ")"

    legend.append("rect")
      .attr("width", 16)
      .attr("height", 16)
      .style "fill", (d, i) ->
        color i

    legend.append("text")
      .attr("x", 24)
      .attr("y", 7)
      .attr("dy", ".35em")
      .text (d) ->
        d.label

    legend.on 'mouseover', ->
      console.log 'mouseover'

if Meteor.isServer
  Meteor.publish "allQuestions", ->
    Questions.find()

# code to run on server at startup
