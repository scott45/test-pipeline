$(document).ready ->
  $('#edit-learner-profile').click (event) ->
    $('.view-learner-element').hide()
    $('.edit-learner-element').show()

  $('#save-learner-profile, #back-to-learner-profile').click (event) ->
    $('.edit-learner-element').hide()
    $('.view-learner-element').show()
