class Products::SearchesController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :set_q, only: :index
  include Pagy::Backend

  def index
    @pagy, @results = pagy(@q.result.with_attached_image.includes(:brand))
  end
end