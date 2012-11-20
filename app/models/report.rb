require 'time'

class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :cell

  field :report_time, type: Time, default: Time.now
  field :voltage, type: Float, default: 0.0  

  index({ report_time: 1 })
  index({ voltage:     1 })


end