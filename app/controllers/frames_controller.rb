class FramesController < ApplicationController

  def show
    @frame = Frame.find(params[:id])
    @cells = @frame.cells
  end

end