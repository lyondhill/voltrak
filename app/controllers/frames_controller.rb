class FramesController < ApplicationController

  def show
    @frame = Frame.find(params[:id])
    @cells = @frame.cells

    # fnordmetric
    # @frame.trigger_view_event
  end

  def get_reports
    respond_to do |format|
      format.json { render json: Frame.find(params[:id]).json_reports }
    end
  end

end