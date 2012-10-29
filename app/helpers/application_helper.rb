module ApplicationHelper

  def setTempStatus temp
    if temp.between?(0, 50)
      'success'
    elsif temp.between?(50, 75)
      'warning'
    elsif temp > 75
      'error'
    end
  end

  def setStatusIndicator status
    case status
      when :active
      when :inactive
        'warning'
      when :errored
        'error'
      else
    end
  end

end
