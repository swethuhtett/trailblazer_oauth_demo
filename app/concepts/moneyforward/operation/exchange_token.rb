module Moneyforward::Operation
  class ExchangeToken < Trailblazer::Operation
    step :exchange_code

    def exchange_code(ctx, params:, **)
      code = params[:code]

      conn = Faraday.new(url: 'https://api.biz.moneyforward.com') do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end

      response = conn.post('/token') do |req|
        req.body = {
          grant_type:    'authorization_code',
          code:          code,
          client_id:     ENV['MF_CLIENT_ID'],
          client_secret: ENV['MF_CLIENT_SECRET'],
          redirect_uri:  ENV['MF_REDIRECT_URI']
        }
      end

      if response.success?
        json = JSON.parse(response.body)
        ctx[:access_token]  = json['access_token']
        ctx[:refresh_token] = json['refresh_token']
        ctx[:expires_in]    = json['expires_in']
        true
      else
        ctx[:error] = response.body
        false
      end
    end
  end
end
