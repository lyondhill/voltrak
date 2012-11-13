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

    def reduce_five_minute
      if last_report = FiveMinuteReport.asc(:report_time).last.try(:report_time)
        result = Report.where(:report_time.gte => (last_report + 3.minutes)).map_reduce(five_min_map, reduce).finalize(finalize).out(inline: 1)
      else
        result = Report.map_reduce(five_min_map, reduce).finalize(finalize).out(inline: 1)
      end
      result.each do |r|
        FiveMinuteReport.create(
          report_time: Time.parse(r['_id'].split('|').first), 
          cell_id: Moped::BSON::ObjectId.from_string(r['_id'].split('|').last), 
          voltage: r['value']['avg'])
      end
    end

    def reduce_hourly
      if last_report = HourlyReport.asc(:report_time).last.try(:report_time)
        result = Report.where(:report_time.gte => (last_report + 30.minutes)).map_reduce(hourly_map, reduce).finalize(finalize).out(inline: 1)
      else
        result = Report.map_reduce(hourly_map, reduce).finalize(finalize).out(inline: 1)
      end
      result.each do |r|
        HourlyReport.create(
          report_time: Time.parse(r['_id'].split('|').first), 
          cell_id: Moped::BSON::ObjectId.from_string(r['_id'].split('|').last), 
          voltage: r['value']['avg'])
      end
    end

    def hourly_map
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

    def five_min_map
      %Q{
        function() {
          var agg = {
            count: 1,
            sum: this.voltage
          };
          key = this.report_time
          key.setMinutes ((parseInt(key.getMinutes() / 15)) * 15);
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

  end

end