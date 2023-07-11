class Ingredient < ApplicationRecord
  def self.title_to_ingredients(title:, authorization_header:)
    uri = URI.parse("https://title-to-ingredients-stg.cookpadapp.com/suggestions")

    Rails.logger.debug("[TitleToIngredient] Request to #{uri}")

    response = Faraday.get(uri, { query: title }, { "Authorization": "#{authorization_header}" })

    puts response.body
    if response.status == 200
      JSON.parse(response.body, symbolize_names: true)[:ingredients]
    else
      []
    end
  end
end
