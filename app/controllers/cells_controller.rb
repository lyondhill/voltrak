class CellsController < ApplicationController

  def show
    @cell       = Cell.find(params[:id])
    @reports    = @cell.reports.desc(:report_time).skip(((params[:page] || 0) - 1).abs * 100).limit(100)
    @page_count = @cell.reports.count / 100
  end

  def get_report
    respond_to do |format|
      format.json { render json: Cell.find(params[:id]).json_reports(params[:days] || 1) }
    end
  end

end