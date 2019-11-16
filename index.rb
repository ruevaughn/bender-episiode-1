# frozen_string_literal: true

# Welcome to Futurama!
module FuturamaLand
   # Benders new firmware to be compiled - the writer of this firmware assumes
    # bender is already self aware of Bender, and calling methods accordingly.
    # He hasn't taken this approach with modules before but is seeing how it goes
  module NewBenderFirmware
    # Mostly 'concepts', 'objects', and 'things' about the city Bender needs to know
    module CityLogicGates
      OBJECTS = { '$' => :suicide_booth, 'B' => :beer, 'I' => :inverter, 'T' => :teleporters }.freeze
      OBSTACLES = { '#' => :unbreakable, 'X' => :breakable }.freeze
      OPEN_SPACE = ' '
      BREAKABLE_OBJECT = OBSTACLES['X']
      UNBREAKABLE_OBJECT = OBSTACLES['#']
      SUICIDE_BOOTH = OBJECTS['$']
      BEER = OBJECTS['B']
      INVERTER = OBJECT['I']
      TELEPORER = OBJECT['T']

      def unbreakable_object(object)
        object == UNBREAKABLE_OBJECT
      end

      def breakable_object(object)
        @breaker_mode && (object == BREAKABLE_OBJECT)
      end
    end
    module CompassLogicGates

      CARDINAL_DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
      CARDINAL_ABBR = %w[N E S W].freeze
      NORTH = CARDINAL_DIRECTIONS[0].freeze
      EAST = CARDINAL_DIRECTIONS[1].freeze
      SOUTH = CARDINAL_DIRECTIONS[2].freeze
      WEST = CARDINAL_DIRECTIONS[3].freeze

      COMPASS_ADVICE = {
        NORTH => [:column_index, :up],
        EAST =>  [:row_index, :up],
        SOUTH => [:row_index, :down],
        WEST =>  [:column_index, :down]
      }.freeze

      DIRECTION_CHANGES = { 'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => WEST }.freeze

      STANDARD_DIRECTIONS = { 'SOUTH' => 'S', 'EAST' => 'E', 'NORTH' => 'N', 'WEST' => 'W' }.freeze
      # STANDARD_DIRECTIONS = { 'S' => SOUTH, 'E' => EAST, 'N' => NORTH, 'W' => WEST }.freeze
      STANDARD_DIRECTIONS_ABBR = %w[SOUTH EAST NORTH WEST]

      INVERTED_DIRECTIONS = { 'WEST' => 'W', 'NORTH' => 'N', 'EAST' => 'E', 'SOUTH' => 'S' }.freeze
      # INVERTED_DIRECTIONS = { 'W' => WEST, 'N' => NORTH, 'E' => EAST, 'S' => SOUTH }.freeze
      INVERTED_DIRECTIONS_ABBR = %w[WEST NORTH EAST SOUTH]

    end

    # These firmware updates are aware of the original 'Bender' prototype...
    # Not sure if I like this modular approach but i'm sticking with it
    # Since it gives it the 'adding on' feel which is described in the scenario
    module BenderProgrammableLogicFirmware
      def predict_direction
        if @direction
          direction = @direction
        elsif @inverted
          direction = INVERTED_DIRECTIONS.find { |d| @directions_tried.exclude?(d) }
        else
          direction = STANDARD_DIRECTIONS.find { |d| @directions_tried.exclude?(d) }
        end
        @directions_tried << direction
        direction
      end

      def predict_move(object)
        predict_bender_move(object)
        predict_bender_interaction(object)
      end

      def predict_bender_move(object)
        moved = false
        DIRECTION_CHANGES.each do |abbr, direction|
          if object == abbr
            moved = true
            @direction = direction
          end
        end
        # elsif @inverted
        #   INVERTED_DIRECTIONS.each do
        #   end

        # predict_move_direction(object)
        # @found_booth = true if object == SUICIDE_BOOTH
      end
    end
  end

  # All the firmware compiled
  module FirmwareUpdate
    include FuturamaLand::NewBenderFirmware::CompassLogicGates
    include FuturamaLand::NewBenderFirmware::CityLogicGates
    include FuturamaLand::NewBenderFirmware::BenderProgrammableLogicFirmware
  end

  # Bender - Beer, Women, Robots, Partying, Fry - These are just some of his favorite things
  #          on his Hard Drive. Unfortunately things have gotten sour  for the little guy and
  #          No one feels bad for him but himself. He's gotten to the point we have to intervene -
  #          Little does he know he's about to get a firmware update
  class Bender
    attr_accessor :location
    attr_accessor :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted
    attr_accessor :direction
    attr_accessor :map

    include FuturamaLand::FirmwareUpdate

    def initialize
      @location = {}
      @direction = 'SOUTH'
      @directions_tried = []
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

    def can_move_past_object?(object)
      can_move = false
      can_move = true unless unbreakable_object(object)
      can_move = true if breakable_object(object) 
      can_move
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

    def wander_around
      direction = predict_direction
      location = get_new_location(direction)
      object = object_at_location(location)
      if can_move_past_object?(object)
      else
        object = object_at_location(location)
        # predict_move(object) if can_move?(object)
        # directions ||= inverted ? INVERTED_DIRECTIONS : STANDARD_DIRECTIONS
        # directions.each do |direction_sym, _|
          # For each direction check if can move
          # For each direction check if can interact
          # For each direction check if teleporter
          # For each direction check if beer
      end
    end
  end

  # I'm the map i'm the map i'm the map!
  class CityMap
    attr_accessor :rows
    attr_accessor :bender

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

    # When smashing
    def update_map(location, symbol)
      @map[location[:row_index]][location[:column_index]] = symbol
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
  puts @bender.wander_around
end
