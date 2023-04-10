require 'csv'
require 'httparty'
require 'uk_postcode'
require 'sqlite3'
require 'byebug'

class JobQuote
  attr_accessor :rate, :rate2, :distance, :time, :type

  def initialize
    # (type, time, distance)
    @type = type_from_user
    @time = time_from_user
    @distance = get_distance_from_tomtom(pickup_from_user, dropoff_from_user)
    @rate = Rate.new(type, time).check_rate([type, time])
    @rate2 = Rate2.new(type, time).check_rate([type, time])
  end

  def outcome
    puts "Quote for holiday pay = OLD DEAL #{calculate_holiday_pay(rate).truncate(2)}, NEW DEAL #{calculate_holiday_pay(rate2).truncate(2)}"
    puts "Fuel expense each way - #{calculate_fuel_expense(@distance)}"
    puts "Earning today before holiday pay - OLD DEAL - #{(calc_payment(distance, rate)).truncate(2) }, NEW DEAL - #{(calc_payment(distance, rate2)).truncate(2) }"
  end

  private

  KODY = {
    'HEATHROW' => 'TW6 1',
    'PANCRAS' => 'N1 9',
    'ITV' => 'W12 7',
    'STANSTED'=> 'CM24 1',
    'GATWICK' => 'RH6 0',
    'LUTON' => 'LU2 9',
    'CITY AIRPORT' => 'E16 2',
    'DOM' => 'ME15 6'
  }

  def calc_payment(distance, rate)
    case
      when distance <= 2
        rate[0]
      when distance <= 4 && distance > 2
        (rate[0] + ( distance - 2) * rate[1]).truncate(2)
      when distance <= 7 && distance > 4
        (rate[0] + 2 * rate[1] + ( distance - 4 ) * rate[2] ).truncate(2)
      when distance <= 30 && distance > 7
        (rate[0] + 2 * rate[1] + 3 * rate[2] + ( distance - 7 ) * rate[3]).truncate(2)
      when distance <= 50 && distance > 30
        (rate[0] + 2 * rate[1] + 3 * rate[2] + 23 * rate[3] + ( distance - 30 ) * rate[4]).truncate(2)
      when distance > 50
        (rate[0] + 2 * rate[1] + 3 * rate[2] + 23 * rate[3] + 20 * rate[4] + ( distance - 50 ) * rate[5]).truncate(2)
    end
  end

  def calculate_holiday_pay(rate)
    ((calc_payment(distance, rate) - distance * 0.45) * 0.127).truncate(2)
  end

  def calculate_fuel_expense(dist)
    diesel = (dist * 0.15).truncate(2)
    ev = (dist *  0.07).truncate(2)
    "diesel: £#{diesel}, ev: £#{ev}"
  end

  def check_in_kody(val)
    if (KODY.keys.include? val.upcase) || (KODY.keys.include? val.upcase.to_sym)
      KODY[val.upcase]
    else
      UKPostcode.parse(val).to_s
    end
  end

  def type_from_user
    puts 'enter a for select or b for select+'
    type = gets.chomp
    type_of_service = type == 'a' ? 'select' : 'select+'
  end

  def time_from_user
    puts 'enter a for peak or b for offpeak'
    time = gets.chomp
    time_of_service = time == 'a' ? 'peak' : 'offpeak'
  end

  def pickup_from_user
    puts 'enter pickup postcode'
    user_pickup = gets.chomp
    pickup_loc = check_in_kody(user_pickup)
    puts pickup_loc
    pickup_loc
  end

  def dropoff_from_user
    puts 'enter a dropoff postcode'
    user_dropoff = gets.chomp
    dropoff_loc = check_in_kody(user_dropoff)
    puts dropoff_loc
    dropoff_loc
  end

  def check_db(pickup, dropoff)
    begin
      db = SQLite3::Database.new "../invoiceScanner/pcs.db"
      pickup_location = db.execute("SELECT lat, long FROM postcodes WHERE code like '#{check_in_kody(pickup)}%'")[0];
      dropoff_location = db.execute("SELECT lat, long FROM postcodes WHERE code like '#{check_in_kody(dropoff)}%'")[0]
      [ pickup_location, dropoff_location ]
    ensure
      db.close if db
    end
  end

  def get_distance_from_tomtom(pickup, dropoff)
    coords = check_db(pickup, dropoff)
    response = HTTParty.get("https://api.tomtom.com/routing/1/calculateRoute/#{coords[0][0]}%2C#{coords[0][1]}%3A#{coords[1][0]}%2C#{coords[1][1]}/json?routeType=shortest&avoid=unpavedRoads&key=uwbU08nKLNQTyNrOrrQs5SsRXtdm4CXM")
    a = JSON.parse(response.body)
    (a['routes'][0]['summary']['lengthInMeters'] / 1600.0).round(2)
  end

  Rate = Struct.new(:type, :time) do
    SPEAK = [7, 2.5, 1.75, 1.65, 1.4, 1.5]
    SOFFPEAK = [6.25, 1.75, 1.65, 1.6, 1.1, 1.25]
    PLUSPEAK = [9.1, 3.25, 2.3, 2.15, 1.65, 1.65]
    PLUSOFFPEAK = [8.1, 2.3, 2.15, 2.05, 1.4, 1.4]

    def check_rate(args)
      rate = SPEAK if args == ['select', 'peak']
      rate = SOFFPEAK if args == ['select', 'offpeak']
      rate = PLUSPEAK if args == ['select+', 'peak']
      rate = PLUSOFFPEAK if args == ['select+', 'offpeak']
      rate
    end
  end

  Rate2 = Struct.new(:type, :time) do
    SPEAK2 = [7.5, 2.5, 1.9, 1.75, 1.3, 1.3]
    SOFFPEAK2 = [6.75, 2, 1.75, 1.65, 1.3, 1.3]
    PLUSPEAK2 = [9.5, 3.25, 2.35, 2.05, 1.5, 1.5]
    PLUSOFFPEAK2 = [8.5, 2.4, 2.2, 2, 1.5, 1.5]

    def check_rate(args)
      rate = SPEAK2 if args == ['select', 'peak']
      rate = SOFFPEAK2 if args == ['select', 'offpeak']
      rate = PLUSPEAK2 if args == ['select+', 'peak']
      rate = PLUSOFFPEAK2 if args == ['select+', 'offpeak']
      rate
    end
  end
end

JobQuote.new.outcome
