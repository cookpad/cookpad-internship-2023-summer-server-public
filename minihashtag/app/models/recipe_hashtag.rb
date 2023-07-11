class RecipeHashtag < ActiveModelSerializers::Model
  attr_accessor :recipe_id, :hashtags

  def initialize(recipe_id:, hashtags:)
    self.recipe_id = recipe_id
    self.hashtags = hashtags
  end
end
