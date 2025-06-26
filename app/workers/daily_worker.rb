require 'rake'

class DailyWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "[DailyTasksWorker] Running daily:all Rake task..."
    Rake::Task.clear # to avoid redefinition warnings in dev/test
    Rails.application.load_tasks
    Rake::Task['monthly:all'].invoke
  end
end
