# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

  print "generating plants................".color(:white)
  plants = [
    Plant.create(temperature: rand(1..60), name: "Singapore"),
    Plant.create(temperature: rand(1..60), name: "USA"),
    Plant.create(temperature: rand(1..60), name: "Europe")
  ]
  puts " Complete! (created #{plants.count})".color(:green)

  print "generating frames................".color(:white)
  plants.each do |p|
    5.times do
      p.frames.create(name: (0...8).map{65.+(rand(26)).chr}.join)
    end
  end
  puts " Complete! (created #{Frame.count})".color(:green)

  print "generating cells.................".color(:white)
  Frame.all.each do |f|
    5.times do
      f.cells.create(status: [:errored, :active, :inactive].sample, uid: rand(1..100))
    end
  end
  puts " Complete! (created #{Cell.count})".color(:green)

  puts "generating reports...............".color(:white)
  

  count = 50; num = 0
  Cell.all.each_with_index do |c, modifier|
    week_epoc = (Time.now - 1.week.ago)
    number = 8.0

    count.times do |i|
      print "#{"\r" + "\e[0K"}#{num + 1}/#{Cell.count*count} reports created........".color(:white)
      time = (Time.now - ((week_epoc / 1000) + (i * (week_epoc / 1000)) ))
      ran = (number > 1.0) ? rand(number..(number + (modifier * 0.8))).round(5) : 0.0
      number = (number >= 8.0) ? 0.0 : (number + 0.5)
      c.reports.create(report_time: time, voltage: ran)
      num += 1
    end
  end
  puts " Complete! (created #{Report.count})".color(:green)

  puts "\n"
  puts "!!! Database Seed Status: #{'SUCCESS'.color(:green).bright} !!!".color(:cyan)
  puts "Completed in: #{(Time.now - t).round(2)} sec"
  puts "\n\n\n"

end


