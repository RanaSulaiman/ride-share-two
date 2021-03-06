require_relative 'spec_helper'
require_relative "../ride_share"
require "csv"
require "pry"

describe "Driver class" do
  describe "Driver#initialize" do
    let(:jack) { RideShare::Driver.new(name: 'Jack', driver_id: "2", vin: "WBWSS52P9NEYLVDE9" )}
    it "Takes an ID , name and vin" do

      jack.must_respond_to :id
      jack.id.must_equal "2"

      jack.must_respond_to :name
      jack.name.must_equal "Jack"

      jack.must_respond_to :vin
      jack.vin.must_equal "WBWSS52P9NEYLVDE9"
    end

    it "Raises InvalidVehicleNumber if vin != 17" do
      proc { RideShare::Driver.new(name: 'Jack', driver_id: "2", vin: "WBWSS52")}.must_output "invalid Vehilcle Numberxxx\n"
      #binding.pry
      #proc { RideShare::Driver.new(name: 'Jack', driver_id: "2", vin: "WBWSS52P9NEYL")}.must_raise InvalidVehicleNumber
    end
  end

  describe "Driver#all" do
    let(:all_drivers) { RideShare::Driver.all}

    it "Returns an array of all driver instances" do
      all_drivers.must_be_kind_of Array
    end

    it 'Everything in the array is an instane of Ride_share::Driver class' do
      all_drivers.each do |driver_instance|
        driver_instance.must_be_instance_of RideShare::Driver
      end
    end

    it "The number of driver records = 100, records in csv file" do
      all_drivers.length.must_equal 100
    end

    it "The ID and name and vihecle identification of the first driver match what's in the CSV file" do
      #1 Bernardo Prosacco	WBWSS52P9NEYLVDE9
      driver_id = "1"
      name = "Bernardo Prosacco"
      vin = "WBWSS52P9NEYLVDE9"

      all_drivers.first.id.must_equal driver_id
      all_drivers.first.name.must_equal name
      all_drivers.first.vin.must_equal vin
    end

    it "The ID and name and vihecle identification of the last driver match what's in the CSV file" do
      # 100,Minnie Dach,XF9Z0ST7X18WD41HT
      driver_id = "100"
      name = "Minnie Dach"
      vin = "XF9Z0ST7X18WD41HT"

      all_drivers.last.id.must_equal driver_id
      all_drivers.last.name.must_equal name
      all_drivers.last.vin.must_equal vin
    end
  end
  describe "Driver#find" do
    it "Check that class have a find method" do
      RideShare::Driver.must_respond_to :find
    end

    it "Returns a driver instance with correct data " do
      # 57,Fermin Jakubowski,1C9YKRAL923SACAZM
      driver_id = "57"
      driver = RideShare::Driver.find(driver_id)
      driver.must_be_instance_of RideShare::Driver
      driver.name.must_equal 'Fermin Jakubowski'
      driver.vin.must_equal '1C9YKRAL923SACAZM'
    end
    it "Returns nil when driver id not in the database" do
      driver_id = "9999"
      RideShare::Driver.find(driver_id).must_equal nil
    end

    it "Returns nil when driver id is not string type" do
      driver_id = 99292
      RideShare::Driver.find(driver_id).must_equal nil
    end
  end

  describe "Driver#retrieve_trips" do
    it "The lenfth of trips list is the same count as in csv file" do
      specific_driver_id = "13"
      trips = RideShare::Trip.find_driver_trips(specific_driver_id)
      trips.length.must_equal 7
    end

    it "Returns the list of trip instances for a specific driver" do

      specific_driver_id = "13"
      trips = RideShare::Trip.find_driver_trips(specific_driver_id)
      trips.first.must_be_instance_of RideShare::Trip
    end
  end

  describe "Driver#calculate_rating" do
    before do
      @driver_13 =  RideShare::Driver.find("13")
    end

    it "Calculates the average trips rating for a specific driver" do
    # driver: 13	Mr. Delbert Gleason	XF9HBFH148FLD41K8

      specific_driver_id = "13"
      @driver_13.calculate_avg_rating.must_be_within_epsilon (29.0/7),0.01
    end

    it "The average trip rating is a float" do
    # driver: 13	Mr. Delbert Gleason	XF9HBFH148FLD41K8
      specific_driver_id = "13"
      @driver_13.calculate_avg_rating.must_be_instance_of Float
    end
  end
end
