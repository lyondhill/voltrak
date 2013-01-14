# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
  target.append(spinner.el);








  i               = 0
  choices         = $("#choices")
  colors          = []
  datasets        = null
  canvas          = $("#cells-flot")

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

  # request json data on initial page load
  jqxhr = $.getJSON( canvas.data('json-route') , (data) ->
    datasets = data
  ).success(->
  ).error(->
    console.log "error"
  ).complete(->
    plotData()
  )

  # load new json data based on time frame
  $('#timeframe-select').find('a').on 'ajax:success', () ->
    $('#timeframe').text($(this).text())
    $('#timeframe').closest('button').data('timeframe', $(this).data('timeframe'))

    datasets = arguments[1]
    plotAccordingToChoices()

  pollData = ->
    console.log "POLL"

    route     = $('#timeframe').closest('button').data('poll')
    timeframe = $('#timeframe').closest('button').data('timeframe')

    jqxhr = $.getJSON( "#{route}?timeframe=#{timeframe}" , (data) ->
      datasets = data
    ).success(->
    ).error(->
      console.log "error"
    ).complete(->
      plotAccordingToChoices()
    )

  setInterval pollData, 10000


  $('#btn-selectall').on 'click', (event) ->
    choices.find('input').attr('checked', 'checked')
    plotAccordingToChoices()


  $('#btn-deselectall').on 'click', (event) ->
    choices.find('input').removeAttr('checked')
    plotAccordingToChoices()

  plotData = ->
    # read returned JSON
    $.each datasets, (k, v) ->
      #insert checkboxes
      label = $("<label for='id#{k}'>#{v[k].label}</label>")
      input = $("<input type='checkbox' name='#{k}' checked='checked' id='id#{k}'>")
      icon  = "<i class='icon-pause'></i>"

      choices.append(label.append(input, icon))
      
      input.on 'change', (event) ->
        plotAccordingToChoices()

      # format time to readable
      # console.log v[k]["data"]
      $.each v[k]["data"], (k,v) ->
        v[0] = formatTime v[0]

      # console.log v[k]["data"]
      
      # hard-code colors so they don't change as you toggle them on/off
      v[k].color = i
      ++i

    previousPoint = null
    canvas.bind "plothover", (event, pos, item) ->

      $("#x").text pos.x.toFixed(2)
      $("#y").text pos.y.toFixed(2)

      if item
        unless previousPoint is item.dataIndex
          previousPoint = item.dataIndex
          $("#tooltip").remove()
          x = item.datapoint[0].toFixed(2)
          y = item.datapoint[1].toFixed(2)
          time = new Date(x* 1000);
          # Not tredding on your toes. just listening to suggestions.
          showTooltip item.pageX, item.pageY, item.series.label + " at #{time.getHours()}:#{time.getMinutes()} = #{y}", datasets[item['seriesIndex']][item['seriesIndex']]['color']

          # showTooltip item.pageX, item.pageY, item.series.label + " of #{x} = #{y}", datasets[item['seriesIndex']][item['seriesIndex']]['color']
      else
        $("#tooltip").remove()
        previousPoint = null

    plotAccordingToChoices()


  # build plot
  plotAccordingToChoices = ->
    resetFlot()

    data = []
    
    choices.find('input:checked').each ->
      key = $(this).attr("name")

      data.push datasets[key][key] if key and datasets[key][key]

    if data.length > 0
      # console.log "PLOT"

      spinner.stop()
      $('#choices-select').fadeIn()

      plot = $.plot canvas, data, plotOptions

      series = plot.getData()
      $.each series, (i,e) ->
        colors.push series[i].color


  resetFlot = () ->
    # console.log "RESET"
    $.plot(canvas, [], plotOptions)
    

  # show flot tooltip
  showTooltip = (x, y, contents, color) ->
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


  # format UNIX times
  formatTime = (UNIX_timestamp) ->
    # console.log "FORMAT TIME"
    time = UNIX_timestamp*1000
