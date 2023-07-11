# frozen_string_literal: true

module Types
  class RecipeType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: false
    field :image_url, String, null: true
    field :user, Types::UserType, null: false
    field :ingredients, [Types::IngredientType], null: false
    field :hashtags, [Types::HashtagType], null: false do
      argument :hashtag_limit_per_recipe, Integer, required: false
    end
    field :steps, [Types::StepType], null: false

    def hashtags(hashtag_limit_per_recipe: 10)
      LazyRecipeHashtags.new(context, object[:id], hashtag_limit_per_recipe)
    end
  end
end
