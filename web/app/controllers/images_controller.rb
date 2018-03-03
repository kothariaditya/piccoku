class ImagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @image = Image.all
    render json: @image
  end

  def create
    @image = Image.new(user_name: params[:user_name], url: params[:url])
    @image.save
  end
end
