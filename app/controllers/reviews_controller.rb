class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    review = @restaurant.reviews.build_with_user(review_params, current_user)
    if review.save
      redirect_to '/restaurants'
    else
      if review.errors[:user]
        flash[:notice] = review.errors[:user]
        redirect_to '/restaurants'
      else
        render :new
      end
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])

    unless @review.belongs_to?(current_user)
      flash[:notice] = "You cannot delete this review"
      redirect_to '/restaurants'
    end

    @review.destroy
    flash[:notice] = 'Review deleted successfully'
    redirect_to '/restaurants'
  end

  private
  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
