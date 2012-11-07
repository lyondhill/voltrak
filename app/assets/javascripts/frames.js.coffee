# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  i               = 0
  choices         = $("#choices")
  datasets        = null
  json_route      = $("#cells_flot").data('json-route')

  # insert checkboxes 
  plotAccordingToChoices = ->
    console.log "plotting..."
    data = []

    choices.find('input:checked').each ->
      key = $(this).attr("name")
      data.push datasets[key][key] if key and datasets[key][key]

    if data.length > 0
      $.plot $("#cells_flot"), data,
        series:
          lines:
            show: true
          points:
            show: true
        grid:
          hoverable: true

        yaxis:
          min: 0
        xaxis:
          tickDecimals: 0

  showTooltip = (x, y, contents, color) ->
    $("<div id='tooltip'>#{contents}</div>").css(
      position:           "absolute"
      display:            "none"
      top:                y - 10
      left:               x + 15
      border:             "1px solid #fdd"
      padding:            "2px"
      "background-color": color
      opacity:            0.75
    ).appendTo("body").fadeIn 200

  # request json data
  jqxhr = $.getJSON( json_route, (data) ->
    datasets = data
  ).success(->
  ).error(->
    console.log "error"
  ).complete(->
    $.each datasets, (key, val) ->
      choices.append "<label for='id#{key}'><input type='checkbox' name='#{key}' checked='checked' id='id#{key}'><i class='icon-th'></i> Cell: #{val[key].label}</label>"
      
      # hard-code color indices to prevent them from shifting as
      # countries are turned on/off
      val[key].color = i
      ++i

    choices.find('input').on 'click', (event) ->
      plotAccordingToChoices()

    $('#btn-checkall').on 'click', (event) ->
      choices.find('input').attr('checked', 'checked')
      plotAccordingToChoices()

    previousPoint = null
    $("#cells_flot").bind "plothover", (event, pos, item) ->
      console.log datasets[item['seriesIndex']][item['seriesIndex']]['color']

      $("#x").text pos.x.toFixed(2)
      $("#y").text pos.y.toFixed(2)

      if item
        unless previousPoint is item.dataIndex
          previousPoint = item.dataIndex
          $("#tooltip").remove()
          x = item.datapoint[0].toFixed(2)
          y = item.datapoint[1].toFixed(2)

          showTooltip item.pageX, item.pageY, item.series.label + " of #{x} = #{y}"
      else
        $("#tooltip").remove()
        previousPoint = null

    plotAccordingToChoices()
  )

