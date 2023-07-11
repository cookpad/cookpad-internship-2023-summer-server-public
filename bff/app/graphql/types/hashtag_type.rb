# frozen_string_literal: true

module Types
  class HashtagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
  end
end
