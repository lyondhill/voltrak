class HourlyReport
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :cell, index: true

  field :report_time, type: Time, default: Time.now
  field :voltage, type: Float, default: 0.0  

  index({ report_time: 1 })
  index({ voltage:     1 })

  class << self

    def perform
      display 'performing 60 min'
      if last_report = HourlyReport.asc(:report_time).last.try(:report_time)
        display 'last aggrogate: ' + last_report.to_s
        result = FiveMinuteReport.where(:report_time.gte => (last_report + 30.minutes)).map_reduce(map, reduce).finalize(finalize).out(inline: 1)
      else
        display 'Never been done before. This could take a bit.'
        result = FiveMinuteReport.map_reduce(map, reduce).finalize(finalize).out(inline: 1)
      end
      display "results: #{result.count}"
      display "building new records"
      result.each do |r|
        result = r['_id'].split('|')
        HourlyReport.create(
          report_time: Time.parse(result.first), 
          cell_id: Moped::BSON::ObjectId.from_string(result.last), 
          voltage: r['value']['avg'])
      end
      display 'done!'
    rescue => e
      display 'ERROR: ' + e.message
      e.backtrace.each {|line| display line}
    end

    def map
      %Q{
        function() {
          var agg = {
            count: 1,
            sum: this.voltage
          };
          key = this.report_time
          key.setMinutes (this.report_time.getMinutes() + 30);
          key.setMinutes (0);
          key.setSeconds (0);
          emit(key + '|' + this.cell_id, agg);
        }
      }      
    end

    def reduce
      %Q{
        function(key, values) {
          var agg = { count: 0, max: null, min: null, sum: 0 };
          values.forEach(function(val) {
            if (val.sum !== null) {
              agg.sum += val.sum;
            }
            agg.count += val.count;
          });
          return agg;
        }
      }
    end

    def finalize
      %Q{
        function(key, agg) {
          agg.avg = agg.sum / agg.count;
          return agg;
        }
      }
    end

    def display(msg)
      puts "[#{Time.now}][HourlyReport] - #{msg}"
    end

  end


end