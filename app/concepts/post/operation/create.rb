module Post::Operation
  class Create < Trailblazer::Operation
    step Model(Post, :new)
    step Contract::Build(constant: Post::Contract::Form)
    step Contract::Validate(key: :post)
    step Contract::Persist()
  end
end
