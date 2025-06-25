module Post::Operation
  class Update < Trailblazer::Operation
    step Model(Post, :find_by)
    step Contract::Build(constant: Post::Contract::Form)
    step Contract::Validate(key: :post)
    step Contract::Persist()
  end
end
