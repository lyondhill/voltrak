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


  i               = 0
  choices         = $("#choices")
  colors          = []
  datasets        = null
  canvas          = $("#frames-flot")
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
        # date  = new Date(val)

        # day   = date.getDate()
        # month = date.getMonth()
        # year  = date.getFullYear().toString().substring(2)

        # "#{day}/#{month}/#{year}"
        new Date(val).toLocaleString()

    legend: 
      show: false

  # request json data on initial page load
  jqxhr = $.getJSON( jsonRoute , (data) ->
    datasets = data
  ).success(->
  ).error(->
    console.log "init error"
  ).complete(->
    plotData()
  )

  # load new json data based on time frame
  $('#timeframe-select').find('a').on 'ajax:success', () ->
    $('#timeframe').text($(this).text())
    $('#timeframe').closest('button').data('timeframe', $(this).data('timeframe'))

    datasets = arguments[1]
    plotAccordingToChoices()

  # select all choices and plot
  $('#btn-selectall').on 'click', (event) ->
    # console.log "SELECT ALL"
    choices.find('input').prop('checked', 'checked')
    plotAccordingToChoices()

  # deselect all choices and plot
  $('#btn-deselectall').on 'click', (event) ->
    # console.log "DESELECT ALL"
    choices.find('input').removeAttr('checked')
    plotAccordingToChoices()

  
  # poll for data
  pollData = ->
    route     = $('#timeframe').closest('button').data('poll')
    timeframe = $('#timeframe').closest('button').data('timeframe')

    # console.log "POLLING: %o %o", route, timeframe

    jqxhr = $.getJSON( "#{route}?timeframe=#{timeframe}" , (data) ->
      datasets = data
      console.log data
    ).success(->
    ).error(->
      console.log "polling error"
    ).complete(->
      plotAccordingToChoices()
    )

  # setInterval pollData, 300000

  plotData = ->
    
    # build choices
    $.each datasets, (k, v) ->
      # console.log v[k]["data"]
      
      #insert checkboxes
      label = $("<label for='id#{k}'>#{v[k].label}</label>")
      input = $("<input type='checkbox' name='#{k}' checked='checked' id='id#{k}' />")
      choices.append(label.append(input))
      
      input.on 'change', (event) -> plotAccordingToChoices()

      # hard-code colors so they don't change as you toggle them on/off
      v[k].color = i; ++i

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
            "background-color": '#111111' #datasets[item['seriesIndex']][item['seriesIndex']]['color']
            opacity:            1 

          content = "Cell #{item.series.label}: #{data} (#{time})"
          $("<div id='tooltip'>#{content}</div>").css(tooltipOptions).appendTo("body").fadeIn 250

      else
        prevPoint = null
        $("#tooltip").remove()

    plotAccordingToChoices()


  # build plot
  plotAccordingToChoices = ->
    console.log "PLOT CHOICES: %o", choices

    resetFlot()

    data = []
    
    choices.find('input:checked').each ->
      
      key = $(this).attr("name")

      data.push datasets[key][key] if key and datasets[key][key]

    if data && data.length > 0
      console.log "PLOT #{data}"

      spinner.stop()
      $('#choices-select').fadeIn()

      plot = $.plot canvas, data, plotOptions

      series = plot.getData()
      $.each series, (i,e) ->
        colors.push series[i].color
        $($(choices).find('label').get(i)).css('background-color', colors[i])
    else 
      spinner.stop()

  resetFlot = () ->
    console.log "RESET"
    $.plot(canvas, [], plotOptions)

