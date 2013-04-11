# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  dataset         = null
  json_route      = $("#cell_flot").data('json-route')
  plot_options    =
    series:
      lines:
        show: true
      points:
        show: false
    grid:
      hoverable: true
    yaxis:
      min: 0
    xaxis:
      mode: 'time'
      tickDecimals: 0
      timezone: 'browser'
      tickFormatter: (val, axis) ->
        new Date(val);

  # build plot
  plotFlot = ->
    # plot = $.plot $("#cell_flot"), dataset, plot_options
    plot = $.plot($("#cell_flot"), [data: dataset[0][0]['data']], plot_options )

  showTooltip = (x, y, contents) ->
    $("<div id='tooltip'>#{contents}</div>").css(
      position:           "absolute"
      display:            "none"
      top:                y - 10
      left:               x + 15
      color:              "#FFFFFF"
      border:             "1px solid #333333"
      padding:            "2px"
      "background-color": "#111111"
      opacity:            1
    ).appendTo("body").fadeIn 250

  formatTime = (UNIX_timestamp) ->
    time = UNIX_timestamp*1000

  # request json data
  jqxhr = $.getJSON( json_route, (data) ->
    dataset = data

  ).success(->
  ).error(->
    console.log "error"
  ).complete(->

    # read returned JSON
    $.each dataset, (k, v) ->
      # format time to readable
      $.each v[k]['data'], (k,v) ->
        v[0] = formatTime v[0]

    previousPoint = null
    $("#cell_flot").bind "plothover", (event, pos, item) ->

      $("#x").text pos.x.toFixed(2)
      $("#y").text pos.y.toFixed(2)

      if item
        unless previousPoint is item.dataIndex
          previousPoint = item.dataIndex
          $("#tooltip").remove()
          x = item.datapoint[0].toFixed(2)
          y = item.datapoint[1].toFixed(2)
          time = new Date(x*1000);

          showTooltip item.pageX, item.pageY, "#{y}"
      else
        $("#tooltip").remove()
        previousPoint = null

    plotFlot()
  )
