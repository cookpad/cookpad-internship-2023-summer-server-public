class HashtagsController < ApplicationController
  def create
    hashtag_attributes = hashtag_params[:value].split.map { |name|
      { name: name.delete_prefix("#"), recipe_id: hashtag_params[:recipe_id] } if name.start_with?("#")
    }.compact

    if hashtag_attributes.length == 0
      head :unprocessable_entity and return
    end

    hashtags = ActiveRecord::Base.transaction do
      Hashtag.create!(hashtag_attributes)
    end
    render json: hashtags, status: :created
  end

  private

  def hashtag_params
    params.require([:recipe_id, :value])
    params.permit([:recipe_id, :value])
  end
end
