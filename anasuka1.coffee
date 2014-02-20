if Meteor.isClient
  Meteor.startup ->
    Session.set 'finalyet', false
    window.answers = []

  Template.hello.greeting = ->
    "Welcome to anasuka1."

  Template.hello.rendered = ->
    if Session.equals 'finalyet', false
      window.deck = bespoke.from "#presentation", 
        progress: true

  Template.hello.questions = ->
    Questions.find()

  Template.hello.events 

    "click .next": ->
      # template data, if any, is available in 'this'
      answers.push Session.get 'answer'
      Session.set 'finalanswers', answers
      deck.next()

    "click .finish": (e, t) ->
      #console.log t.find('#amount').value
      Session.set 'amount', t.find('#amount').value
      Session.set 'finalyet', true
      deck.next()

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
      , 4000


if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup
