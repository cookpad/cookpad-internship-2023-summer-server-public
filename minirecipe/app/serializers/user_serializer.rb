class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url

  def image_url
    object.image_url("150x150c")
  end
end
