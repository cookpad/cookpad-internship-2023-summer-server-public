class LazyRecipeHashtags
  def initialize(query_ctx, recipe_id, hashtag_limit_per_recipe)
    @recipe_id = recipe_id
    @hashtag_limit_per_recipe = hashtag_limit_per_recipe
    @lazy_state = query_ctx[:lazy_recipe_hashtags] ||= {
      pending_ids: Set.new,
      loaded_ids: {},
    }
    @lazy_state[:pending_ids] << recipe_id
  end

  def hashtags
    loaded_record = @lazy_state[:loaded_ids][@recipe_id]
    if loaded_record
      loaded_record
    else
      pending_ids = @lazy_state[:pending_ids].to_a

      client = MinihashtagClient.new
      params = { recipe_ids: pending_ids.join(","), hashtag_limit_per_recipe: @hashtag_limit_per_recipe }
      res = client.get("/recipe_hashtags", params)
      recipe_hashtags = res[:recipe_hashtags]

      recipe_hashtags.each { |recipe_hashtag| @lazy_state[:loaded_ids][recipe_hashtag[:recipe_id]] = recipe_hashtag[:hashtags] }
      @lazy_state[:pending_ids].clear
      @lazy_state[:loaded_ids][@recipe_id]
    end
  end
end
