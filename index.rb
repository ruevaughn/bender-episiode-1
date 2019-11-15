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

    def draw_map
      puts @map
    end

    private
    def set_current_bender_location(location)
      @bender.location = location
    end
  end
  
  class Bender
    attr_accessor :direction
    attr_accessor :location
    
    def initialize
      @direction = 'SOUTH'
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


