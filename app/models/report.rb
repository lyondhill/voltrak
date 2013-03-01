require 'time'

class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :cell

  field :report_time, type: Time, default: Time.now
  field :voltage, type: Float, default: 0.0  

  index({ report_time: 1 })
  index({ voltage:     1 })



  class << self
    def to_csv
      CSV.generate do |csv|
        csv << %w(Frame Cell report_time voltage)
        Report.scoped.asc(:report_time).each do |report|
          csv << (cached_array(report.cell_id) + [report.report_time, report.voltage])
        end
      end
    end

    def cached_array(cell_id) 
      if h[cell_id]
        h[cell_id]
      else
        h[cell_id] = [Cell.find(cell_id).frame.name, Cell.find(cell_id).uid]
      end
    end


    def hash
      @h
    end

    def new_hash
      @h = {}
    end
    
  end


end