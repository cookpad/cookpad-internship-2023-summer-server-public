require 'net/http'

class MinihashtagClient
  def get(path, params = nil)
    uri = URI.parse("#{base_url}#{path}")
    uri.query = params.to_param()
    Rails.logger.debug("[Hashtag] Request to #{uri}")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body, symbolize_names: true)
    else
      raise GraphQL::ExecutionError, "Request to minihashtag failed with status code #{response.code}"
    end
  rescue => e
    raise GraphQL::ExecutionError, e.message
  end

  def post(path, body)
    uri = URI.parse("#{base_url}#{path}")
    response = Net::HTTP.post_form(uri, body)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body, symbolize_names: true)
    else
      raise GraphQL::ExecutionError, "Request to minihashtag failed with status code #{response.code}"
    end
  rescue => e
    raise GraphQL::ExecutionError, e.message
  end

  private

  def base_url
    ENV.fetch("MINIHASHTAG_BASE_URL", "http://localhost:3002")
  end
end
