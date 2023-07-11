class RecipeSerializer < ActiveModel::Serializer
  belongs_to :user
  has_many :ingredients
  has_many :steps

  attributes :id, :title, :description, :image_url

  def image_url
    object.image_url(@instance_options[:image_size])
  end
end
