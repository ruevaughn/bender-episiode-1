# frozen_string_literal: true

module FuturamaLand
  module NewBenderFirmware
    module CompassLogic
      COMPASS_ADVICE = {
        north: [:column_index, :up],
        east: [:row_index, :up],
        south: [:row_index, :down],
        west: [:column_index, :down]
      }.freeze

      CARDINAL_DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
      CARDINAL_ABBR = %w[N E S W].freeze
      NORTH = CARDINAL_DIRECTIONS[0].freeze
      EAST = CARDINAL_DIRECTIONS[1].freeze
      SOUTH = CARDINAL_DIRECTIONS[2].freeze
      WEST = CARDINAL_DIRECTIONS[3].freeze

      DIRECTION_CHANGES = { 'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => WEST }.freeze

      STANDARD_DIRECTIONS = { south: SOUTH, east: EAST, north: NORTH, west: WEST }.freeze
      INVERTED_DIRECTIONS = { west: WEST, north: NORTH, east: EAST, south: SOUTH }.freeze
    end

    # These firmware updates are aware of the original 'Bender' prototype...
    module BenderProgrammableLogicFirmware
      def predict_move(object)
        
          predict_bender_move(object) 
          predict_bender_interaction(object)
        end
      end


      def predict_bender_move(object)
        moved = false
        if CARDINAL_ABBR.include?(object)
          DIRECTION_CHANGES.each do |abbr, direction|
            if object == abbr
              moved = true
              @direction = direction 
            end
          end
        elsif @inverted
          INVERTED_DIRECTIONS.each do
        end

        predict_move_direction(object)
        @found_booth = true if object == SUICIDE_BOOTH
      end



      def predict_move_direction(object)

        direction = @direction
        direction ||= 
      end
    end
  end

  # All the firmware compiled
  module Firmware
    include FuturamaLand::NewBenderFirmware::CompassLogic
    include FuturamaLand::NewBenderFirmware::BenderProgrammableLogicFirmware
  end

  # Bender - Beer, Women, and Fry are the only things on his hard drive. 
  #          Little does he know he's about to get a firmware update
  class Bender
    attr_accessor :location
    attr_accessor :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted
    attr_accessor :direction
    attr_accessor :map

    include FuturamaLand::Firmware

    def initialize
      @location = {}
      @direction = nil
      @found_booth = false
      @breaker_mode = false
    end

    def get_new_location(direction)
      row_or_column, new_direction = COMPASS_ADVICE[direction]
      if new_direction == :up
        new_location = @location
        new_location[row_or_column] += 1
      elsif new_direction == :down
        new_location = @location
        new_location[row_or_column] -= 1
      end
      new_location
    end

    def can_move?(object)
      if object == OPEN_SPACE
        true
      elsif CARDINAL_ABBR.include?(object)
        true
      elsif object == SUICIDE_BOOTH
      else
        false
      end
    end

    def can_interact?(object)
      if @breaker_mode && (object == BREAKABLE_OBJECT)
        true
      elsif object == TELEPORTER
        true
      elsif object == BEER
        true
      elsif object == INVERTER
      true
      else
      false
      end
    end

    def look_around
      if @direction
      unless @direction 
        predict_move(object) if can_move?(object)
        directions ||= inverted ? INVERTED_DIRECTIONS : STANDARD_DIRECTIONS
        directions.each do |direction_sym, _|
        location_to_check = get_new_location(direction_sym)
        object = @map.object_at_location(location_to_check)
          # For each direction check if can move
          # For each direction check if can interact
          # For each direction check if teleporter
          # For each direction check if beer
        end
      end
    end
  end

  module City
    module Decapod
      OBJECTS = { '$' => :suicide_booth, 'B' => :beer, 'I' => :inverter, 'T' => :teleporters }.freeze
      OBSTACLES = { '#' => :unbreakable, 'X' => :breakable }.freeze
      OPEN_SPACE = ' '
      BREAKABLE_OBJECT = OBSTACLES['X']
      UNBREAKABLE_OBJECT = OBSTACLES['#']
      SUICIDE_BOOTH = OBJECTS['$']
      BEER = OBJECTS['B']
      INVERTER = OBJECT['I']
      TELEPORER = OBJECT['T']
    end

    # I'm the map i'm the map i'm the map!
    class Map
      attr_accessor :rows
      attr_accessor :bender

      include City::Decapod

      def initialize(attrs = {})
        @rows = []
        @bender = attrs[:bender]
      end

      def upload_to_map(row)
        @rows << row.split('')
      end

      def locate_bender
        @rows.each_with_index do |row, row_index|
          column_index = row.index('@')
          if column_index
            location = { row_index: row_index, column_index: column_index }
            mark_bender_on_map(location)
          end
          break if column_index
        end
      end

      def object_at_location(location)
        @rows[location[:row_index]][location[:column_index]]
      end

      private

      def mark_bender_on_map(location)
        @bender.location = location
      end

      def check_column(location)
        @rows[location[:row_index]][location[:column_index]]
      end

      def update_map(location, symbol)
        @map[location[:row_index]][location[:column_index]] = symbol
      end
    end
  end
end

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect { |x| x.to_i }
@bender = FuturamaLand::Bender.new
@map = FuturamaLand::City::Map.new(bender: @bender)
@bender.map = @map
l.times do
  row = gets.chomp
  @map.upload_to_map(row)
end

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."
@map.locate_bender
while @bender.found_booth == false
  puts @bender.look_around
end
