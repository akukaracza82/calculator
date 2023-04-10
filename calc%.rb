# a = {peak: 53, night: 40, offpeak: 45}

# def calcDiffPeak(peak, offpeak)
#   ((peak.to_f - offpeak) / offpeak * 100).round
# end

# def calcDiffNight(night, offpeak)
#   ((offpeak.to_f - night) / offpeak * 100).round
# end

# def calcPercent(hash)
#   peak = calcDiffPeak(hash[:peak], hash[:offpeak])
#   night = calcDiffNight(hash[:night], hash[:offpeak])
#   {peak: peak, night: night}
# end

# p calcPercent a

# p calcDiff a[:peak], a[:offpeak]
# p a[:peak]
# p a[:offpeak]

reqs = ['SL', 'TW', 'W', 'N', 'SW', 'SE', 'UB', 'E', 'RG', 'SL', 'HP', 'GU', 'RH', 'WC', 'OX', 'MK', 'LU', 'AL', 'SG', 'CM']
command = ""
reqs.each do |r|
  command << " off like '#{r}%' or"
end
# p command

req2 = ['ME', 'TN', 'CT', 'RH', 'DA', 'BR']

command = ""
req2.each do |r|
  command << " up like '#{r}%' or"
end
p command