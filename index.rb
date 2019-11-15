module FuturamaLand
  class Map
    attr_accessor :rows
    attr_accessor :rows_as_string
    attr_accessor :bender_location
  
    def initialize
      @rows = []
      @map = ''
      @bender_location = {}
    end
  
    def insert_row(row)
      # [["#####"], ["\#@  #"], ["#   #"], ["#  $#"], ["#####"]]
      @rows << row.split('')
      @map << row
    end

    def get_bender_location
      @rows.each_with_index do |row, row_index|
        if row.include?('@')
          column_index = row.index("@")
          @bender_location = {row_index: row_index, column_index: column_index }
        end
        break if column_index
      end
      STDERR.puts "Bender found at: #{@bender_location}"
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
@map = FuturamaLand::Map.new
# @bender = FuturamaLand::Bender.new
l.times do
  row = gets.chomp
  @map.insert_row(row)
end

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."

@map.rows.each do |row|
  @map.get_bender_location
  puts @map.bender_location
end
