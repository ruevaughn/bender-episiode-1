# frozen_string_literal: true

# Welcome to Futurama!
module FuturamaLand
  # Benders new firmware to be compiled - the writer of this firmware assumes
  # bender is already self aware of Bender, and calling methods accordingly.
  # He hasn't taken this approach with modules before but is seeing how it goes
  module NewBenderFirmware
    module CompassLogicGates
      CARDINAL_DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
      NORTH = CARDINAL_DIRECTIONS[0].freeze
      EAST = CARDINAL_DIRECTIONS[1].freeze
      SOUTH = CARDINAL_DIRECTIONS[2].freeze
      WEST = CARDINAL_DIRECTIONS[3].freeze

      COMPASS_ADVICE = {
        NORTH => [:row_index, :down],
        EAST => [:column_index, :up],
        SOUTH => [:row_index, :up],
        WEST => [:column_index, :down]
      }.freeze

      PATH_MODIFIER_CHANGES = { 'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => WEST }.freeze

      STANDARD_DIRECTIONS = { 'SOUTH' => 'S', 'EAST' => 'E', 'NORTH' => 'N', 'WEST' => 'W' }.freeze
      # STANDARD_DIRECTIONS = { 'S' => SOUTH, 'E' => EAST, 'N' => NORTH, 'W' => WEST }.freeze
      STANDARD_DIRECTIONS_ABBR = %w[SOUTH EAST NORTH WEST].freeze

      INVERTED_DIRECTIONS = { 'WEST' => 'W', 'NORTH' => 'N', 'EAST' => 'E', 'SOUTH' => 'S' }.freeze
      # INVERTED_DIRECTIONS = { 'W' => WEST, 'N' => NORTH, 'E' => EAST, 'S' => SOUTH }.freeze
      INVERTED_DIRECTIONS_ABBR = %w[WEST NORTH EAST SOUTH].freeze
    end

    # These firmware updates are aware of the original 'Bender' prototype...
    # Not sure if I like this modular approach but i'm sticking with it
    # Since it gives it the 'adding on' feel which is described in the scenario
    module BenderProgrammableLogicFirmware
      def predict_direction
        directions = get_directions
        if @directions_tried.include?(@direction)
          direction = directions.find { |d| d unless @directions_tried.include?(d) }
        else
          direction = @direction
        end
        direction
      end

      def get_directions
        @inverted ? CompassLogicGates::INVERTED_DIRECTIONS_ABBR : CompassLogicGates::STANDARD_DIRECTIONS_ABBR
      end

      def predict_move(object)
        predict_bender_move(object)
        predict_bender_interaction(object)
      end
    end
  end

  # Compiled Firmware
  module FirmwareUpdate
    include FuturamaLand::NewBenderFirmware::CompassLogicGates
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
    attr_accessor :current_object
    attr_accessor :map
    attr_accessor :lonely_road

    include FuturamaLand::FirmwareUpdate

    def initialize(map)
      @location = {}
      @direction = 'SOUTH'
      @directions_tried = []
      @current_object = nil
      @found_booth = false
      @breaker_mode = false
      @teleport = false
      @lonely_road = []
      @count = 0
      @map = map
    end


    def wander_around
      @current_direction = predict_direction
      STDERR.puts "current_direction: #{@current_direction}"
      @current_location = new_location
      STDERR.puts "current_location #{@current_location}"
      @current_object = @map.object_at_location(@current_location)
      STDERR.puts "current_object #{@current_object}"
      if @directions_tried.size > 4
        @looping = true
        @lonely_road = 'LOOP'
      elsif can_move_to_object?
        move_to_object
        @location = move_bender
        update_bender_on_map
        cleanup_state
        finish_taking_lonely_step
      else
        @directions_tried << @current_direction
        wander_around
      end
    end

    private

    def new_location
      row_or_column, new_direction = COMPASS_ADVICE[@current_direction]
      current_location = @location.dup
      if new_direction == :up
        current_location[row_or_column] += 1
      elsif new_direction == :down
        current_location[row_or_column] -= 1
      end
      current_location
    end

    def can_move_to_object?
      passable = true
      passable = false if impassable_object? 
      passable = false unless can_smash?
      passable
    end

    def move_to_object
      case @current_object
      when /(N|E|S|W)/i then handle_path_modifier
      when /X/i then handle_bender_smashin if can_smash?
      when /\$/ then handle_bender_found_suicide_booth
      when /I/i then handle_bender_inverted
      when /T/i then handle_bender_teleport_mode
      when /B/i then handle_bender_rationalization
      end
    end

    def impassable_object?
      @current_object == '#'
    end

    def can_smash?
      @breaker_mode == true && @current_object == /X/i
    end

    def finish_taking_lonely_step
      @direction = @current_direction
      @lonely_road << @direction
    end

    def move_bender
      if @teleport
        @map.get_teleport_location(@current_location)
      else
        @current_location
      end
    end

    def handle_path_modifier
      @direction = PATH_MODIFIER_CHANGES[@current_object]
    end

    def update_bender_on_map
      @map.move_bender_on_map(@location)
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
      @current_location = nil
      @current_object = nil
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
    end

    def upload_to_map(row)
      @rows << row.split('')
    end

    def display_map
      @rows.each do |row|
        STDERR.print row
      end
    end

    def locate_bender(bender)
      @rows.each_with_index do |row, row_index|
        column_index = row.index('@')
        if column_index
          location = { row_index: row_index, column_index: column_index }
          mark_bender_on_map(bender, location)
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
      # This is returning [4,1] meaning it went down one too far, then it turns right (east)
      @rows[location[:row_index]][location[:column_index]]
    end

    def mark_bender_on_map(bender, location)
      @bender = bender
      @bender.location = location
    end

    def move_bender_on_map(current_location)
      update_map(current_location, '@')
    end

    def bender_smash_obstacle(current_location)
      update_map(current_location, ' ')
    end

    def update_map(location, symbol)
      @rows[location[:row_index]][location[:column_index]] = symbol
    end
  end
 
  # Good news everyone! We can get started!
  # Thank Goodness Leela knows what she's doing. 
  # 'If we're going to save bender we have to start somewhere...' thinks Fry
  # 'Oh! I know! Let's start with using this logic we've given and 
  # put it in his head! Ha! as if he had an logic to begin with... 
  # stupid robot.' 
  # -  Fry Trying to Act Like He Doesn't Care - though deep down he's worried
  #    for his friend.
  module OperationStopSuicideNation
    def self.download_map
      # Auto-generated code below aims at helping you parse
      # the standard input according to the problem statement.
      l, c = gets.split(' ').collect { |x| x.to_i }
      @map = FuturamaLand::CityMap.new(bender: @bender)
      l.times do
        row = gets.chomp
        @map.upload_to_map(row)
      end
    end

    def self.upload_firmware
      @bender = FuturamaLand::Bender.new(@map)
    end

    def self.save_bender
      # Write an action using puts
      # To debug: STDERR.puts "Debug messages..."
      @map.locate_bender(@bender)
      @looping = false
      @bender.wander_around until @bender.found_booth || @looping
      @bender.lonely_road.each { |lonely_step| puts lonely_step }
    end
  end
end

FuturamaLand::OperationStopSuicideNation.download_map
FuturamaLand::OperationStopSuicideNation.upload_firmware
FuturamaLand::OperationStopSuicideNation.save_bender
