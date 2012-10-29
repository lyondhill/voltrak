class FramesController < ApplicationController

  def show
    @frame = Frame.find(params[:id])
    @cells = @frame.cells

    # fnordmetric
    # @frame.trigger_view_event
  end

end