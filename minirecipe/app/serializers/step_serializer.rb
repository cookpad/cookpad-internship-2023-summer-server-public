class StepSerializer < ActiveModel::Serializer
  attributes :id, :memo, :image_url

  def image_url
    object.image_url("220x180")
  end
end
