class ImagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @image = Image.all.order("created_at DESC")
    render json: @image
  end

  def create
    @image = Image.new(user_name: params[:user_name], url: params[:url])
    @image.save
    render json: {
      message: "Successfully created image",
      image: @image
      }, status: 200
  end
end
