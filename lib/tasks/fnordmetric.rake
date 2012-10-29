namespace :fnordmetric do
  desc 'Populate FnordMetric with events to simulate user activity'
  task populate: :environment do
    frames = Frame.all
    loop do
      frames.sample.trigger_view_event
      sleep(rand)
    end
  end
end