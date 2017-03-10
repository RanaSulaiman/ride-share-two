require "csv"
require_relative "rating_error"
#require_relative "invalid_data"



module RideShare
  class Trip #RideShare::Trip

    attr_reader :id, :driver_id, :rider_id, :date, :rating

    def initialize(args_hash)
      @id = args_hash[:trip_id]
      @driver_id = args_hash[:driver_id]
      @rider_id = args_hash[:rider_id]
      @date = args_hash[:date]
      @rating = args_hash[:rating]

      raise RatingError.new "Rating range should be between (1-5)" if @rating.to_i < 1 || @rating.to_i > 5
    end

    def self.all
      # retrieve all trips from CSV files
      # returns list of all trip instances

      all_trips_array = []
      CSV.read("support/trips.csv", {:headers => true, :header_converters => :symbol}).each do |line|

        all_trips_array << RideShare::Trip.new(line)
      end
      return all_trips_array
    end

    def self.print_all
      find_driver_trips("17").each do |trip|
        puts "trip id: #{trip.id}, driver id: #{trip.driver_id}, date: #{trip.date}, rating: #{trip.rating}"
      end
    end

    def self.find_driver_trips(driver_id)
      #find the list of trip instances for a driver
      #returns list of trips instances.
      driver_trips = all.select {|trip| (trip.driver_id == driver_id) }
    end


    def self.find_rider_trips(rider_id)
      #find the list of trip instances for a rider
      #returs list of trip instances
      rider_trips = all.select {|trip| (trip.rider_id == rider_id) }
    end

    def retrieve_driver
      #retrieve the associated driver instance through driver ID for a specific trip

      # begin
        RideShare::Driver.find(@driver_id)
      #    raise InvalidData.new if RideShare::Driver.find(@driver_id).class != Array
      #
      # rescue InvalidData => exception
      #   puts "driver id is not in the database: #{exception.message}"
      # end
      # return RideShare::Driver.find(@driver_id)
    end

    def retrieve_rider
      #retrieve the associated rider instance through rider ID for a specific trip

      # begin
      RideShare::Rider.find(@rider_id)
    #   raise InvalidData.new if RideShare::Rider.find(@rider_id).class != Array
    # rescue InvalidData => exception
    #   puts "rider id is not in the database: #{exception.message}"
    # end
    # return RideShare::Rider.find(@rider_id)
    end

  end
end

#RideShare::Trip.print_all
