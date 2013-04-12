class FramesController < ApplicationController

  def show
    @frame = Frame.find_by_slug!(params[:id])
    @cells = @frame.cells

    # fnordmetric
    # @frame.trigger_view_event
  end

  def get_cell_reports
    respond_to do |format|
      format.json { render json: Frame.find(params[:id]).json_reports(params[:timeframe].to_f)}
    end
  end

end