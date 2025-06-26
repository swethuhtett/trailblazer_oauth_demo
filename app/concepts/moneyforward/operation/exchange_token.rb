require 'pry'

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
        req.headers['Authorization'] =
          'Basic ' + Base64.strict_encode64("#{ENV['MF_CLIENT_ID']}:#{ENV['MF_CLIENT_SECRET']}")

        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'

        req.body = {
          grant_type:   'authorization_code',
          code:         code
        }
      end

      if response.success?
        json = JSON.parse(response.body)
        ctx[:access_token]  = json['access_token']
        ctx[:refresh_token] = json['refresh_token']
        ctx[:expires_in]    = json['expires_in']
        puts "access_token: #{ctx[:access_token]}"
        true
      else
        ctx[:error] = response.body
        false
      end
    end
  end
end
