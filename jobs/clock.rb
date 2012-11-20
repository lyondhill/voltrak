require 'clockwork'
require 'qu-redis'
include Clockwork

class QuarterlyReport
end

class HourlyReport
end

every(15.minutes, 'quarterly.aggrigate') { Qu.enqueue QuarterlyReport }
every(1.hour, 'hourly.aggrigate') { Qu.enqueue HourlyReport }
