module ApplicationHelper

  def setTempStatus temp
    if temp.between?(0, 50)
      'success'
    elsif temp.between?(50, 75)
      'warning'
    elsif temp > 75
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
