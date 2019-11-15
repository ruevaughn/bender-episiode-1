module FuturamaLand
  class Map
    attr_accessor :rows
    attr_accessor :rows_as_string
  
    def initialize
      @rows = []
      @map = ''
    end
  
    def insert_row(row)
      @rows << row.lines(',')
      @map << row
    end
  
    def draw_map
      puts @map
    end
  end
  
  class Bender
    attr_accessor :direction
    
    def initialize
      @direction = 'SOUTH'
    end
  end
  
end
  
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect {|x| x.to_i}
l.times do
  row = gets.chomp
  @map = FuturamaLand::Map.new
  @map.insert_row(row)
end
@bender = FuturamaLand::Bender.new

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."

puts @bender.direction
