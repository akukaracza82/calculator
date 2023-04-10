require 'httparty'
require 'sqlite3'

def check_db(pickup, dropoff)
  begin
    db = SQLite3::Database.new "../pup/pcs.db"
    pickup_location = db.execute("SELECT lat, long FROM outs WHERE code ='#{pickup}'")[0];
    dropoff_location = db.execute("SELECT lat, long FROM outs WHERE code ='#{dropoff}'")[0]
    [ pickup_location, dropoff_location ]
  ensure
    db.close if db
  end
end

def calcDiffPeak(peak, offpeak)
  ((peak.to_f - offpeak) / offpeak * 100).round
end

def calcDiffNight(night, offpeak)
  ((offpeak.to_f - night) / offpeak * 100).round
end

def calcPercent(hash)
  peak = calcDiffPeak(hash[:peak], hash[:offpeak])
  night = calcDiffNight(hash[:night], hash[:offpeak])
  {peak: peak, night: night}
end

def create_times_array(res)
  times_of_day = {peak: 7, night: 4, offpeak: 12}
  times = {}
  job_distance = nil
  times_of_day.each do |key, val|
    url = "https://api.tomtom.com/routing/1/calculateRoute/#{res[0][0]}%2C#{res[0][1]}%3A#{res[1][0]}%2C#{res[1][1]}/json?departAt=2022-12-29T#{val}%3A30%3A00&routeType=fastest&avoid=unpavedRoads&key=uwbU08nKLNQTyNrOrrQs5SsRXtdm4CXM"
    response = HTTParty.get(url)
    a = JSON.parse(response.body)
    time = (a['routes'][0]['summary']['travelTimeInSeconds'] / 60).round(2)
    distance = (a['routes'][0]['summary']['lengthInMeters'] / 1600.0).round(1)
    puts "distance: #{distance}"
    times[key]=time
    job_distance == nil ? job_distance = distance : nil
  end
  [times, job_distance]
end

def calculate(job)
 res = check_db(job[0].upcase, job[1].upcase)
array = create_times_array(res)
p array
result = [job, calcPercent(array[0])]
result
end


jobs = [
['me15', 'br1'],
['tn1', 'w12'],
['tn23', 'tw6'],
['me13', 'lu1'],
['tn17', 'gu1'],
['tn14', 'sl5'],
['tn29', 'e5'],
['tw1', 'co1'],
['sl4', 'tn14']
]
percents = []
jobs.each do |job|
  result = calculate(job)
  p result
  percents.push [result[0], result[1][:peak], result[1][:night]]
end
percents.each do |p|
  p p
end
