require 'time'

class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :cell, index: true

  field :report_time, type: Time, default: Time.now
  field :voltage, type: Float, default: 0.0  

  index({ report_time: 1 })
  index({ voltage:     1 })

  class << self
    def to_csv
      new_hash
      CSV.generate do |csv|
        csv << %w(Frame Cell report_time voltage)
        Report.scoped.asc(:report_time).each do |report|
          csv << (cached_array(report.cell_id) + [report.report_time, report.voltage])
        end
      end
    end

    def cached_array(cell_id) 
      if hash[cell_id]
        hash[cell_id]
      else
        cell = Cell.find(cell_id) rescue nil
        if cell
          hash[cell_id] = [cell.frame.name, cell.uid]
        else
          ['unknown', '1']
        end
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