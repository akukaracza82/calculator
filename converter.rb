require 'active_record'
require 'sqlite3'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: '../invoiceScanner/pcs.db'
  )

class Codes < ActiveRecord::Base
    CSV.foreach('./ukpostcodes.csv') do |row|
      find_or_create_by(code: "#{row[1]}") do |pc|
      pc.lat = row[2]
      pc.long = row[3]
    end
  end
end