class CellsController < ApplicationController

  def show
    @cell = Cell.find(params[:id])
    @reports = @cell.reports
  end

  def get_reports
    respond_to do |format|
      format.json { render json: @reports }
    end
  end

end