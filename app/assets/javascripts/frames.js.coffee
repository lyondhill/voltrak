# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  # hard-code color indices to prevent them from shifting as
  # countries are turned on/off

  i = 0
  choiceContainer = $("#choices")

  # insert checkboxes 
  plotAccordingToChoices = ->
    data = []
    choiceContainer.find("input:checked").each ->
      key = $(this).attr("name")
      data.push datasets[key] if key and datasets[key]

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

  showTooltip = (x, y, contents) ->
    $("<div id=\"tooltip\">#{contents}</div>").css(
      position: "absolute"
      display: "none"
      top: y + 5
      left: x + 5
      border: "1px solid #fdd"
      padding: "2px"
      "background-color": "#fee"
      opacity: 0.80
    ).appendTo("body").fadeIn 200

  console.log "get"
  datasets = null
  jqxhr = $.getJSON('http://localhost:3000/plants/509a023a965600ce2d000001/frames/509a023a965600ce2d000004/get_reports.json', (data) ->
    console.log "success"
    datasets = data
  ).success(->
  ).error(->
    console.log "error"
  ).complete(->
    console.log "complete"

    $.each datasets, (key, val) ->
      console.log key, val
      choiceContainer.append "<input type=\"checkbox\" name=\"#{key}\" checked=\"checked\" id=\"id#{key}\">" + "<label for=\"id#{key}\">#{val.label}</label>"

      val.color = i
      ++i

    choiceContainer.find("input").click plotAccordingToChoices

    previousPoint = null
    $("#cells_flot").bind "plothover", (event, pos, item) ->
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

