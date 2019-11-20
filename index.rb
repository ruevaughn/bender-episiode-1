# frozen_string_literal: true



########################################################################
#     =------------------------------------------------------=         #
# A                  4 - Government issues Firmwar                     #
#             (which they genereoursly let the professor build         #
#                           *ahem* *cough*                             #
#  =------------------------------------------------------------=      #
#           Keepts track of Benders location, allows him to see        #                                                               #
#              the objects just out of view, and make decsisiosn       #
#                                                                      #
########################################################################
########################################################################
# =>                                                                <= #t
########################################################################



# Welcome to Futurama!
module FuturamaLand
  # Benders new firmware to be compiled - the writer of this firmware assumes
  # bender is already self aware of Bender, and calling methods accordingly.
  # He hasn't taken this approach with modules before but is seeing how it goes
  module NewBenderFirmware
    module CompassLogicGates
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
    # Not sure if I like this modular approach but i'm sticking with it
    # Since it gives it the 'adding on' feel which is described in the scenario
    module BenderProgrammableLogicFirmware
      def predict_direction
        if @directions_tried.include(@direction)
          @directions_tried.map { |d| !@direction_tried.include?(@direction)}.flatten.first
        else
          @direction
        end
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









########################################################################
#     =------------------------------------------------------=         #
#                     2 - Big Man Bender Hinself!                     #
#  =------------------------------------------------------------=      #
#           Keepts track of Benders location, allows him to see        #                                                               #
#              the objects just out of view, and make decsisiosn       #
#                                                                      #
########################################################################
########################################################################
# =>                                                                <= #t
########################################################################






  # Bender - Beer, Women, Robots, Partying, Fry - These are just some of his favorite things
  #          on his Hard Drive. Unfortunately things have gotten sour  for the little guy and
  #          No one feels bad for him but himself. He's gotten to the point we have to intervene -
  #          Little does he know he's about to get a firmware update
  class Bender
    # Bender Modes
    attr_accessor :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted
    attr_reader :teleport

    # Bender State
    attr_accessor :direction
    attr_accessor :directions_tried
    attr_accessor :lonely_road

    # Bender Object Associations
    attr_accessor :map

    include FuturamaLand::FirmwareUpdate

    def initialize(map)
      @location = {}
      @direction = 'SOUTH'
      @directions_tried = []
      @found_booth = false
      @breaker_mode = false
      @teleport = false
      @lonely_road = []
      @count = 0
      @map = map

      bender_time__before_depressive_crash

   end

    def showoff
    end

    # Bender needs to get a location. It needs to be reliable.
    # It needs to follow the conention. Never shoud it return wrong. ever.

    def wander_around
      @direction = predict_direction until @direction
      @map.examine_new_location_for_direction
      @map.determine_if_direction_is_walkable(@direction)

      @current_location = new_location
      @current_object = @map.object_at_location(@current_location)
      if @directions_tried.size > 4
        @looping = true
        @lonely_road = ['LOOP']
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
      if @current_object == /\s+/
        true
      eslif @current_object != /#/ || @current_object != /X/i
      elsif impassable_object?
        false
      elsif !(can_smash?)
        false
      end
    end

    def move_to_object
      case @current_object
      when /\s/ then handle_open_space
      when /(N|E|S|W)/i then handle_path_modifier
      when /X/i then handle_bender_smashin if can_smash?
      when /\$/ then handle_bender_found_suicide_booth
      when /I/i then handle_bender_inverted
      when /T/i then handle_bender_teleport_mode
      when /B/i then handle_bender_rationalization
      end
    end

    def handle_open_space
      @location = @current_location
    end

    def impassable_object?
      @current_object && @current_object == /#/
    end

    def can_smash?
      if @current_object && @current_object == /X/i
        true if @breaker_mode == true
      else
        false
      end
    end

    def finish_taking_lonely_step
      @direction = @current_direction
      @lonely_road << @direction
    end

    def move_bender
      if @teleport
        @location = @map.get_teleport_location(@current_location)
      else
        @location = @current_location
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
      @breaker_mode = false
      @teleport = false
    end

    def bender_time__before_depressive_crash
      STDERR.print "¶i~~~~~~~~~~~~()" # I guess it's a crime to have colored flags these days.
      STDERR.print "¶|  FUTURAMA. ||" # .colorize(color: :red, background: :orange)
      STDERR.print "¶|  (BENDER)  ||" # colorize(color: :grey)
      STDERR.print "¶|  RULEZ!!!  ||" # colorize(color: :red, background: :orange)
      STDERR.print "¶|            ||"
      STDERR.print "¶+|~~~~~~~~~~~()"
      STDERR.print "¶|"
      STDERR.print "¶|"
      STDERR.print "()"
    end
  end




########################################################################
#     =------------------------------------------------------=         #
#                     2 - Map Class     b                              #
#  =------------------------------------------------------------=      #
#           Keepts track of Benders location, allows him to see        #                                                               #
#              the objects just out of view, and make decsisiosn       #
#                                                                      #
########################################################################
#X       The map will keep track of the state of Benders Locations     #
########################################################################
# =>                                                                <= #
########################################################################





  # I'm the map i'm the map i'm the map!
  class CityMap
    attr_accessor :rows
    attr_accessor :bender
    attr_accessor :bender_location
    attr_accessor :location_ahead_of_bender
    attr_accessor :object_ahead_of_bender

    def initialize(attrs = {})
      @rows = []
      @bender_location
      @bender_next_location_attempt
    end


    def examine_new_location_for_direction

    end

    def determine_if_direction_is_walkable(direction)
      obect_at_location(location)
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
          bender_location = location
          STDERR.puts "Bender located at #{location}"
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

    def move_bender_on_map(current_location)
      update_map(current_location, '@')
    end

    def bender_smash_gg(current_location)
      update_map(current_location, ' ')
    end

    def update_map(location, symbol)
      @rows[location[:row_index]][location[:column_index]] = symbol
    end
  end






########################################################################
#     =------------------------------------------------------=         #
#                     1 - Begin -indes.rb                              #
#  =------------------------------------------------------------=      #
#                                                                      #
#                   * Initialize Bender and Map                        #
########################################################################
#X       The map will keep track of the state of Benders Locations     #
########################################################################
# =>                                                                   #
########################################################################







  # Good news everyone! We can get started!
  # Thank Goodness Leela knows what she's doing.
  # 'If we're going to save bender we have to start somewhere...' thinks Fry
  # 'Oh! I know! Let's start with using this logic we've given and
  # put it in his head! Ha! as if he had an logic to begin with..
  # stupid robot.'
  # -  Fry Trying to Act Like He Doesn't Care - though deep down he's worried
  #    for his friend.
  module OperationStopSuicideNation
    def self.download_and_obtain_map
      # Auto-generated code below aims at helping you parse
      # the standard input according to the problem statement.
      l, c = gets.split(' ').collect { |x| x.to_i }
      @map = FuturamaLand::CityMap.new(bender: @bender)
      l.times do
        row = gets.chomp
        @map.upload_to_map(row)
      end
    end

    def self.update_firmware
      @bender = FuturamaLand::Bender.new(@map)
    end

    def self.save_bender
      # Write an action using puts
      # To debug: STDERR.puts "Debug messages..."
      @map.locate_bender(@bender)
      @bender.showoff
      @looping = false
      @bender.wander_around until @bender.found_booth || @bender.stuck_in_loop
      @bender.lonely_road.each { |lonely_step| puts lonely_step }
    end
  end
end

FuturamaLand::OperationStopSuicideNation.download_and_obtain_map
FuturamaLand::OperationStopSuicideNation.update_firmware
FuturamaLand::OperationStopSuicideNation.save_bender
