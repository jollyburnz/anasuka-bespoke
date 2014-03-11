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

  Template.finalslidev2.final = ->
    Session.get 'finalanswers'

  Template.finalslidev2.score = ->
    answers = Session.get 'finalanswers'
    score = _.reduce answers, ((memo, num) ->
      memo + num.point
    ), 0

    if score > 3 and score < 9
      1
    else if  score > 10 and score < 18
      2
    else if score > 19 and  score < 25
      3
    else if score > 26 and score < 34
      4
    else if score > 35 and score < 41
      5

  Template.finalslidev2.breakdown = ->
    Session.get 'breakdown'

  Template.finalslidev2.test = (percent) ->
    amount = Session.get 'amount'
    invest = amount * parseFloat(percent)
    invest.toFixed(2)

  Template.finalslidev2.done = ->
    Session.equals 'done', true

  Template.finalslidev2.finalyet = ->
    console.log (Session.equals 'finalyet', true), 'finalyet?'
    Session.equals 'finalyet', true

  Template.finalslidev2.rendered = ->
    console.log 'finalslide2'
    w = 400
    h = 400
    r = 150
    inner = 50
    color = d3.scale.category20c()
    amount = Session.get 'amount'
    answers = Session.get 'finalanswers'
    score = _.reduce answers, ((memo, num) ->
      memo + num.point
    ), 0
    console.log score, 'SCORE'

    if score > 3 and score < 9
      breakdown = [
        {"class": "US Equities", "name":"SPY", "value":0.11},
        {"class": "Large Cap Value", "name":"IWD", "value":0},
        {"class": "Small Cap Value", "name":"IWM", "value":0},
        {"class": "Non US Equities", "name":"EFA", "value":0.09}, 
        {"class": "Emerging Markets", "name":"VWO", "value":0}, 
        {"class": "US Treasury Bonds", "name":"TLT", "value":0.35}, 
        {"class": "US Corporate Bonds", "name":"LQD", "value":0.3}, 
        {"class": "US High Yield Bonds", "name":"HYG", "value":0}, 
        {"class": "Non US Treasury Bonds", "name":"BWX", "value":0.1}, 
        {"class": "Cash", "name":"CASH", "value":0.05}
      ]
    else if  score > 10 and score < 18
      breakdown = [
        {"class": "US Equities","name":"SPY", "value":0.15},
        {"class": "Large Cap Value", "name":"IWD", "value":0.05},
        {"class": "Small Cap Value", "name":"IWM", "value":0},
        {"class": "Non US Equities", "name":"EFA", "value":0.15}, 
        {"class": "Emerging Markets", "name":"VWO", "value":0}, 
        {"class": "US Treasury Bonds", "name":"TLT", "value":0.21}, 
        {"class": "US Corporate Bonds", "name":"LQD", "value":0.21}, 
        {"class": "US High Yield Bonds", "name":"HYG", "value":0.04}, 
        {"class": "Non US Treasury Bonds", "name":"BWX", "value":0.14}, 
        {"class": "Cash", "name":"CASH", "value":0.05}
      ]
      Session.set 'breakdown', breakdown
    else if score > 19 and  score < 25
      breakdown = [
        {"class": "US Equities", "name":"SPY", "value":0.23},
        {"class": "Large Cap Value", "name":"IWD", "value":0.07},
        {"class": "Small Cap Value", "name":"IWM", "value":0},
        {"class": "Non US Equities", "name":"EFA", "value":0.2}, 
        {"class": "Emerging Markets", "name":"VWO", "value":0.05}, 
        {"class": "US Treasury Bonds", "name":"TLT", "value":0.1}, 
        {"class": "US Corporate Bonds", "name":"LQD", "value":0.12}, 
        {"class": "US High Yield Bonds", "name":"HYG", "value":0.05}, 
        {"class": "Non US Treasury Bonds", "name":"BWX", "value":0.13}, 
        {"class": "Cash", "name":"CASH", "value":0.05}
      ]
      Session.set 'breakdown', breakdown
    else if score > 26 and score < 34
      breakdown = [
        {"class": "US Equities", "name":"SPY", "value":0.26},
        {"class": "Large Cap Value", "name":"IWD", "value":0.07},
        {"class": "Small Cap Value", "name":"IWM", "value":0.04},
        {"class": "Non US Equities", "name":"EFA", "value":0.26}, 
        {"class": "Emerging Markets", "name":"VWO", "value":0.07}, 
        {"class": "US Treasury Bonds", "name":"TLT", "value":0.06}, 
        {"class": "US Corporate Bonds", "name":"LQD", "value":0.06}, 
        {"class": "US High Yield Bonds", "name":"HYG", "value":0.04}, 
        {"class": "Non US Treasury Bonds", "name":"BWX", "value":0.09}, 
        {"class": "Cash", "name":"CASH", "value":0.05}
      ]
      Session.set 'breakdown', breakdown
    else if score > 35 and score < 41
      breakdown = [
        {"class": "US Equities", "name":"SPY", "value":0.35},
        {"class": "Large Cap Value", "name":"IWD", "value":0.11},
        {"class": "Small Cap Value", "name":"IWM", "value":0.05},
        {"class": "Non US Equities", "name":"EFA", "value":0.34}, 
        {"class": "Emerging Markets", "name":"VWO", "value":0.1}, 
        {"class": "US Treasury Bonds", "name":"TLT", "value":0}, 
        {"class": "US Corporate Bonds", "name":"LQD", "value":0}, 
        {"class": "US High Yield Bonds", "name":"HYG", "value":0}, 
        {"class": "Non US Treasury Bonds", "name":"BWX", "value":0}, 
        {"class": "Cash", "name":"CASH", "value":0.05}
      ]
      Session.set 'breakdown', breakdown

    data = _.map(breakdown, (i) ->
      class : i.class
      symbol : i.name
      value : i.value * amount
    )

    console.log data, 'data'

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
            textTop.text(d3.select(this).datum().data.symbol).attr("y", -10).attr('color')
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

    table = d3.select('#tablee').append('table')
      .attr('class', 'table')

    tbody = table.append('tbody')

    rows = tbody.selectAll('tr')
      .data(data).enter()
      .append('tr')

    # cells = rows.selectAll('td')
    #   .data((row) -> console.log row)
    #   .enter()
    #   .append('td')
    #   .attr 'class', (d, i) -> console.log d, color i

    # legend = d3.select("#chart1").append("svg")
    #   .attr("class", "legend")
    #   .attr("width", 100)
    #   .attr("height", r * 2)
    # .selectAll("g")
    #   .data(data).enter()
    #   .append("g")
    #     .attr "transform", (d, i) ->
    #       "translate(0," + i * 25 + ")"

    # legend.append("rect")
    #   .attr("width", 16)
    #   .attr("height", 16)
    #   .style "fill", (d, i) ->
    #     color i

    # legend.append("text")
    #   .attr("x", 24)
    #   .attr("y", 7)
    #   .attr("dy", ".35em")
    #   .text (d) ->
    #     d.label

    # legend.on 'mouseover', ->
    #   console.log 'mouseover'

  Template.finalslidev2.events
    'click #submit': (e, t) ->
      email_address = $('#email').val()
      
      Meteor.call('sendEmail', email_address)
      
      Emails.insert
        email: email_address
      
      Session.set('done', true)

  Template.aboutyou.final = ->
    Session.get 'finalanswers'

if Meteor.isServer
  Meteor.publish "allQuestions", ->
    Questions.find()

  process.env.MAIL_URL = "smtp://postmaster@sandbox18028.mailgun.org:9q3nxrc3rs88@smtp.mailgun.org:587"

  Meteor.methods
    sendEmail: (email) ->  
      # send the email!
      console.log email, 'email'
      Email.send
        to: email
        from: "info@anasuka.com"
        subject: "[ANASUKA] Congratulations!"
        text: "We will share with you some news about us in a near future. See you soon! Party on!"

# code to run on server at startup
