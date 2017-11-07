# Behaviours and hooks for updating and getting camper's decision status and lfas
camperStatus = ->
  $(document).ready ->
    # update decision gap details
    weekUpdate = (week, camperId) ->
      updatedData = Object.keys(week)[0]
      $.ajax
        url: '/bootcampers/' + camperId + '.json'
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-CSRF-TOKEN', $('meta[name="csrf-token"]').attr('content')
          return
        type: 'PUT'
        data: week
        success: (response) ->
          successMessage(updatedData)

    displayMessage = (message) ->
      Materialize.toast(message + ' successfully updated', 5000, 'black')

    # set message for the available updates
    successMessage = (data) ->
      switch data
        when 'decision_one'
          displayMessage 'Decision 1 status'
        when 'decision_two'
          displayMessage 'Decision 2 status'
        when 'week_one_lfa'
          displayMessage 'Week 1 LFA'
        when 'week_two_lfa'
          displayMessage 'Week 2 LFA'
      return

    # disable a dropdown lists
    vof.disableDropDownFields = (dropdownIds) ->
      $.each dropdownIds, (index, dropdownId) ->
        $(dropdownId).material_select 'destroy'
        return
      return

    vof.displayHideSpanTexts = (defaultSpanIds, textField = '') ->
      $.each defaultSpanIds, (index, defaultSpanId) ->
        $( defaultSpanId).text textField
        return
      return

    vof.enableDropDownFields = (dropdownIds) ->
      $.each dropdownIds, (index, dropdownId) ->
        $(dropdownId).material_select()
        return
      return

    # Check if camper's status is changed
    vof.changeCamperStatus = ->
      $('select.camper_status').change ->
        status = @value
        id = @id.split('_status_')[0]
        camperId = @id.split('_status_')[1]
 
        if id == 'decision1'
          week = decision_one: status
          
          if status.trim() == 'In Progress'
            vof.displayHideSpanTexts(['#reason1_default_' + camperId], 'Not Applicable')
            vof.disableDropDownFields(['#reason1_' + camperId])
          else
            vof.displayHideSpanTexts(['#reason1_default_' + camperId])
            vof.getStatusReasons(camperId, status, '#reason1_' + camperId, 1)
          if status.trim() == 'Advanced'
            vof.enableDropDownFields(['#decision2_status_' + camperId, '#week2_lfa_' + camperId])
            vof.displayHideSpanTexts(['#decision2_' + camperId, '#week2_lfa_default_' + camperId])
          else
            dropdownFieldsIds = ['#week2_lfa_' + camperId, '#decision2_status_' + camperId, '#reason2_' + camperId ]
            vof.disableDropDownFields(dropdownFieldsIds)
            spanIds = ['#decision2_' + camperId, '#week2_lfa_default_' + camperId, '#reason2_default_' + camperId]
            vof.displayHideSpanTexts(spanIds, 'Not Applicable')
        else
          week = decision_two: status
          if status.trim() == 'In Progress'
            vof.displayHideSpanTexts(['#reason2_default_' + camperId], 'Not Applicable')
            vof.disableDropDownFields(['#reason2_' + camperId])
          else
            vof.enableDropDownFields(['#reason2_' + camperId])
            vof.displayHideSpanTexts(['#reason2_default_' + camperId])
            vof.getStatusReasons(camperId, status, '#reason2_' + camperId, 2)
        camperId = $(this).attr('data-camper-id')
        if weekUpdate(week, camperId)
          joinedStatus = status.split(' ').join('').toLowerCase()
          $('#' + camperId).attr 'class', 'status-color status-' + joinedStatus
        return

    vof.changeCamperStatus()

    # Check if LFA is changed
    vof.changeLfa = ->
      $('select.camper_lfa').change ->
        camperId = undefined
        id = undefined
        lfa = undefined
        week = undefined
        camperId = undefined
        lfa = undefined
        week = undefined
        lfa = @value
        id = @id.split('_lfa_')[0]
        camperId = @id.split('_lfa_')[1]

        if id == 'week1'
          week = week_one_lfa: lfa
        else
          week = week_two_lfa: lfa

        camperId = $(this).attr('data-camper-id')
        weekUpdate week, camperId
        return

    vof.changeLfa()
  return
if window.location.pathname == '/' then camperStatus() else ''
