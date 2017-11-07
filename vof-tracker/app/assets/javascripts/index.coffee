# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

applyJs = ->
  $(document).ready ->
    url = localStorage.getItem 'url'
    checkbox = localStorage.getItem 'checked'
    hostUrl = window.location.protocol + "//" + window.location.host + '/'

    if url == (hostUrl + 'bootcampers/add')
      $('.filled-in:checkbox').prop('checked', false)

    # checks if page links are clicked
    paginateLink = 'div#paginate > span.pagination > li > a'

    $('.all_data').on 'click', paginateLink, ->
      if $('.filled-in:checkbox').is(':checked')
        newUrl = $(this).attr('href')
        localStorage.setItem 'url', window.location.protocol + '//' + window.location.host + newUrl

    # gets the new url and redirects when the user goes back to the home page
    if checkbox == 'true' and window.location.href.replace(/%20/g, ' ') != url and url != (hostUrl + 'bootcampers/add')
      window.location.replace localStorage.getItem 'url'

    # makes the checkbox persistent
    if checkbox == 'true'
      $('.filled-in:checkbox').attr('checked', 'checked')

    # Check if filter changes
    $('.filter_camper').change ->
      localStorage.setItem 'checked', false
      $('.filled-in:checkbox').prop('checked', false)

    # procedure to set the new url
    $('.filled-in:checkbox').change ->
      if $(this).is(':checked')
        localStorage.setItem 'checked', true
        localStorage.setItem 'url',  buildFilterParams()
      else
        localStorage.setItem 'checked', false
        localStorage.setItem 'url', window.location.protocol + "//" + window.location.host

    filterObj =
      city: 'All'
      cycle: 'All'
      decision_one: 'All'
      decision_two: 'All'
      week_one_lfa: 'All'
      week_two_lfa: 'All'
      user_action: ''

    # Extract query params
    decodeURIComponent(window.location.search).substr(1).split('&').forEach (pair) ->
      pair = pair.trim().split('=')
      if filterObj[pair[0]]
        filterObj[pair[0]] = pair[1]
      return

    vof.setFilter = (filterType, value) ->
      filterObj[filterType] = value;
      filterObj.user_action = 'f'
      if ['city', 'cycle'].includes(filterType) and filterObj[filterType] != 'All'
        updateFilterParams filterType
      else if filterType == 'city'
        populateCyclesFilter("")
        vof.toggleFilter vof.dashboardFilters, true
      else if filterType == 'cycle'
        populateLfasFilter("")
        vof.toggleFilter vof.dashboardFilters.slice(1, 3), true
      return

    # update url parameters and make ajax call if necessary
    updateFilterParams = (filterType) ->
      $.ajax
        type: 'GET'
        url: buildFilterParams()
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (data) ->
          if filterType == 'city'
            populateCyclesFilter data
            vof.toggleFilter vof.dashboardFilters.slice(0, 1), false
          else if filterType == 'cycle'
            populateLfasFilter data
            vof.toggleFilter vof.dashboardFilters.slice(1, 3), false
      return

    #load url parameters along with selection properties
    buildFilterParams = ->
      baseUrl = window.location.protocol + '//' + window.location.host + '/?'
      Object.keys(filterObj).forEach (key) ->
        baseUrl += key + '=' + filterObj[key] + '&'
        return
      return baseUrl.substr(0, baseUrl.length - 1)

    # Removes the filter spinner
    vof.hideFilterSpinner = ->
      $('.filter-spinner').css('display','none')
      $('#apply-filter').css('display','block')
      return

    # Removes the limited number of records spinner
    vof.hideLimitSpinner = ->
      $('.limit-spinner').css('display','none')
      return

    # Populate Cycles filter when location is changed
    populateCyclesFilter = (data) ->
      $('#select_cycle').html ''
      cycleOptions = '<option value=All> All </option>'
      $.each data.cycles, (index, cycle) ->
        cycleOptions += '<option value=' + cycle + '>' + cycle + '</option>'
        return
      vof.generateDropdown $('#select_cycle'), cycleOptions
      vof.hideFilterSpinner()
      return

    # Extract lfa name from their email
    getLfaName = (lfaEmail) ->
      lfaName = undefined
      lfaName = lfaEmail.split('@')[0].split('.').map((lfaName) -> lfaName.charAt(0).toUpperCase() + lfaName.slice(1))
      return lfaName.join ' '
      
    # Populate LFAs filter when cycle is changed
    populateLfasFilter = (data) ->
      $('#select_week1_lfa').html ''
      $('#select_week2_lfa').html ''
      lfaOptions = '<option value=All> All </option>'
      $.each data.lfas, (index, lfaEmail) ->
        lfaName = getLfaName(lfaEmail)
        lfaOptions += '<option value="' + lfaEmail + '">' + lfaName + '</option>'
        return
      vof.generateDropdown $('#select_week1_lfa'), lfaOptions
      vof.generateDropdown $('#select_week2_lfa'), lfaOptions
      vof.hideFilterSpinner()
      return

    # Diasble appropriate fields when page is reloaded
    disableStatus = ->
      $.ajax
        type: 'GET'
        url: '/bootcampers/all'
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (campers) ->
          $.each campers, (index, camper) ->  
            week1Selected = $('#decision1_status_' + camper.camper_id + ' :selected').text()
            week2Selected = $('#decision2_status_' + camper.camper_id + ' :selected').text()
  
            vof.enableDropDownFields(['#decision1_status_' + camper.camper_id, '#week1_lfa_' + camper.camper_id])
            if week1Selected and week1Selected.trim() != 'Advanced'
              if week1Selected.trim() == 'In Progress'
                vof.displayHideSpanTexts(['#reason1_default_' + camper.camper_id], 'Not Applicable')
                vof.disableDropDownFields(['#reason1_' + camper.camper_id])
              spanIds = ['#reason2_default_' + camper.camper_id, '#decision2_' + camper.camper_id,  '#week2_lfa_default_' + camper.camper_id]
              vof.displayHideSpanTexts(spanIds, 'Not Applicable')
              dropDownIds = ['#reason2_' + camper.camper_id,  '#decision2_status_' + camper.camper_id, '#week2_lfa_' + camper.camper_id]
              vof.disableDropDownFields(dropDownIds)
            else
              vof.enableDropDownFields(['#week2_lfa_' + camper.camper_id])
              if week2Selected.trim() == 'In Progress'
                vof.displayHideSpanTexts(['#reason2_default_' + camper.camper_id])
                vof.enableDropDownFields(['#reason2_' + camper.camper_id])
            return
          return
      return
    disableStatus()

    #Adds the sort drop-down button
    $('.sort-button').dropdown
      inDuration: 300
      outDuration: 225
      constrainWidth: false
      gutter: 0
      belowOrigin: false
      alignment: 'left'
      stopPropagation: false

    #load filter results when apply button is clicked
    $('#apply-filter').click ->
      window.location.href = buildFilterParams()
      return

    # populates the comment modal
    vof.addComment = ->
      $('.add-comment').on 'click', ->
        $('#decision_one_comment').val("")
        $('#decision_two_comment').val("")

        camper_id = @id
        url = "bootcampers/#{camper_id}/decision_comments"
        $.ajax
          type: 'GET'
          url: url
          contentType: 'application/json;charset=utf-8'
          dataType: 'json'
          success: (decision_comments) ->
            $('#decision-one-comments-modal').attr('action', url)
            $('#decision-two-comments-modal').attr('action', url)
            if decision_comments['decision_one_comment'] != ""
              $('#decision_one_label').addClass('active');
              $('#decision_one_comment').val(decision_comments['decision_one_comment'])
            if decision_comments['decision_two_comment'] != ""
              $('#decision_two_label').addClass('active');
              $('#decision_two_comment').val(decision_comments['decision_two_comment'])

    vof.addComment()

    vof.selectDecisionTab = ->
      # opens the modal and selects decision one tab
      $('.edit-decision-one').on 'click', ->
        $('ul.tabs').tabs('select_tab', 'decision-one-comment');
        $('ul.tabs').find('.indicator').removeClass('indicator-left');

      # opens the modal and selects decision two tab
      $('.edit-decision-two').on 'click', ->
        $('ul.tabs').tabs('select_tab', 'decision-two-comment');
        $('ul.tabs').find('.indicator').addClass('indicator-left');
      
      # removes the indicator-left class
      $('#decison-one').on 'click', ->
        $('ul.tabs').find('.indicator').removeClass('indicator-left');

    vof.selectDecisionTab()

    # Collapses div cards
    collapseCard = ->
      $("[class^='camper-row camper-sdata-']").hide()

    # Toggles div cards
    toggleCard = ->
      collapseCard()
      $('.all_data').on "click", "[class^='camper-row camper-fdata-']", (e) ->
        e.stopPropagation()
        elem = $(this)
        id = elem[0].className.slice(24)
        $('.camper-sdata-'+id + '').eq(0).toggle()
        return
      return
    toggleCard()

    # disable dependent filters
    vof.disableFilters(filterObj)

    # Enforce dashboard features
    vof.dashboardControl = ->
      disableStatus()
      collapseCard()
      vof.changeCamperStatus()
      vof.changeLfa()
  return

if window.location.pathname == '/' then applyJs() else ''
