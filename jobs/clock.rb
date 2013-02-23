require 'clockwork'
require 'qu-redis'
include Clockwork

class FiveMinuteReport
end

class ThirtyMinuteReport
end

class HourlyReport
end

every(5.minutes, 'five.minute.aggrigate') { Qu.enqueue FiveMinuteReport }
every(30.minutes, 'thirty.minute.aggrigate') { Qu.enqueue ThirtyMinuteReport }
every(1.hour, 'hourly.aggrigate') { Qu.enqueue HourlyReport }
