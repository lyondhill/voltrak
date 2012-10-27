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
        puts " #{o.errors.pretty_inspect}".color(:yellow)
        exit 1
      else
        puts " Complete!".color(:green)
      end
    end
  end

  require 'highline/import'
  require 'csv'
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
  puts "\n\n\n--- Begin Seeding Database ---".color(:cyan).underline

  # seed stuff here

  puts "\n!!! Database Seed Status: #{'SUCCESS'.color(:green).bright} !!!".color(:cyan)
end
