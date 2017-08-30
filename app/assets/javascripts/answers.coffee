# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
answer_ready =  -> 
  $('.edit_answer_form').hide()
  $('.answers_container').on 'click', '.edit_answer_link', (e) ->
    e.preventDefault();
    id = $(this).data('editAnswerLinkId')
    $("#edit_answer_form_"+id).show()
    $(this).hide();

  $('.answers_container').on 'click', '.delete_answer', (e) -> 
    id = $(this).data('answerId')

answers_subscript = ->
  if gon.question_id 
    if (App.answers_sub) 
      App.cable.subscriptions.remove(App.answers_sub)
    App.answers_sub = App.cable.subscriptions.create({
      channel: 'AnswersChannel', 
      question_id: gon.question_id
    },{
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        console.log data
        $('.answers_container').append(data)
    })

$(document).ready(answer_ready) 

$(document).on('turbolinks:load', answer_ready)
$(document).on('turbolinks:load', answers_subscript)

$ -> 
  $('body').append(JST['test']({ world: "World" }))
