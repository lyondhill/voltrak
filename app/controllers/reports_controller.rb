class ReportsController < ApplicationController

  def show
    @report = Report.find(params[:id])
  end

  def index
    respond_to do |format|
      format.csv { send_data Report.to_csv }
    end
  end

end