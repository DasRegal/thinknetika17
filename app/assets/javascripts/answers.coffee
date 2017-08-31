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
  if gon.question 
    if (App.answers_sub) 
      App.cable.subscriptions.remove(App.answers_sub)
    App.answers_sub = App.cable.subscriptions.create({
      channel: 'AnswersChannel', 
      question_id: gon.question.id
    },{
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        parsed_data= JSON.parse(data)
        $('.answers_container').append(JST['templates/answer']({
          answer: parsed_data['answer']
          attachments: parsed_data['attachments']
          }))
    })

$(document).ready(answer_ready) 

$(document).on('turbolinks:load', answer_ready)
$(document).on('turbolinks:load', answers_subscript)
