class OauthController < ApplicationController
  def start
    redirect_to "https://api.biz.moneyforward.com/authorize?response_type=code&client_id=#{ENV['MF_CLIENT_ID']}&scope=mfc/invoice/data.write", allow_other_host: true
  end

  def callback
    result = Moneyforward::Operation::ExchangeToken.call(params: { code: params[:code] })

    if result.success?
      session[:access_token] = result[:access_token]

      if result[:expires_in].to_i == 0
        session[:token_expired] = true
      else
        session[:token_expired] = false
      end
      redirect_to root_path, notice: 'Token acquired'
    else
      redirect_to root_path, alert: 'OAuth failed'
    end
  end

  def refresh
    refresh_token = session[:refresh_token] || params[:refresh_token]

    unless refresh_token.present?
      redirect_to root_path, alert: "No refresh token available"
      return
    end

    result = Moneyforward::Operation::RefreshToken.call(params: { refresh_token: refresh_token })

    if result.success?
      session[:access_token] = result[:access_token]
      session[:expires_in]   = result[:expires_in]

      redirect_to root_path, notice: "Token refreshed successfully"
    else
      redirect_to root_path, alert: "Failed to refresh token: #{result[:error]}"
    end
  end
end
