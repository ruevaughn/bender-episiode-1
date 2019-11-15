module FuturamaLand
  DIRECTIONS  = {south: 'SOUTH', east: 'EAST', north: 'NORTH', west: 'W'}.freeze
    
  SOUTH = FuturamaLand::DIRECTIONS[:south].freeze
  EAST  = FuturamaLand::DIRECTIONS[:east].freeze
  NORTH = FuturamaLand::DIRECTIONS[:north].freeze
  WEST  = FuturamaLand::DIRECTIONS[:west].freeze

  class Map
    attr_accessor :rows
    attr_accessor :rows_as_string
    attr_accessor :bender
  
    def initialize(attrs={})
      @rows = []
      @map = ''
      @bender = attrs[:bender] || Bender.new
    end
  
    def insert_row(row)
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

    def predict_move
      scan_direction(@bender.direction)
    end

    def draw_map
      puts @map
    end

    private
    def set_current_bender_location(location)
      @bender.location = location
    end

    def move_direction(direction)
      case direction
      when "SOUTH" then move_south if move_south?
      when "EAST" then move_east   if move_east?
      when "NORTH" then move_north if move_north?
      when "WEST" then move_west   if move_west?
    end

    def move_south?
      location = @bender.location
      location[:column_index] -= 1
      true if check_column(location) == /\w/
    end

    def move_north?
    end
    
    def move_east?
    end

    def move_west?
    end

    def check_column(location)
      object = @rows.first[location[:row_index][location[:column_index]]]

    end
  end
  
  class Bender
    attr_accessor :direction
    attr_accessor :location

    DIRECTION = {
      south: FuturamaWorld::SOUTH, 
      east: FuturamaWorld::EAST, 
      north: FuturamaWorld::NORTH, 
      west: FuturamaWorld::WEST}.freeze
  }
    def initialize
      @direction = DIRECTION[:south]
      @location = {}
    end
  end
end
  
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect {|x| x.to_i}
@bender = FuturamaLand::Bender.new
@map = FuturamaLand::Map.new(bender: @bender)
l.times do
  row = gets.chomp
  @map.insert_row(row)
end

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."
@map.locate_bender
@map.predict_move


