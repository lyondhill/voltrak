class Cell
  include Mongoid::Document
  
  STATUSES = [:errored, :active, :inactive]

  field :status, type: Symbol
  field :uid

  validates_inclusion_of :status, in: STATUSES

  has_many :reports
  has_many :hourly_reports
  has_many :five_minute_reports
  belongs_to :frame

  def json_reports(days = 1)
    MultiJson.dump([{'0' => reports_hash(days)}])
  end

  def reports_hash(days = 1)
    data = five_minute_reports.where(:report_time.gte => days.days.ago, :voltage.gt => 0.5).only(:report_time, :voltage).asc(:report_time).map do |r|
      [r.report_time.to_i, r.voltage]
    end
    {label: self.uid.to_s, data: data}
  end

  def last_voltage
    reports.asc(:report_time).last.voltage rescue 0.0
  end
  
end