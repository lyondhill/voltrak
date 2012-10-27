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

  ###  -- BEGIN SEEDING DATABASE --
  puts "\n\n\n"
  puts "--- Begin Seeding Database ---".color(:cyan).underline
  puts "\n"

  print "generating plants................".color(:white)
  p = Plant.create(name: "Singapore")
  puts " Complete!".color(:green)

  print "generating frames................".color(:white)
  Plant.all.each do |plant|
    rand(2..5).times do
      plant.frames.create(temperature: rand(1..100))
      plant.frames.create(temperature: rand(1..100))
    end
  end
  puts " Complete!".color(:green)

  print "generating cells.................".color(:white)
  Frame.all.each do |frame|
    rand(1..5).times do
      frame.cells.create(status: [:errored, :active, :inactive][rand(0..2)])
    end
  end
  puts " Complete!".color(:green)

  print "generating reports...............".color(:white)
  Cell.all.each do |cell|
    week_epoc = (Time.now - 1.week.ago)
    1000.times do |num|
      time = (Time.now - ((week_epoc / 1000) + (num * (week_epoc / 1000)) ))
      cell.reports.create(report_time: time, voltage: rand(0.0..30.0).round(2))
    end
  end
  puts " Complete!".color(:green)

  puts "\n"
  puts "!!! Database Seed Status: #{'SUCCESS'.color(:green).bright} !!! ".color(:cyan)
  puts "\n\n\n"
end
