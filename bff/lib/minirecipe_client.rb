require 'net/http'

class MinirecipeClient
  def get(path, params = nil)
    uri = URI.parse("#{base_url}#{path}")
    uri.query = params.to_param()
    Rails.logger.debug("[Recipe] Request to #{uri}")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body, symbolize_names: true)
    else
      raise GraphQL::ExecutionError, "Request to minirecipe failed with status code #{response.code}"
    end
  rescue => e
    raise GraphQL::ExecutionError, e.message
  end

  private

  def base_url
    ENV.fetch("MINIRECIPE_BASE_URL", "http://localhost:3001")
  end
end
