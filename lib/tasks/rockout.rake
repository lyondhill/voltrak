namespace :rock do
  desc 'rockout'
  task out: :environment do
    number ||= -1
    loop do
      Cell.all.each do |cell|
        r = cell.reports.create(report_time: Time.now, voltage: rand(0.0..10.0))
        puts "Inserting record at #{r.report_time}, voltage: #{r.voltage}"
      end
      puts ""
      if ((number += 1) % 5) == 0
        QuarterlyReport.perform
        HourlyReport.perform
      end
      puts 'All done'
      sleep(10)
    end
  end
end

namespace :blast do
  desc 'blast it'
  task :it, [:frame] => [:environment] do |t, args|
    loop do
      frame = Frame.find(args.frame)
      puts "FRAME: #{frame.id}"
      frame.cells.each do |c|
        puts "CELL: #{c.id}"
        10.times do
          puts "create report"
          c.reports.create(report_time: Time.now, voltage: rand(0.0..10.0))
        end
      end
      sleep(3)
      QuarterlyReport.perform
      HourlyReport.perform
    end
  end
end