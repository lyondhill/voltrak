class Cell
  include Mongoid::Document
  
  STATUSES = [:errored, :active, :inactive]

  field :status, type: Symbol
  field :uid

  validates_inclusion_of :status, in: STATUSES

  has_many :reports
  belongs_to :frame

  def json_report(days = 1)
    data = reports.where(:report_time.gte => days.days.ago).map do |r|
      [r.report_time.to_i, r.voltage]
    end
    MultiJson.dump({label: self.uid, data: data})
  end
  
end