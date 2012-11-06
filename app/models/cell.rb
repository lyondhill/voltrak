class Cell
  include Mongoid::Document
  
  STATUSES = [:errored, :active, :inactive]

  field :status, type: Symbol
  field :uid

  validates_inclusion_of :status, in: STATUSES

  has_many :reports
  belongs_to :frame

  def report_json(days = 1)
    data = reports.where(:report_time.gte days.days.ago).map do |report|
      [report.report_time, report.voltage]
    end
    MultiJson.dump({label: cell.uid, data: data})
  end
  
end