module FuturamaLand
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
      move_direction
      move_interaction
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
        move_east  if move_east?
        move_north if move_north?
        move_west  if move_west?
      end
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
      true if check_move_column(location) == /\w/
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
      elsif column.match('x')
        @bender.breaker_mode ? true : false
      end
    end

    def check_interact_column(location)
      column = check_column(location)
      if column.match?(/\b/)
        @bender.breaker_mode == !@bender.breaker_mode
      elsif column.match('$')
        @bender.found_booth = true
        true
      elsif column.match('x')
        if @bender.breaker_mode ? true : false
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
      elsif column.match('e')
      elsif column.match('w')
      elsif column.match('s')
      end
    end
  end
  
  class Bender
    attr_accessor :direction
    attr_accessor :location
    attr_accessor :found_booth
    attr_accessor :breaker_mode
    attr_accessor :inverted

    def initialize
      @direction = "SOUTH"
      @location = {}
      @found_booth = false
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
while @bender.found_booth == false
  puts @map.predict_move
end
