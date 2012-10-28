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
    Plant.create(name: "Singapore"),
    Plant.create(name: "USA"),
    Plant.create(name: "Europe")
  ]
  puts " Complete! (created #{plants.count})".color(:green)

  print "generating frames................".color(:white)
  plants.each do |p|
    5.times do
      p.frames.create(temperature: rand(1..100))
    end
  end
  puts " Complete! (created #{Frame.count})".color(:green)

  print "generating cells.................".color(:white)
  Frame.all.each do |f|
    5.times do
      f.cells.create(status: [:errored, :active, :inactive].sample)
    end
  end
  puts " Complete! (created #{Cell.count})".color(:green)

  puts "generating reports...............".color(:white)
  
  count = 50; num = 0
  Cell.all.each do |c|
    week_epoc = (Time.now - 1.week.ago)
    count.times do |i|
      print "#{"\r" + "\e[0K"}#{num + 1}/#{Cell.count*count} reports created........".color(:white)
      time = (Time.now - ((week_epoc / 1000) + (i * (week_epoc / 1000)) ))
      c.reports.create(report_time: time, voltage: rand(0.0..30.0).round(2))
      num += 1
    end
  end
  puts " Complete! (created #{Report.count})".color(:green)

  puts "\n"
  puts "!!! Database Seed Status: #{'SUCCESS'.color(:green).bright} !!!".color(:cyan)
  puts "Completed in: #{(Time.now - t).round(2)} sec"
  puts "\n\n\n"
end
