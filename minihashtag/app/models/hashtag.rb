class Hashtag < ApplicationRecord
  validates :name, presence: true
  validates :recipe_id, presence: true
end
