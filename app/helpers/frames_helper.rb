module FramesHelper

  def setTempStatus temp
    if temp.between?(50, 75)
      'warning'
    elsif temp > 75
      'error'
    end
  end

end
