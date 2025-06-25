class SessionsController < ApplicationController
  def create
    result = User::Operation::Upsert.call(params: { auth: request.env['omniauth.auth'] })

    if result.success?
      user = result[:model]
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in as #{user.name}"
    else
      redirect_to root_path, alert: "Authentication failed"
    end
  end
end
