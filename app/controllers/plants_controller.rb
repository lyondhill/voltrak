class PlantsController < ApplicationController

  def index
    if Plant.count == 1
      redirect_to(plant_url(Plant.first.name))
    else
      @plants = Plant.all
    end
  end

  def show
    @plant  = Plant.find_by_slug!(params[:id])
    @frames = @plant.frames
  end

end
