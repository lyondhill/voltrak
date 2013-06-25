$ ->

  spinnerOptions = 
    lines:      9
    length:     4
    width:      6
    radius:     10
    corners:    1
    rotate:     0
    color:      '#000'
    speed:      1
    trail:      50
    shadow:     false
    hwaccel:    false
    className:  'spinner'
    zIndex:     2e9
    top:        'auto'
    left:       'auto'

  target  = $('.chart');
  spinner = new Spinner(spinnerOptions).spin();
  # target.append(spinner.el);

  # i               = 0
  # choices         = $("#choices")
  # colors          = []
  datasets        = null
  canvas          = $("#cells-flot")
  jsonRoute       = canvas.data('json-route')

  plotOptions =
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
        # console.log new Date(val).toString()
        # console.log new Date(val).toDateString()
        # console.log new Date(val).toLocaleString()
        # console.log new Date(val).toLocaleTimeString()
        # console.log new Date(val).toLocaleDateString()

        new Date(val).toLocaleString()

    legend: 
      show: false

  # request json data
  jqxhr = $.getJSON( jsonRoute, (data) ->
    datasets = data
  ).success(->
  ).error(->
    console.log "error"
  ).complete(->
    plotData()
  )

  # select all choices and plot
  $('#btn-refresh').on 'click', (event) ->
    $.getJSON( jsonRoute, (data) ->
      datasets = data
    ).success(->
    ).error(->
      console.log "error"
    ).complete(->
      console.log "REFRESHED!"
      plotData()
    )

  # build plot
  plotData = ->
    data = [datasets[0][0]['data']]

    # create the tool tips
    prevPoint = null
    canvas.bind "plothover", (event, pos, item) ->
      if item
        $("#x").text pos.x.toFixed(2)
        $("#y").text pos.y.toFixed(2)

        unless prevPoint is item.dataIndex
          $("#tooltip").remove()
          prevPoint   = item.dataIndex

          data        = item.datapoint[1].toFixed(2)
          time        = new Date(item.datapoint[0]).toLocaleString()
          
          # configure and show the tooltip
          tooltipOptions = 
            position:           'absolute'
            display:            'none'
            top:                (item.pageY - 10)
            left:               (item.pageX + 15)
            color:              '#FFFFFF'
            border:             'none'
            padding:            '2px'
            "background-color": '#111111'
            opacity:            1 

          content = "Voltage: #{data} (#{time})"
          $("<div id='tooltip'>#{content}</div>").css(tooltipOptions).appendTo("body").fadeIn 250

      else
        prevPoint = null
        $("#tooltip").remove()

    spinner.stop()
    plot = $.plot canvas, data, plotOptions
