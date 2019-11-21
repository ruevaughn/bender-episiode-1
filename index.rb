# frozen_string_literal: true

########################################################################
#     =------------------------------------------------------=         #
# A                  4 - Government issues Firmwar                     #
#             (which they genereoursly let the professor build         #
#                           *ahem* *cough*                             #
#  =------------------------------------------------------------=      #
#           Keepts track of Benders locatifn, allows him to see        #                                                               #
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
          @directions_tried.map { |d| !@direction_tried.include?(@direction) }.flatten.first
        else
          @direction
        end
      end

      def get_directions
        @inverted ? CompassLogicGates::INVERTED_DIRECTIONS_ABBR : CompassLogicGates::STANDARD_DIRECTIONS_ABBR
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
  #                     2 - Big Man Bender Himself!                     #
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

    # Bender State
    attr_accessor :direction
    attr_accessor :directions_tried
    attr_accessor :stuck_in_loop
    attr_accessor :lonely_road

    # Bender Object Associations
    attr_accessor :map

    include FuturamaLand::FirmwareUpdate

    def initialize(map)
      @direction = 'SOUTH'
      @directions_tried = []
      @found_booth = false
      @breaker_mode = false
      @teleport = false
      @lonely_road = []
      @count = 0
      @map = map
    end

    def update_map_on_benders_direction(direction)
      @map.inspect_location_in_direction(direction)
    end

    def update_map_on_benders_location
      @map.update_benders_location
    end

    def update_map_on_bender_smashin
      @map.remove_smashed_object
    end

    def showoff
      bender_quote
      wave_flag
    end

    def wander_around
      @direction = predict_direction until @direction
      update_map_on_benders_direction(@direction)
      @current_object = inspect_object_at_location
      if @directions_tried.size > 4
        @stuck_in_loop = true
        @lonely_road << ['LOOP']
      elsif can_move_to_object?
        interact_with_object
        take_sad_lonely_step
        free_ram_for_next_step
      else
        @directions_tried << @current_direction
        wander_around
      end
    end

    private

    def inspect_object_at_location
      @map.object_in_front_of_bender
    end

    def can_move_to_object?
      if is_empty_space?
        true
      elsif can_smash_object?
        true
      elsif unbreakable_object?
        false
      else
        true
      end
    end

    def interact_with_object
      case @current_object
      when /(N|E|S|W)/i then handle_path_modifier
      when /X/i then handle_bender_smashin
      when /\$/ then handle_bender_found_suicide_booth
      when /I/i then handle_bender_inverted
      when /T/i then handle_bender_teleport_mode
      when /B/i then handle_bender_rationalization
      end
      take_sad_lonely_step
    end

    def is_empty_space?
      @current_object.match?(/\s{1}/)
    end

    def unbreakable_object?
      @current_object.match?(/#/)
    end

    def can_smash_object?
      @breaker_mode && @current_object.match?(/X/i) ? true : false
    end

    def take_sad_lonely_step
      if @teleport
        toggle_teleport
        @map.teleport_bender
      else
        update_map_on_benders_location
      end
      track_benders_path
    end

    def track_benders_path
      @lonely_road << @direction
    end

    def handle_path_modifier
      @direction = PATH_MODIFIER_CHANGES[@current_object]
    end

    def handle_bender_rationalization
      toggle_breaker_mode
    end

    def handle_bender_smashin
      update_map_on_bender_smashin
      toggle_braker_mode
    end

    def toggle_breaker_mode
      @breaker_mode = !@breaker_mode
    end

    def toggle_teleport_mode
      @teleport = !@teleport
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

    def free_ram_for_next_step
      @directions_tried = []
    end

    def bender_quote
      quotes = []
      quotes << 'I got ants in my butt, and I needs to strut.'
      STDERR.puts quotes.sample
    end

    def wave_flag
      STDERR.puts "¶i~~~~~~~~~~~~()" # I guess it's a crime to have colored flags these days.
      STDERR.puts "¶|  FUTURAMA. ||" # .colorize(color: :red, background: :orange)
      STDERR.puts "¶|  (BENDER)  ||" # colorize(color: :grey)
      STDERR.puts "¶|  RULEZ!!!  ||" # colorize(color: :red, background: :orange)
      STDERR.puts "¶|            ||"
      STDERR.puts "¶+|~~~~~~~~~~~()"
      STDERR.puts "¶|"
      STDERR.puts "¶|"
      STDERR.puts "()"
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
  # X       The map will keep track of the state of Benders Locations     #
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

    include FuturamaLand::NewBenderFirmware::CompassLogicGates

    def initialize(attrs = {})
      @rows = []
    end

    def upload_to_map(row)
      @rows << row.split('')
    end

    def inspect_location_in_direction(direction)
      row_or_column, new_direction = COMPASS_ADVICE[direction]
      current_location = @bender_location.dup
      if new_direction == :up
        current_location[row_or_column] += 1
      elsif new_direction == :down
        current_location[row_or_column] -= 1
      end
      @location_ahead_of_bender = current_location
    end

    def display_map
      @rows.each do |row|
        STDERR.print row
      end
    end

    def update_benders_location
      @benders_location = @location_ahead_of_bender.dup
      @location_ahead_of_bender = nil
    end

    def locate_bender(bender)
      @rows.each_with_index do |row, row_index|
        column_index = row.index('@')
        if column_index
          location = { row_index: row_index, column_index: column_index }
          @bender_location = location
          STDERR.puts "Bender located at #{@bender_location}"
        end
        break if column_index
      end
    end

    def find_other_teleporter
      location = nil
      @rows.each_with_index do |row, row_index|
        column_index = row.index('T')
        if column_index
          found_location = { row_index: row_index, column_index: column_index }
          location = found_location unless _location == found_location
        end
        break if location
      end
      location
    end

    def teleport_bender
      bender_location = find_other_teleporter
      update_bender_on_map
    end

    def remove_smashed_object
      update_map(location_ahead_of_bender, ' ')
    end

    def move_bendeg_on_map(current_location)
      update_map(current_location, '@')
    end

    def object_in_front_of_bender
      object = view_map_object(@location_ahead_of_bender)
      @object_ahead_of_bender = object
      object
    end

    private

    def update_map(location, symbol)
      @rows[location[:row_index]][location[:column_index]] = symbol
    end

    def view_map_object(location)
      @rows[location[:row_index]][location[:column_index]]
    end
  end

  ########################################################################
  #     =------------------------------------------------------=         #
  #                     1 - Begin -index.rb                              #
  #  =------------------------------------------------------------=      #
  #                                                                      #
  #                   * Initialize Bender and Map                        #
  ########################################################################
  #       The map will keep track of the state of Benders Locations     #
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
