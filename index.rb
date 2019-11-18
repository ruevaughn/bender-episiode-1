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
      INVERTER = OBJECTS['I']
      TELEPORER = OBJECTS['T']

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
        EAST => [:row_index, :up],
        SOUTH => [:column_index, :down],
        WEST => [:row_index, :down]
      }.freeze

      PATH_MODIFIER_CHANGES = { 'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => WEST }.freeze

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
        else
          directions = get_directions
          direction = directions.find { |d| !@directions_tried.include?(d) }
        end
        @directions_tried << direction
        direction = 'LOOP' if @directions_tried.size > 4
          
        direction
      end

      def get_directions
        @inverted ? CompassLogicGates::INVERTED_DIRECTIONS : CompassLogicGates::STANDARD_DIRECTIONS
      end


      def predict_move(object)
        predict_bender_move(object)
        predict_bender_interaction(object)
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
    attr_accessor :directions_tried
    attr_accessor :direction_object
    attr_accessor :map

    include FuturamaLand::FirmwareUpdate

    def initialize
      @location = {}
      @direction = 'SOUTH'
      @directions_tried = []
      @currrent_object = nil
      @found_booth = false
      @breaker_mode = false
      @teleport = false
    end

    def new_location
      row_or_column, new_direction = COMPASS_ADVICE[@current_direction]
      current_location = @location
      if new_direction == :up
        current_location[row_or_column] += 1
      elsif new_direction == :down
        current_location[row_or_column] -= 1
      end
      current_location
    end

    def can_move_to_object?
      can_move = false
      can_move = false if unbreakable_object(@current_object)
      can_move = true if breakable_object(@current_object)
      can_move
    end

    def move_to_object
      case @current_object
      when /(N|E|S|W)/
        handle_path_modifier
      when /B/i
        handle_bender_rationalization
      when /I/i
        handle_bender_inverted
      when /T/i
        handle_bender_teleport_mode
      when /X/
        handle_bender_smashin
      when '$'
        handle_bender_found_suicide_booth
      else
        STDERR.puts "Unhandled move_to_object #{@current_object}"
      end
    end

    def wander_around
      @current_direction = predict_direction
      @current_location = new_location
      @current_object = @map.object_at_location(@current_location)
      if @current_direction == 'LOOP'
        cleanup_state
        'LOOP'
      elsif can_move_to_object?
        move_to_object
        move_bender
        cleanup_state
        @current_direction
      else
        @direction = predict_direction
        wander_around
      end
    end

    private

    def move_bender
      if @teleport
        @location = @map.get_teleport_location(@current_location)
      else
        @location = @current_location
      end
      @map.mark_bender_on_map(@location)
    end

    def handle_path_modifier
      @direction = PATH_MODIFIER_CHANGES[@current_object]
    end

    def handle_bender_rationalization
      @breaker_mode = true
    end

    def handle_bender_smashin
      @map.bender_smash_obstacle(@current_location)
    end

    def handle_bender_inverted
      @inverted = true
    end

    def handle_bender_teleport_mode
      @teleport = true
    end

    def handle_bender_found_suicide_booth
      @found_booth = true
    end

    def cleanup_state
      @directions_tried = []
      @current_object = nil
      @found_booth = false
      @breaker_mode = false
      @teleport = false
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

    def get_teleport_location(current_location)
      location = nil
      @rows.each_with_index do |row, row_index|
        column_index = row.index('T')
        if column_index
          found_location = { row_index: row_index, column_index: column_index }
          location = found_location unless current_location == found_location
        end
        break if location
      end
      location
    end

    def object_at_location(location)
      @rows[location[:row_index]][location[:column_index]]
    end

    def mark_bender_on_map(location)
      @bender.location = location
    end

    def bender_smash_obstacle(current_location)
      update_map(current_location, ' ')
    end

    def update_map(location, symbol)
      @map[location[:row_index]][location[:column_index]] = symbol
    end
  end
end

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(' ').collect { |x| x.to_i }
@bender = FuturamaLand::Bender.new
@map = FuturamaLand::CityMap.new(bender: @bender)
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
