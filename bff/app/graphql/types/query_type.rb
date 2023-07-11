module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :recipes, Types::RecipeType.connection_type, null: false do
      argument :image_size, String, required: false
    end

    def recipes(image_size: nil)
      Connections::RecipesConnection.new(nil)
    end

    field :recipe, Types::RecipeType, null: false do
      argument :id, String, required: true
      argument :image_size, String, required: false
    end

    def recipe(id:, image_size: nil)
      client = MinirecipeClient.new
      res = client.get("/recipes/#{id}", { image_size: image_size })
      res[:recipe]
    end
  end
end
