module FeatureHelpers
  def url_params(url_to_parse = current_url)
    Rack::Utils.
      parse_query(URI.parse(url_to_parse).query).
      with_indifferent_access
  end
end
