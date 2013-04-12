class Cell
  include Mongoid::Document
  
  STATUSES = [:errored, :active, :inactive]

  field :status, type: Symbol
  field :uid

  validates_inclusion_of :status, in: STATUSES

  has_many :reports
  has_many :five_minute_reports
  has_many :thirty_minute_reports
  has_many :hourly_reports

  belongs_to :frame, index: true

  ## methods ##
  class << self
    def find_by_slug(slug)
      find(slug)
    rescue
      where(uid: slug).first
    end

    def find_by_slug!(slug)
      find_by_slug(slug) || raise(Mongoid::Errors::DocumentNotFound.new(self, { slug: slug }))
    end
  end

  def json_reports(days = 1)
    MultiJson.dump([{'0' => reports_hash(days)}])
  end

  def reports_hash(days = 1)
    if days < 1
      data = reports.where(:report_time.gte => days.days.ago).only(:report_time, :voltage).asc(:report_time).map do |r|
        [r.report_time.to_i * 1000, r.voltage]
      end
    elsif 1 <= days and days <= 3
      data = five_minute_reports.where(:report_time.gte => days.days.ago).only(:report_time, :voltage).asc(:report_time).map do |r|
        [r.report_time.to_i * 1000, r.voltage]
      end
    elsif 3 < days and days <= 10
      data = thirty_minute_reports.where(:report_time.gte => days.days.ago).only(:report_time, :voltage).asc(:report_time).map do |r|
        [r.report_time.to_i * 1000, r.voltage]
      end
    else
      data = hourly_reports.where(:report_time.gte => days.days.ago).only(:report_time, :voltage).asc(:report_time).map do |r|
        [r.report_time.to_i * 1000, r.voltage]
      end
    end
    {label: self.uid.to_s, data: data}
  end

  def last_voltage
    @last ||= reports.asc(:report_time).last.voltage rescue 0.0
  end
  
end