class Connections::RecipesConnection < GraphQL::Pagination::Connection
  def nodes
    results[:recipes]
  end

  def has_previous_page
    false
  end

  def has_next_page
    results[:page_info][:has_next_page]
  end

  def cursor_for(item)
    item[:id].to_s
  end

  private

  def results
    return @res if @res
    client = MinirecipeClient.new
    res = client.get("/recipes", { cursor: @after_value, limit: @first_value, image_size: image_size })
    @res = res
  end

  def image_size
    @image_size ||= @arguments[:image_size]
  end
end
