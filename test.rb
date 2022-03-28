require 'active_record'
require 'sqlite3'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './pcs2.db'
  )

class Outs < ActiveRecord::Base
    CSV.foreach('./final.csv') do |row|
      find_or_create_by(code: "#{row[0]}") do |pc|
      pc.lat = row[1]
      pc.long = row[2]
    end
  end
end



# begin
#   # db = SQLite3::Database.open "pcs.db"
#   # db.execute "CREATE TABLE IF NOT EXISTS OutcodeShort(Id INTEGER PRIMARY KEY,
#   # Name TEXT, Lat TEXT, Long TEXT)"
#   CSV.foreach('out.csv') do |row|
#     find_or_create_by(code: "#{row[1]}") do |pc|
#     pc.Lat = row[2]
#     pc.Long = row[3]
#   end
# end

# rescue SQLite3::Exception => e
#   puts "Exception occurred"
#   puts e
# ensure
#   db.close if db
# end

# CREATE TABLE outs (
# 	id INTEGER PRIMARY KEY,
# 	code VARCHAR(8) NOT NULL,
# 	lat VARCHAR(15) NOT NULL,
# 	long VARCHAR(15) NOT NULL
# );