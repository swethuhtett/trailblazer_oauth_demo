namespace :monthly do
  desc "Task 1"
  task one: :environment do
    puts "Running task one...#{Time.now}"
  end

  desc "Task 2"
  task two: :environment do
    puts "Running task two..."
  end

  desc "Task 3"
  task three: :environment do
    puts "Running task three..."
  end

  desc "Task 4: Create a new post"
  task four: :environment do
    post = Post.create(title: "Daily scheduled Post", content: "Automatically created at #{Time.now}")
    if post.persisted?
      puts "✅ Created Post ##{post.id}: #{post.title}"
    else
      puts "❌ Failed to create post: #{post.errors.full_messages.join(", ")}"
    end
  end

  desc "Run all monthly tasks"
  task all: [:one, :two, :three, :four]
end
