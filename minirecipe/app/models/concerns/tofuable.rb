module Tofuable
  class Error < StandardError; end

  extend ActiveSupport::Concern

  def image_url(geometry = nil, format: "jpg")
    return nil if self.id.nil?
    return nil unless self.has_photo?

    geometry = "m" if geometry.blank?
    # Tofu は社内システムで利用できないため、ダミー画像を返すようにしています
    "https://placehold.jp/#{geometry}.png"
  end

  def has_photo?
    photo_saved_at?
  end
end
