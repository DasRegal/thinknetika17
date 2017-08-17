# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
question_ready =  ->
  $('.edit_question_form').hide()
  $('.edit_question_link').on 'click', (e) ->
    e.preventDefault();
    $(".edit_question_form").show()
    $(this).hide();


$(document).ready(question_ready) # "вешаем" функцию ready на событие document.ready
$(document).on('turbolinks:load', question_ready)  # "вешаем" функцию ready на событие page:load
$(document).on('turbolinks:update', question_ready) # "вешаем" функцию ready на событие page:update