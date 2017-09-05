# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
question_comments_subscript = ->
  if gon.question 
    App.cable.subscriptions.create({
      channel: 'CommentsChannel', 
      id: gon.question.id,
      commentable: 'question'
    },{
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        comment = JSON.parse(data)['comment']
        if comment.user_id != gon.current_user
          commentable = comment['commentable_type'].toLowerCase()
          id = comment['commentable_id']
          $(".#{commentable}_comments[data-id=#{id}] .comments_container").append(JST['templates/comment']({
            comment: comment
            }))
    })
# answer_comments_subscript = ->
#   if gon.question 
#     $.each JSON.parse(gon.question_answers), (index, value) ->
#       App.cable.subscriptions.create({
#         channel: 'CommentsChannel', 
#         id: value,
#         commentable: 'answer'
#       },{
#         connected: ->
#           @perform 'follow'
#         ,

#         received: (data) ->
#           comment = JSON.parse(data)['comment']
#           if comment.user_id != gon.current_user
#             $(".answer_comments[data-id=#{value}] .comments_container").append(JST['templates/comment']({
#               comment: comment
#               }))
#       })


$(document).on('turbolinks:load', question_comments_subscript)
# $(document).on('turbolinks:load', answer_comments_subscript)