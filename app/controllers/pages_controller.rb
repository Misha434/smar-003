class PagesController < ApplicationController
  def home
		@users = User.all
  end
  def terms
  end
end
