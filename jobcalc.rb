class JobQuote
  attr_accessor :rate, :distance, :time, :type

  def initialize(type, time, distance)
    @rate = Rate.new(type, time).check_rate([type, time])
    @distance = distance
    @time = time
    @type = type
  end

  def outcome
    puts "Quote for #{distance} miles in #{time}/#{type} -  #{calc_payment(distance, rate)} + #{calculate_holiday_pay} holiday pay = #{calc_payment(distance, rate) + calculate_holiday_pay}"
    puts "Fuel expense each way - #{calculate_fuel_expense(@distance)}"
    puts "Earning today before holiday pay and after fuel - #{(calc_payment(distance, rate) - calculate_fuel_expense(@distance)).truncate(2) }"
  end

  private

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

  def calculate_holiday_pay
    ((calc_payment(distance, rate) - distance * 0.45) * 0.127).truncate(2)
  end

  def calculate_fuel_expense(dist)
    (dist * 0.2).truncate(2)
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
  end

  puts 'enter a for select or b for select+'
  type = gets.chomp
  type_of_service = type == 'a' ? 'select' : 'select+'

  puts 'enter a for peak or b for offpeak'
  time = gets.chomp
  time_of_service = time == 'a' ? 'peak' : 'offpeak'

  puts 'enter distance'
  distance = gets.chomp.to_i


job = JobQuote.new(type_of_service, time_of_service, distance)
puts job.outcome
