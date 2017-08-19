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

$(document).ready(answer_ready) # "вешаем" функцию ready на событие document.ready
$(document).on('turbolinks:load', answer_ready)  # "вешаем" функцию ready на событие page:load
