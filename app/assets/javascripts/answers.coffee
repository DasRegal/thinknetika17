# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ -> 
  $('.answers_container').on 'click', '.edit_answer_link', (e) ->
    e.preventDefault();
    id = $(this).data('editAnswerLinkId')
    $("#edit_answer_form_"+id).show()
    $(this).hide();

  $('.answers_container').on 'click', '.delete_answer', (e) -> 
    id = $(this).data('answerId')
    # $(".answer[data-answerId=#{id}]").hide()