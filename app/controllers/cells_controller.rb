class CellsController < ApplicationController

  def show
    @cell = Cell.find(params[:id])
    @reports = @cell.reports
  end

  def get_report
    respond_to do |format|
      format.json { render json: Cell.find(params[:id]).json_reports(params[:days] || 1) }
    end
  end

end