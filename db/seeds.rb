# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.production?
  AdminUser.create :email => 'admin@admin.com', :password => 'password', :password_confirmation => 'password'
  puts "username: 'admin@admin.com'"
  puts "password: 'password'"
  puts "These should be changed by going to /admin"

  Report.create
  QuarterlyReport.create
  HourlyReport.create
end

if Rails.env.development?

  def validate(o)
    if o.valid? 
      puts " Complete!".color(:green)
    else
      unless o.errors.messages.include?(:transaction)
        puts " Error!".color(:red)
        puts " #{o.errors.pretty_inspect}".color(:red)
        exit 1
      else
        puts " Complete!"
      end
    end
  end

  require 'rainbow'

  Sickill::Rainbow.enabled = true

  Mongoid.logger = nil
  Mongoid::Config.purge!

  # puts "\n\n"
  # colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default]
  # print "Rainbow Available Colors: ".color(:white)
  # colors.each do |c|
  #   (c == :black) ? (print "#{c}".color(c).background(:white)) : (print " #{c}".color(c))
  # end

  t = Time.new

  ###  -- BEGIN SEEDING DATABASE --
  puts "\n\n\n"
  puts "--- Begin Seeding Database ---".color(:cyan).underline
  puts "\n"

  puts "Building admin user".color(:yellow)
  puts "email: 'admin@example.com'".color(:yellow)
  puts "password: 'password'".color(:yellow)
  puts "These should be changed".color(:red)
  puts 
  
  AdminUser.create :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'

  print "generating plants................".color(:white)
  plants = [
    # Plant.create(temperature: rand(1..60), name: "Bolivia"),
    # Plant.create(temperature: rand(1..60), name: "Mexico"),
    Plant.create(temperature: rand(1..60), name: "India")
  ]
  puts " Complete! (created #{plants.count})".color(:green)

  print "generating frames................".color(:white)
  plants.each do |p|
    ('A'..'F').to_a.each do |letter|
      p.frames.create(name: "Frame #{letter}")
    end
  end
  puts " Complete! (created #{Frame.count})".color(:green)

  print "generating cells.................".color(:white)
  Frame.all.each do |f|
    15.times do |num|
      f.cells.create(status: [:errored, :active, :inactive].sample, uid: "#{'0' if num < 9}#{num + 1}")
    end
  end
  puts " Complete! (created #{Cell.count})".color(:green)

  puts "generating reports...............".color(:white)
  

  on_count = 600
  off_count = 200
  high = 4.0
  low = 2.0
  Cell.all.each_with_index do |c, modifier|
    puts "building for cell #{modifier} of #{@cell_count ||= Cell.count}"
    time = 1.day.ago
    # total = ((Time.now.to_i - week_epoc.to_i) / 30) * Cell.count
    start = on_count
    up = true
    while time < Time.now
      time += 30
      if up
        ran = (((start.to_f / on_count) * (high - low)) + low) * ((rand(0.8..1.2)))
        c.reports.create(report_time: time, voltage: ran)
        if start <= 0 
          up = false 
          start = off_count
        end
      else
        if start <= 0
          up = true
          start = on_count
        end
        c.reports.create(report_time: time, voltage: 0.0)
      end
      # print "#{"\r" + "\e[0K"}#{i + 1}/#{total} reports created........".color(:white)
      start -= 1
      
    end
  end
  puts " Complete! (created #{Report.count})".color(:green)

  puts "aggrigating reports"

  FiveMinuteReport.perform
  ThirtyMinuteReport.perform
  HourlyReport.perform

  puts " Complete! (created #{FiveMinuteReport.count})".color(:green)

  puts "\n"
  puts "!!! Database Seed Status: #{'SUCCESS'.color(:green).bright} !!!".color(:cyan)
  puts "Completed in: #{(Time.now - t).round(2)} sec"
  puts "\n\n\n"

end