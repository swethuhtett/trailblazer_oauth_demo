module Post::Contract
  class Form < Reform::Form
    property :title
    property :content

    validates :title, presence: true
    validates :content, presence: true
  end
end
