$ ->
  vof.dashboardFilters = [
    '#select_cycle',
    '#select_week1_lfa',
    '#select_week2_lfa'
  ]

  $('#select_location').change ->
    vof.displayFilterSpinner @value
    vof.toggleFilter vof.dashboardFilters, true
    vof.setFilter 'city', @value
    vof.setFilter 'cycle', 'All'
    resetLfaFilters()
    return

  $('#select_cycle').change ->
    vof.displayFilterSpinner @value
    vof.toggleFilter vof.dashboardFilters.slice(1, 3), true
    vof.setFilter 'cycle', @value
    resetLfaFilters()
    return

  $('#select_status_decision1').change ->
    vof.setFilter 'decision_one', @value
    return

  $('#select_status_decision2').change ->
    vof.setFilter 'decision_two', @value
    return

  $('#select_week1_lfa').change ->
    vof.setFilter 'week_one_lfa', @value
    return

  $('#select_week2_lfa').change ->
    vof.setFilter 'week_two_lfa', @value
    return

  resetLfaFilters = ->
    vof.setFilter 'week_one_lfa', 'All'
    vof.setFilter 'week_two_lfa', 'All'
    return

  # toggle  filters
  vof.toggleFilter = (filters, toggleFlag) ->
    filters.forEach (filter) ->
      $(filter).attr 'disabled', toggleFlag
      $(filter).material_select()
      return
    return

  # disable filters
  vof.disableFilters = (filterObj) ->
    if filterObj['city'] == 'All'
      vof.toggleFilter vof.dashboardFilters, true
    else if filterObj['cycle'] == 'All'
      vof.toggleFilter vof.dashboardFilters.slice(1, 3), true
    return

  # Display the spinner for limited number of records
  vof.displayLimitSpinner = ->
    $('.limit-spinner').css('display','block')
    return

  vof.displayFilterSpinner = (value) ->
    if value != 'All'
      $('#apply-filter').css('display','none')
      $('.filter-spinner').css('display','block')
    return

  # Helper function to generate dropdowns
  vof.generateDropdown = (selectElement, selectOptions) ->
    selectElement.append selectOptions
    selectElement.material_select()
    return

return
