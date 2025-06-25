class OauthController < ApplicationController
  def start
    redirect_to "https://api.biz.moneyforward.com/authorize?response_type=code&client_id=#{ENV['MF_CLIENT_ID']}&redirect_uri=#{ENV['MF_REDIRECT_URI']}&scope=read write"
  end

  def callback
    result = Moneyforward::Operation::ExchangeToken.call(params: { code: params[:code] })

    if result.success?
      # Save token or redirect as needed
      redirect_to root_path, notice: 'Token acquired'
    else
      redirect_to root_path, alert: 'OAuth failed'
    end
  end
end
