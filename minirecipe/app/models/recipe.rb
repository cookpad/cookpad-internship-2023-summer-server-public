class Recipe < ApplicationRecord
  include Tofuable
  include Paginatable

  belongs_to :user
  has_many :ingredients, -> { order("position") }, dependent: :destroy
  has_many :steps, -> { order("position") }, dependent: :destroy
end
