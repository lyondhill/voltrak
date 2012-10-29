require 'fnordmetric'

FnordMetric.namespace :something do
  hide_active_users

  toplist_gauge :frames_temp, title: 'Frames Temperature'

  distribution_gauge :frames_temp_range, title: 'Frames Temperature Ranges',
    value_ranges: [0..25, 25..50, 50..75, 75..100]

  gauge :temp_change_per_sec, tick: 1.second
  widget 'Temperatures',
    title: 'Change per second',
    type: :timeline,
    whidth: 100,
    gauges: :temp_change_per_sec,
    include_current: true,
    autoupdate:1

  event :frame_temp do
    observe :frames_temp, data[:temperature]
    observe :frames_temp_range, data[:temperature]
    incr :temp_change_per_sec
  end
end

FnordMetric::Web.new(port: 4242)
FnordMetric::Worker.new
FnordMetric.run