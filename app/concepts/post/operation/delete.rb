module Post::Operation
  class Delete < Trailblazer::Operation
    step Model(Post, :find_by)
    step ->(ctx, model:, **) { model.destroy }
  end
end
