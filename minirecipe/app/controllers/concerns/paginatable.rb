# NOTE: ここの実装はやや自信なし。だけどページネーションは課題にしたい
module Paginatable
  extend ActiveSupport::Concern

  sort_field = :id
  sort_order = :desc
  default_limit = 10

  included do
    scope :cursor, -> (cursor, limit) do
      limit = limit.present? ? limit : default_limit
      op = sort_order == :desc ? "<" : ">"

      ret = self.order("#{sort_field} #{sort_order}")
      ret = ret.where("#{sort_field} #{op} ?", cursor) if cursor.present? && Integer(cursor, exception: false)
      ret.limit(limit)
    end
  end
end
