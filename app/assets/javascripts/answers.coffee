# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ -> 
  $('.edit_answer_form').hide()
  $('.edit_answer_link').on 'click', (e) ->
    e.preventDefault();
    id = $(this).data('editAnswerLinkId')
    $("#edit_answer_form_"+id).show()
    $(this).hide();