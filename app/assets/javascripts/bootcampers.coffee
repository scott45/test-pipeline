# Code for homepage dropdowns
#= require jquery
#= require jquery_ujs
#= require puffly
#= require_tree .

$ ->
  $('.dropdown-button').dropdown()
  $('select').material_select()

  # check to alert the index.coffee of uploaded bootcampers uploaded sheet.
  if window.location.href == window.location.protocol + "//" + window.location.host + '/bootcampers/add'
    localStorage.setItem 'url', window.location.href

  $('input.autocomplete').autocomplete
    source: [
      'Lagos'
      'Abuja'
      'Ibadan'
      'Nairobi'
      'Naivasha'
      'Mombasa'
      'Kampala'
      'Entebbe'
      'Jinja'
    ]
    limit: 5

  $('#upload-bootcampers').validate
    rules:
      city:
        required: true
      application_cycle:
        required: true
      country:
        required: true
      file:
        required: true
        extension: 'xlsx'
    messages:
      country: '<p>&nbsp;&nbsp;&nbsp;Please specify the location</p>'
      application_cycle: 'Please enter the cycle number'
      city: 'Please enter the city'
      file: 'Please upload a spreadsheet'
    errorElement : 'div'
    errorPlacement: (error, element) ->
      if element.attr('name') == 'country'
        element.closest('.row').append(error);
      else if element.attr('name') == 'file'
        error.insertAfter(element)
        $('#file-name').css('borderColor', '#f0405e')
      else
        error.insertAfter(element)
        element.css('borderColor', '#f0405e')
      return

  $('input[type=radio][name=country]').change ->
    if @value == 'Nigeria'
      $('.nigeria').addClass 'selected'
      $('.nairobi').removeClass 'selected'
      $('.uganda').removeClass 'selected'
    else if @value == 'Kenya'
      $('.nairobi').addClass 'selected'
      $('.nigeria').removeClass 'selected'
      $('.uganda').removeClass 'selected'
    else if @value == 'Uganda'
      $('.uganda').addClass 'selected'
      $('.nigeria').removeClass 'selected'
      $('.nairobi').removeClass 'selected'
    return
return
