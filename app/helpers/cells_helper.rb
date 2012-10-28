module CellsHelper

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
