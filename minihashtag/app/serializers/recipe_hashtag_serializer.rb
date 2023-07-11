class RecipeHashtagSerializer < ActiveModel::Serializer
  has_many :hashtags

  attributes :recipe_id, :hashtags
end
