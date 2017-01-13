class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to '/restaurants'
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit

    @restaurant = Restaurant.find(params[:id])

    unless @restaurant.belongs_to_user?(current_user)
      flash[:notice] = "You cannot edit this restaurant"
      redirect_to '/restaurants'
    end

  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy

    @restaurant = Restaurant.find(params[:id])

    unless @restaurant.belongs_to_user?(current_user)
      flash[:notice] = "You cannot edit this restaurant"
      redirect_to '/restaurants'
    end

    @restaurant.destroy
    flash[:notice] = 'Restaurant deleted successfully'
    redirect_to '/restaurants'
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :image)
  end
end
