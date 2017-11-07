# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # Trigger the clear button when searching
  $('#search').on 'keyup', ->
    if $('#search').val() == ''
      $('.clear').hide()
    else
      $('.clear').show()
    return

  # Clear the search box and hide the clear button
  $('.clear').on 'click', (event) ->
    event.preventDefault()
    $('#search').val ''
    $(this).hide()
    return

  # Autocomplete when searching
  $('#search').autocomplete
    source: (request, response) ->
      $.get 'search/autocomplete', (data) ->
        matcher = new RegExp($.ui.autocomplete.
        escapeRegex(request.term), 'i')
        response $.grep(data, (item) ->
          matcher.test item
        )
        return
      return
    minLength: 1
    autoFocus: true
  return
