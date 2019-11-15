class Map
  attr_accessor :rows
  attr_accessor :rows_as_string

  def initialize
    @rows = []
    @map = ''
  end

  def insert_row(row)
    @rows << row.lines(',')
    @map << row + '\n'
  end
end

class Bender

  attr_accessor :direction
  attr
  def initialize
    @direction = 'SOUTH'
  end

end
def get_bender_location(row, line_index)
  if row.index('@')
    @bender = []
  end
  STDERR.puts row
end

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect {|x| x.to_i}
l.times do |line_index|
  STDERR.puts gets
  row = gets.chomp
  @map = Map.new
  @map.insert_row(row)
  # get_bender_location(row)
end
STDERR.puts @map.map

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."

puts "answer"
