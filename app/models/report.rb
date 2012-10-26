class Report
  include Mongoid::Document

  belongs_to :cell

  field :voltage, type: Float, default: 0.0  
  
end