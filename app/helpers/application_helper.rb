module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end

  def formatNumber num
    if num
      if num < 10
        "#{num}°C"
      else
        num
      end
    else
      '0°C'
    end
  end

  def setTempStatus temp = nil
    if temp
      if temp.between?(0, 20)
        'success'
      elsif temp.between?(20, 40)
        'warning'
      elsif temp > 40
        'important'
      end
    else
      'warning'
    end
  end

  def setVoltStatus avg, current
    deviation = (avg - current).abs
    if current < 0.2
      'info'
    elsif deviation < 0.5
      'success'
    elsif deviation < 1.0
      'warning'
    else
      'important'
    end
  end

  def setStatus status
    case status
      when :active
        'success'
      when :inactive
        'warning'
      when :errored
        'important'
      else
    end
  end

end
