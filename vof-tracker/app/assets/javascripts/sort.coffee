$(document).ready ->
  $('.sort').click (event) ->
    name = event.target.id
    url = ""
    order = "asc"
    splittedUrlPath = window.location.search.substr(1).split('&')

    # checks if url path exists
    if splittedUrlPath.length == 1
      url = '?order=asc' + '&sort=' + name
    else
      foundSort = false

      splittedUrlPath.forEach (elem, index) ->
        #checks if sort parameter is present in the url
        if elem.split('=')[0] == 'order'
          order = if elem.split('=')[1] == 'asc' then 'desc' else 'asc'
          splittedUrlPath[index] = 'order=' + order
          foundSort = true
        else if elem.split('=')[0] == 'sort'
          splittedUrlPath[index] = 'sort=' + name

      if !foundSort
        url = '?' + 'order=' + order + '&' + 'sort=' + 'name' + '&' + splittedUrlPath.join('&')
      else
        url = '?' + splittedUrlPath.join('&')

    # if the save filter checkbox is checked, it saves the new url parameter
    if ($('.filled-in:checkbox').is(':checked'))
      localStorage.setItem 'url', window.location.origin + '/' + url.replace(/%20/g, ' ')

    window.location = url
