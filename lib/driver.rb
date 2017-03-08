
require "csv"

class Ride_Share::Driver

  attr_reader :id, :name, :vin

  def initialize(args_hash)
    #csv header: driver_id, name, vin
    @id = args_hash[:driver_id]
    @name = args_hash[:name]
    @vin = args_hash[:vin]

  end

  def self.all
    all_drivers_array = []
    CSV.read("support/drivers.csv", {:headers => true, :header_converters => :symbol}).each do |line|
      all_drivers_array << Ride_Share::Driver.new(line)
    end
    return all_drivers_array
  end

  def self.find(driver_id)
    all.each do |driver|
      return driver if driver.id == driver_id
    end
    raise ArgumentError.new "invalid driver id"
  end

  def self.print_all
    all.each do |driver|
      puts "id: #{driver.id}, name: #{driver.name}, vin: #{driver.vin}"
    end
  end

  def retrieve_trips
    Trip.find_driver_trips(@id)
  end

  def calculate_rating
    #access rating from trips instances
    #calculate average
    #returns avaerage rating

  end


end

# Driver.print_all
