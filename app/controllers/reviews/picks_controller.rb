module Reviews
  class PicksController < ApplicationController
    def index
      @reviews = Product.joins(:brand).where('brand_id=?', params[:brand_id])
      respond_to do |format|
        format.html { redirect_to :root }
        format.json { render "reviews/picks.json.jbuilder" }
      end
    end
  end
end
