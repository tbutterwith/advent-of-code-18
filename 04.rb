guards = Hash.new
minutes = Hash.new
logs = Array.new

def make_new_minutes_array id, minutes
  minutes[id] = Array.new(60, 0)
end

class LogEntry
  def initialize log_def
    parse_log log_def
  end

  def parse_log log_def
    log = log_def.match(/\[(?<date>\d+-\d+-\d+\s\d+:(?<minute>\d+))\]\s(?<action>.+)/)
    @minute = log[:minute].to_i
    @action = log[:action]
  end

  def get_id
    guard_rgx = /Guard #(?<id>\d+)/
    match = @action.match guard_rgx
    return match[:id]
  end

  attr_accessor :minute, :action, :get_time, :get_action, :get_date
end

File.open("data/04.txt", "r") do |f|
  f.each_line do |line|
    logs.push line
  end
end

logs = logs.sort

log_entries = []
logs.each do |log_entry|
  log_entries.push LogEntry.new log_entry
end

i = 0
while i < log_entries.length do
  id = log_entries[i].get_id
  changed = false
  
  if minutes[id].nil? and !id.nil?
    make_new_minutes_array id, minutes
  end
  
  counter = 1
  while !changed do
    log = log_entries[i + counter]
    # Exit if null
    if log.nil?
      changed = true
      i += 1
      break
    end

    if log.action.start_with?('falls')
      # do nothing
    elsif log.action.start_with?('wakes')
      asleep = log_entries[i + counter -1].minute
      wake = log.minute
      guards[id] = (wake - asleep) + (guards[id].nil? ? 0 : guards[id])
      (asleep..wake-1).to_a.each do |minute|
        minutes[id][minute] += 1
      end
    else
      changed = true
      break
    end

    counter += 1
  end
  i += counter
end

# PART ONE
sleepiest_guard = guards.key(guards.values.max)
sleepiest_minute = minutes[sleepiest_guard].each_with_index.max

puts "Part One"
puts sleepiest_guard.to_i * (sleepiest_minute[1]).to_i


puts '--------------'

# PART TWO

max_minutes = 0
selected_guard = 0
selected_minute = 0

minutes.each do |id, val|
  max_vals = val.each_with_index.max
  if max_vals.first.to_i > max_minutes.to_i
    max_minutes = max_vals.first.to_i
    selected_guard = id.to_i
    selected_minute = max_vals.last.to_i
  end
end

puts "Part Two"
puts selected_guard * selected_minute