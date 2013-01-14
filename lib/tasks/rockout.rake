namespace :rock do
  desc 'rockout'
  task out: :environment do
    loop do
      Cell.all.each do |cell|
        cell.reports.create(report_time: Time.now, voltage: rand(0.0..10.0))
      end
      sleep(30)
    end
  end
end