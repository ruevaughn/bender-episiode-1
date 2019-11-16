module FuturamaLand
  module NewBenderFirmware
    module CompassLogic
      COMPASS_ADVICE = {
        north: {column_index: :up},
        east: {row_index: :up}
        south: {row_index: :down}
        west: {column_index: :down}
      }

      CARDINAL_DIRECTIONS = ['NORTH', 'EAST', 'SOUTH', 'WEST'].freeze
      NORTH = COMPASS[0].freeze
      EAST = COMPASS[1].freeze
      SOUTH = COMPASS[2].freeze
      WEST = COMPASS[3].freeze

      DIRECTION_CHANGES = {'N' => NORTH, 'E' => EAST, 'S' => SOUTH, 'W' => 'WEST'}
    
      STANDARD_DIRECTIONS = {south: SOUTH, east: EAST, north: NORTH, west: WEST].freeze
      INVERTED_DIRECTIONS = {west: WEST, north: NORTH, east: EAST, south: SOUTH].freeze
    end

    module BenderProgrammableLogicFirmware
      def predict_move(object)
        predict_bender_move if can_move(object)
      end

      def can_move?(object)
        if object == 
      end
    end

  module Firmware
    include FuturamaLand::NewBenderFirmware::CompassLogic
    include FuturamaLand::NewBenderFirmware::BenderProgrammableLogicFirmware
  end
  
  class Bender
    attr_accessor :location
    attr_accessor :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted
    attr_reader :map

    prepend FuturamaLand::Firmware

    def initialize
      @location = {}
      @found_booth = false
      @breaker_mode = false
    end

    def implant_map
      @map = map
    end

    def get_new_location(direction)
      row_or_column, direction = COMPASS_ADVICE[direction]
      if direction == :up
        new_location = location[row_or_column] += 1
      elsif direction == :down 
        new_location = location[row_or_column] -= 1
      end
    end

    def look_around
      directions = @booster.inverted ? INVERTED_DIRECTIONS : STANDARD_DIRECTIONS

      directions.each do |direction| 
        location_to_check = get_new_location(direction)
        object = @map.object_at_location
        predict_move(object)
          # For each direction check if can move
          # For each direction check if can interact
          # For each direction check if teleporter
          # For each direction check if beer
        end

    end

end

  class CityMap
    attr_accessor :rows
    attr_accessor :bender

    OBJECTS = { '$' => :suicide_booth, 'B' =>  :beer, 'I' => :inverter, 'T' => :teleporters }
    OBSTACLES = { '#' => :unbreakable,  'X' => :breakable }
    OPEN_SPACE = ' '


    def initialize(bender)
      @rows = []
      @bender = bender
    end
  
    def upload_to_map(row)
      @rows << row.split('')
      @map << row
    end

    def locate_bender
      @rows.each_with_index do |row, row_index|
        if column_index = row.index("@")
          location = {
              row_index: row_index, 
              column_index: column_index 
          }
          set_current_bender_location(location)
        end
        break if column_index
      end
    end


    private
    def set_current_bender_location(location)
      @bender.location = location
    end

    def move_direction
      if @booster.inverted
        move_west  if move_west?
        move_north if move_north?
        move_east  if move_east?
        check_south
      else
        check_south
        check_east
        check_north
        check_west
        move_east  if move_east?
        move_north if move_north?
        move_west  if move_west?
      end
    end

    def object_at_location(location)
      @rows[location[:row_index]][location[:column_index]
    end

    def check_south
      location = @bender.location
      new_location[:column_index] -= 1
      
      move_south if move_south?(new_location)
      interact_south if interact_south?(location)
    end

    def check_south
      location = @bender.location
      new_location[:column_index] -= 1
      
      move_south if move_south?(new_location)
      interact_south if interact_south?(location)
    end

    def check_south
      location = @bender.location
      new_location[:column_index] -= 1
      
      move_south if move_south?(new_location)
      interact_south if interact_south?(location)
    end

    def check_south
      location = @bender.location
      new_location[:column_index] -= 1
      
      move_south if move_south?(new_location)
      interact_south if interact_south?(location)
    end


    def interact_south?(location)
      true if check_interact_column(location)
    end

    def move_south
      @bender.location[:column_index] -= 1
      puts "SOUTH"
    end

    def move_north
      @bender.location[:column_index] += 1
      puts "NORTH"
    end

    def move_east
      @bender.location[:row_index] += 1
      puts "EAST"
    end

    def move_west
      @bender.location[:row_index] -= 1
      puts "WEST"
    end

    def change_direction
    end

    def move_south?(location)
      true if check_move_column(location)  
    end

    def move_north?
      location = @bender.location
      location[:column_index] += 1
      true if check_move_column(location) == /\w/
    end
    
    def move_east?
      location = @bender.location
      location[:row_index] += 1
       if check_move_column(location) == /\w/
        true
       elsif check_move_column(location) == 'e'
    end

    def move_west?
      location = @bender.location
      location[:row_index] -= 1
      true if check_move_column(location) == /\w/
    end

    def check_column(location)
      column = @rows[location[:row_index]][location[:column_index]]
    end

    def check_move_column(location)
      column = check_column
      if column.match?(/\w/)
        true
      elsif column.match('$')
        @bender.found_booth = true
        true
      end
    end

    def update_map(location, symbol)
      @map[location[:row_index]][location[:column_index]] = symbol
    end

    def check_interact_column(location)
      column = check_column(location)
      if column.match?('b')
        @bender.breaker_mode == !@bender.breaker_mode
      elsif column.match('$')
        @bender.found_booth = true
        true
      elsif column.match('x')
        update_map(location, ' ') if @bender.breaker_mode 
      elsif column.match('i')
        @bender.inverted = true
      end
    end

    def check_change_direction_column(location)
      column = check_column(location)
       if column.match(/\#/)
        change_direction
      elsif column.match(/x/)
        change_direction 
      elsif column.match('n')
        change_direction('NORTH')
      elsif column.match('e')
        change_direction('EAST')
      elsif column.match('w')
        change_direction('WEST')
      elsif column.match('s')
        change_direction('SOUTH')
      end
    end

    def change_direction(direction=nil)
      if direction
        @bender.direction = direction
        
      else # TODO: THis one
        @bender.direction = next_direction()
      end
    end
  end
  
end
  
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect {|x| x.to_i}
@bender = FuturamaLand::Bender.new
@map = FuturamaLand::Map.new(bender: @bender)
@bender.implant_map(@map)
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
