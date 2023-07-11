# frozen_string_literal: true

module Types
  class StepType < Types::BaseObject
    field :id, ID, null: false
    field :memo, String, null: false
    field :image_url, String, null: true
  end
end
