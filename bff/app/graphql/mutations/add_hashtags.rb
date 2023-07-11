class Mutations::AddHashtags < Mutations::BaseMutation
  argument :recipe_id, ID
  argument :value, String

  field :hashtags, [Types::HashtagType]

  def resolve(recipe_id:, value:)
    # TODO: Error Handling
    body = { recipe_id: recipe_id, value: value }

    client = MinihashtagClient.new
    res = client.post("/hashtags", body)
  end
end
