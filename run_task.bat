@echo off
cd /d "C:\Users\User\Desktop\Project 2.0\trailblazer_oauth_demo"
bundle exec rails monthly:all >> log\cron_task.log 2>&1
