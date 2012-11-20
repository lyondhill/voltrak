class QuarterlyReport
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :cell

  field :report_time, type: Time, default: Time.now
  field :voltage, type: Float, default: 0.0  

  index({ report_time: 1 })
  index({ voltage:     1 })


  class << self

    def perform
      display 'perfomring 15 min'
      if last_report = QuarterlyReport.asc(:report_time).last.try(:report_time)
        display 'last aggrogate: ' + last_report.to_s
        result = Report.where(:report_time.gte => (last_report + 8.minutes)).map_reduce(map, reduce).finalize(finalize).out(inline: 1)
      else
        display 'Never been done before. This could take a bit.'
        result = Report.map_reduce(map, reduce).finalize(finalize).out(inline: 1)
      end
      display "results: #{result.count}"
      display "building new records"
      result.each do |r|
        rr = r['_id'].split('|')
        QuarterlyReport.create(
          report_time: Time.parse(rr.first), 
          cell_id: Moped::BSON::ObjectId.from_string(rr.last), 
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
    
    def display(msg)
      puts "[#{Time.now}][QuarterlyReport] - #{msg}"
    end

  end

end