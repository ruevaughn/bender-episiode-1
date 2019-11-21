# frozen_string_literal: true

########################################################################
#     =------------------------------------------------------=         #
#                    4 - Government issues Firmware                    #
#             (which they genereoursly let the professor build         #
#                           *ahem* *cough*                             #
#  =------------------------------------------------------------=      #
#           Keeps track of Benders location, allows him to see         #
#           the objects just out of view, and make decisions           #
#            (Which of course helps us predict his actions)            #
#            This way we don't have to give that witless Fry           #
#            news his brain is incapable of handling, thus             #
#             preventing an eposode on the matter.                     #
#                                                                      #
########################################################################
########################################################################
# =>        Chase Jensen -  Project For AllyDVM  =D                <= ##
########################################################################

# Welcome to Futurama!
module FuturamaLand
  # Benders new firmware to be compiled - the writer of this firmware assumes
  # bender is already self aware of Bender, and calling methods accordingly.
  # He hasn't taken this approach with modules before but is seeing how it goes
  module NewBenderFirmware
    module CompassLogicGates
      COMPASS_ADVICE = {
        NORTH: [:row_index, :down],
        EAST: [:column_index, :up],
        SOUTH: [:row_index, :up],
        WEST: [:column_index, :down]
      }.freeze

      CARDINAL_DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
      CARDINAL_ABBR = %w[N E S W].freeze
      NORTH = CARDINAL_DIRECTIONS[0].freeze
      EAST = CARDINAL_DIRECTIONS[1].freeze
      SOUTH = CARDINAL_DIRECTIONS[2].freeze
      WEST = CARDINAL_DIRECTIONS[3].freeze

      DIRECTION_CHANGES = { 'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => WEST }.freeze

      STANDARD_DIRECTIONS = [SOUTH, EAST, NORTH, WEST].freeze
      INVERTED_DIRECTIONS = [WEST, NORTH, EAST, SOUTH].freeze

      def decode_object(object)
        case object
        when /\s+/ then "whitespace"
        else
          object
        end
      end
    end

    # These firmware updates are aware of the original 'Bender' prototype...
    # Not sure if I like this modular approach but i'm sticking with it
    # Since it gives it the 'adding on' feel which is described in the scenario
    module BenderProgrammableLogicFirmware
      def predict_direction
        # STDERR.puts "#{@count}) Finding new direction: @direction: #{@direction}"
        # STDERR.puts "#{@count}) Finding new direction: @directions_tried: #{@directions_tried}"
        # STDERR.puts "#{@count}) Finding new direction: @directions_tried.include?(@direction): #{@directions_tried.include?(@direction)}"
        directions = get_directions
        if @directions_tried.include?(@direction)
          a = directions.find { |d| !@directions_tried.include?(d) }
          # STDERR.puts "#{@count}) Found #{a} instead of #{@direction}"
          a
        else
          # STDERR.puts "#{@count}) DID NOT Find new direction: @direction: #{@direction}"
          # STDERR.puts "#{@count}) DID NOT Find new direction: @directions_tried: #{@directions_tried}"
          @direction
        end
      end

      def get_directions
        @inverted && @obstacle_encountered ? CompassLogicGates::INVERTED_DIRECTIONS : CompassLogicGates::STANDARD_DIRECTIONS
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
  #                     2 - Big Man Bender Himself!                      #
  #  =------------------------------------------------------------=      #
  #           Keepts track of Benders location, allows him to see        #
  #              the objects just out of view, and make decsisiosn       #
  #                                                                      #
  ########################################################################
  ########################################################################
  # =>                                                                <= #
  ########################################################################

  # Bender - Beer, Women, Robots, Partying, Fry - These are just some of his
  #          favorite thing on his Hard Drive. Unfortunately things have gotten sour
  #          for the little guy and No one feels bad for him but himself. He's gotten
  #          to the point we have to intervene - Little does he know he's about to get
  # a firmware update
  class Bender
    # Bender Modes
    attr_reader :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted

    # Bender State
    attr_reader :direction
    attr_reader :directions_tried
    attr_reader :stuck_in_loop
    attr_reader :lonely_road
    attr_reader :count

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

    def update_map_on_bender_smashin
      @map.remove_smashed_object
    end

    def showoff
      bender_quote
      wave_flag
    end

    def wander_around
      @count += 1
      # @directions_tried = [1, 2, 3, 4, 5] if @count >= 66
      # STDERR.puts "#{@count}) Bender was facing #{@direction}"
      @direction = predict_direction
      # STDERR.puts "#{@count}) Bender is now facing #{@direction}"
      # STDERR.puts "#{@count}) Bender is at #{@map.benders_location}"
      loc = @map.get_benders_new_location(@direction)
      # STDERR.puts "#{@count}) Bender will be moving to #{loc}"
      @current_object = @map.object_in_front_of_bender
      # STDERR.puts "#{@count}) Benders is facing object #{decode_object @current_object}"
      # STDERR.puts "#{@count}) Can move to object: #{can_move_to_object?}"
      if @directions_tried.size > 4
        # STDERR.puts "#{@count}) Directions tried: #{@directions_tried} #{@directions_tried.size}"
        @stuck_in_loop = true
        @lonely_road << ['LOOP']
      elsif can_move_to_object?
        # STDERR.puts("#{@count}) About to interact with object: #{decode_object @current_object}")
        # @map.display_map
        interact_with_object
        # STDERR.puts("#{@count}) About to Take Step #{decode_object @current_object}")
        if @teleport
          # STDERR.puts "#{@count}) Teleporting Bender"
          teleport_bender_on_map
        else
          # STDERR.puts "#{@count}) Taking Sad Lonely Step"
          take_sad_lonely_step
          @direction = @instant_change_direction.dup if @instant_change_direction
        end
        # STDERR.puts("#{@count}) Freeing Ram")
        free_bender_ram_for_next_step
      else
        # STDERR.puts("#{@count}) Adding #{@direction} to #{@directions_tried}")
        @obstacle_encountered = true
        change_direction
      end
    end

    private

    def change_direction
      @directions_tried << @direction
      wander_around
    end

    def can_move_to_object?
      if empty_space?
        true
      elsif breakable_object?
        if @breaker_mode == true
          # STDERR.puts "can smash! #{can_smash_object?} breaker mode: #{@breaker_mode}"
          true
        else
          # STDERR.puts "cannot smash! #{!can_smash_object?} breaker mode: #{@breaker_mode}"
          false
        end
      elsif unbreakable_object?
        false
      else
        # STDERR.puts "#{@count}Allowed #{@current_object} to pass"
        true
      end
    end

    def interact_with_object
      # STDERR.puts("#{@count}) Interacting with object: #{decode_object @current_object}")
      case @current_object
      when /\s/ then true
      when /N|E|S|W/i then handle_path_modifier
      when /X/i then handle_bender_smashin
      when /I/i then handle_bender_inverted
      when /T/i then handle_bender_teleport_mode
      when /B/i then handle_bender_rationalization
      when '$' then handle_bender_found_suicide_booth
      else
        raise "Unhandled interaction with object #{decode_object @current_object}"
      end
    end

    def empty_space?
      # STDERR.puts "#{@count}) empty_space object: #{decode_object @current_object}"
      # STDERR.puts "#{@count}) empty_space direction: #{@direction}"
      # STDERR.puts "#{@count}) empty_space regex: #{@current_object.match?(/\s/)}"
      @current_object.match?(/\s{1}/)
    end

    def unbreakable_object?
      @current_object.match?(/#/)
    end

    def breakable_object?
      @current_object.match?(/X/i)
    end

    def can_smash_object?
      (@breaker_mode && @current_object.match?(/X/i)) ? true : false
    end

    def teleport_bender_on_map
      # STDERR.puts "#{@count}) Teleporting to bender: Bender location before: #{@map.benders_location}"
      @map.locate_other_teleporter
      @map.move_bender_to_new_location
      track_benders_path
      # STDERR.puts "#{@count}) Done teleporting to bender: Bender location after: #{@map.benders_location}"
    end

    def take_sad_lonely_step
      # STDERR.puts "#{@count}) Moving Bender, current loc: #{@map.benders_location}"
      # STDERR.puts "#{@count}) Moving Bender, current loc: #{@map.location_ahead_of_bender}"
      @map.move_bender_to_new_location
      # STDERR.puts "#{@count}) Moved Bender, current loc: #{@map.benders_location}"
      # STDERR.puts "#{@count}) Movied Bender, current loc: #{@map.location_ahead_of_bender}"
      track_benders_path
    end

    def track_benders_path
      # STDERR.puts "#{@count}) Tracking Bender, he is facing: #{@direction}"
      # STDERR.puts "#{@count}) Tracking Bender, he has been: #{@lonely_road}"
      STDERR.puts "#{Bender} went #{@direction} over #{@current_object} and Breaker mode is #{@breaker_mode}"
      @lonely_road << @direction
      # STDERR.puts "#{@count}) Done tracking Bender, he is facing: #{@direction}"
      # STDERR.puts "#{@count}) Done tracking Bender, he has been: #{@lonely_road}"
    end

    def handle_path_modifier
      @instant_change_direction = DIRECTION_CHANGES[@current_object]
    end

    def handle_bender_rationalization
      toggle_breaker_mode
    end

    def handle_bender_smashin
      if can_smash_object?
        update_map_on_bender_smashin if can_smash_object?
      else
        change_direction
      end
    end

    def toggle_breaker_mode
      @breaker_mode = !@breaker_mode
    end

    def handle_bender_inverted
      @inverted = !@inverted
    end

    def handle_bender_teleport_mode
      @teleport = true
    end

    def handle_bender_found_suicide_booth
      @found_booth = true
    end

    def free_bender_ram_for_next_step
      @directions_tried = []
      @instant_change_direction = nil
      @teleport = false
    end

    def bender_quote
      quotes = []
      quotes << 'I got ants in my butt, and I needs to strut.'
      STDERR.puts quotes.sample
    end

    def wave_flag
      STDERR.puts "()~~~~~~~~~~~~-+" # I guess it's a crime to have colored flags these days.
      STDERR.puts "¶|  FUTURAMA. ||" # .colorize(color: :red, background: :orange)
      STDERR.puts "¶|  (BENDER)  ||" # colorize(color: :grey)
      STDERR.puts "¶|  RULEZ!!!  ||" # colorize(color: :red, background: :orange)
      STDERR.puts "¶|  EPISODE 1 ||"
      STDERR.puts "¶|~~~~~~~~~~~~-+"
      STDERR.puts "¶|"
      STDERR.puts "¶|"
      STDERR.puts "~~~~"
    end
  end

  ########################################################################
  #     =------------------------------------------------------=         #
  #                          2 - Map Class                               #
  #  =------------------------------------------------------------=      #
  #           Keepts track of Benders location, allows him to see        #
  #              the objects just out of view, and make decsisiosn       #
  #                                                                      #
  ########################################################################
  # X       The map will keep track of the state of Benders Locations    #
  ########################################################################
  # =>                                                                <= #
  ########################################################################

  # I'm the map i'm the map i'm the map!
  class CityMap
    attr_accessor :rows
    attr_accessor :bender
    attr_reader :benders_location
    attr_reader :location_ahead_of_bender
    attr_reader :object_ahead_of_bender
    attr_reader :removed_object

    include FuturamaLand::NewBenderFirmware::CompassLogicGates

    def initialize(attrs = {})
      @rows = []
    end

    def upload_to_map(row)
      @rows << row.split('')
    end

    def get_benders_new_location(direction)
      # STDERR.puts "#{@bender.count}) Current Location: #{@benders_location}"
      # STDERR.puts "#{@bender.count}) Getting new loc from direction: #{direction}"
      # STDERR.puts "~~~~~~~#{COMPASS_ADVICE}~~~~~~~~~"
      row_or_column, new_direction = COMPASS_ADVICE[direction.to_sym]
      # STDERR.puts "row_or_column: #{row_or_column} new_direction: #{new_direction}"
      current_location = @benders_location.dup
      if new_direction == :up
        current_location[row_or_column] += 1
      elsif new_direction == :down
        current_location[row_or_column] -= 1
      end
      @location_ahead_of_bender = current_location
    end

    def display_map
      @rows.each do |row|
        STDERR.puts row.join('')
      end
    end

    def move_bender_to_new_location()
      move_bender_on_map(@location_ahead_of_bender)
      @benders_location = @location_ahead_of_bender
      # STDERR.puts "@benders_location after: #{@benders_location}"
    end

    def locate_object_on_map(object)
      location = nil
      @rows.each_with_index do |row, row_index|
        column_index = row.index(object)
        location = { row_index: row_index, column_index: column_index } if column_index
        # STDERR.puts "#{bender.count}) #{object} located at #{location}"
        break if column_index
      end
      location
    end

    def locate_bender(bender)
      @bender = bender
      location = locate_object_on_map('@')
      @benders_location = location
      # STDERR.puts "#{bender.count}) Bender located at #{@benders_location}"
    end

    def locate_other_teleporter
      location = nil
      @rows.each_with_index do |row, row_index|
        column_index = row.index('T')
        if column_index
          found_location = { row_index: row_index, column_index: column_index }
          location = found_location unless location == benders_location
        end
        break if location
      end
      @location_ahead_of_bender = location
    end

    def remove_smashed_object
      update_map(@location_ahead_of_bender, ' ')
    end

    def move_bender_on_map(new_location)
      old_object = @removed_object if @removed_object
      old_object ||= ' '

      new_object = view_map_object(new_location)
      update_map(benders_location, old_object)
      # STDERR.puts("#{bender.count}) moving bender from")
      # STDERR.puts("#{bender.count}) #{benders_location}")
      # STDERR.puts("#{bender.count}) to")
      # STDERR.puts("#{bender.count}) #{new_location}")
      update_map(new_location, '@')
      @removed_object = new_object
      # display_map
    end

    def object_in_front_of_bender
      # STDERR.puts("#{bender.count}) location in front of bender: #{@location_ahead_of_bender}")
      object = view_map_object(@location_ahead_of_bender)
      # STDERR.puts("#{bender.count}) object found in front of bender: #{decode_object object}")
      @object_ahead_of_bender = object
      # STDERR.puts("#{bender.count}) object set in front of bender: #{decode_object @object_ahead_of_bender}")
      object
    end

    private

    def update_map(location, symbol)
      @rows[location[:row_index]][location[:column_index]] = symbol
      # @rows.each_with_index do |row, row_i|
      #   row[location[:column_index]] = symbol if location[:row_index] == row_i
      #   break if location[:row_index] == row_i
      # end
    end

    def view_map_object(location)
      # STDERR.puts("#{bender.count}) Viewing object at location: #{location}")
      # STDERR.puts("#{bender.count}) Rows is: #{@rows}")
      # STDERR.puts("#{bender.count}) row_index is : #{location[:row_index]}")
      # STDERR.puts("#{bender.count}) column_index is : #{location[:column_index]}")
      object = @rows[location[:row_index]][location[:column_index]]
      # STDERR.puts("#{bender.count}) object found at location: #{object}")
      object
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
      #   @map.display_map
      @map.locate_bender(@bender)
      #   @bender.showoff

      @bender.wander_around until (@bender.found_booth || @bender.stuck_in_loop)
      @bender.lonely_road.each { |lonely_step| puts lonely_step }
    end
  end
end

FuturamaLand::OperationStopSuicideNation.download_and_obtain_map
FuturamaLand::OperationStopSuicideNation.update_firmware
FuturamaLand::OperationStopSuicideNation.save_bender
