module User::Operation
  class Upsert < Trailblazer::Operation
    step :extract_user_data
    step :find_or_initialize
    step :assign_attributes
    step :save

    def extract_user_data(ctx, params:, **)
      ctx[:oauth_data] = params[:auth]
    end

    def find_or_initialize(ctx, **)
      data = ctx[:oauth_data]
      ctx[:model] = User.find_or_initialize_by(provider: data.provider, uid: data.uid)
    end

    def assign_attributes(ctx, **)
      data = ctx[:oauth_data]
      user = ctx[:model]

      user.name = data.info.name
      user.token = data.credentials.token
    end

    def save(ctx, model:, **)
      model.save
    end
  end
end
