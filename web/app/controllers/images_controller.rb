class ImagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @image = Image.all.order("created_at DESC")
    render json: @image, :except => [:imgstr]
  end

  def create
    @image = Image.new(user_name: params[:user_name], url: params[:url],
      line1: params[:line1], line2: params[:line2], line3: params[:line3])
    @image.save
    render json: {
      message: "Successfully created image",
      image: @image
      }, status: 200
  end
end
