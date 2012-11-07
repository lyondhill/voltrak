class Frame
  include Mongoid::Document

  field :temperature, type: Integer
  field :name

  has_many :cells
  belongs_to :plant

  # fnordmetric
  # def trigger_view_event
  #   FNORD_METRIC.event(attributes.merge(_type: :frame_temp))
  # end
  
  def json_reports(days = 1)
    arr = cells.each_with_index { |cell, index| {index.to_s => cell.reports_hash(days)} }
    MultiJson.dump(arr)
  end

end