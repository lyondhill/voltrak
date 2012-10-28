class CellsController < ApplicationController

  def show
    @cell = Cell.find(params[:id])
    @reports = @cell.reports
  end

end