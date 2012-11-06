# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  # hard-code color indices to prevent them from shifting as
  # countries are turned on/off

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


  datasets =
    1:
      label: "1"
      data: [[1988, 483994], [1989, 479060], [1990, 457648], [1991, 401949], [1992, 424705], [1993, 402375], [1994, 377867], [1995, 357382], [1996, 337946], [1997, 336185], [1998, 328611], [1999, 329421], [2000, 342172], [2001, 344932], [2002, 387303], [2003, 440813], [2004, 480451], [2005, 504638], [2006, 528692]]
    2:
      label: "2"
      data: [[1988, 218000], [1989, 203000], [1990, 171000], [1992, 42500], [1993, 37600], [1994, 36600], [1995, 21700], [1996, 19200], [1997, 21300], [1998, 13600], [1999, 14000], [2000, 19100], [2001, 21300], [2002, 23600], [2003, 25100], [2004, 26100], [2005, 31100], [2006, 34700]]
    3:
      label: "3"
      data: [[1988, 62982], [1989, 62027], [1990, 60696], [1991, 62348], [1992, 58560], [1993, 56393], [1994, 54579], [1995, 50818], [1996, 50554], [1997, 48276], [1998, 47691], [1999, 47529], [2000, 47778], [2001, 48760], [2002, 50949], [2003, 57452], [2004, 60234], [2005, 60076], [2006, 59213]]
    4:
      label: "4"
      data: [[1988, 55627], [1989, 55475], [1990, 58464], [1991, 55134], [1992, 52436], [1993, 47139], [1994, 43962], [1995, 43238], [1996, 42395], [1997, 40854], [1998, 40993], [1999, 41822], [2000, 41147], [2001, 40474], [2002, 40604], [2003, 40044], [2004, 38816], [2005, 38060], [2006, 36984]]
    5:
      label: "5"
      data: [[1988, 3813], [1989, 3719], [1990, 3722], [1991, 3789], [1992, 3720], [1993, 3730], [1994, 3636], [1995, 3598], [1996, 3610], [1997, 3655], [1998, 3695], [1999, 3673], [2000, 3553], [2001, 3774], [2002, 3728], [2003, 3618], [2004, 3638], [2005, 3467], [2006, 3770]]

  i = 0
  $.each datasets, (key, val) ->
    val.color = i
    ++i

  choiceContainer = $("#choices")
  $.each datasets, (key, val) ->
    choiceContainer.append "<input type=\"checkbox\" name=\"#{key}\" checked=\"checked\" id=\"id#{key}\">" + "<label for=\"id#{key}\">#{val.label}</label>"

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
