class RecipesController < ApplicationController
  def index
    cursor = params[:cursor]
    limit = params[:limit]
    recipes = Recipe.includes(:user, :ingredients, :steps).cursor(cursor, limit)

    page_info = {
      next_page_cursor: recipes.last&.id.to_s,
      has_next_page: recipes.last.present? && Recipe.cursor(recipes.last.id, 1).exists?,
    }

    render json: recipes,
      meta: page_info,
      meta_key: :page_info,
      image_size: params[:image_size]
  end

  def show
    recipe = Recipe.includes(:user, :ingredients, :steps).find(params[:id])

    render json: recipe,
      image_size: params[:image_size]
  end

  def create
    recipe = Recipe.create(
      title: recipe_params[:title],
      description: recipe_params[:description],
      user_id: recipe_params[:user_id],
    )

    ingredients = Ingredient.title_to_ingredients(title: recipe.title, authorization_header: request.headers["Authorization"])

    recipe.ingredients = ingredients.map.with_index { |ingredient, i|
      Ingredient.new(
        name: ingredient,
        position: i,
      )
    }

    recipe.save!
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :user_id)
  end
end
