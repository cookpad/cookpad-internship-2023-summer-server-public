class RecipeHashtagsController < ApplicationController
  def index
    hashtags = Hashtag.where(recipe_id: recipe_ids).order(created_at: :desc)
    hashtags_by_recipe = hashtags.group_by { |hashtag| hashtag.recipe_id }
    recipe_hashtags = recipe_ids.map { |recipe_id|
      RecipeHashtag.new(recipe_id: recipe_id, hashtags: (hashtags_by_recipe[recipe_id] || []).first(hashtag_limit_per_recipe))
    }
    render json: recipe_hashtags
  rescue NameError => e
    Rails.logger.debug("=============================================")
    Rails.logger.debug("WARNING: Hashtag モデルを生成するまで動かない")
    Rails.logger.debug("=============================================")
    head :not_implemented
  end

  private

  def hashtag_limit_per_recipe
    (params[:hashtag_limit_per_recipe] || 10).to_i
  end

  def recipe_ids
    ids = params[:recipe_ids] || ""
    ids.split(",").map(&:to_i)
  end
end
