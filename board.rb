class Board
  attr_reader :grid, :height, :width

  VESSELS = {
    carrier: 5,
    battleship: 4,
    submarine: 3,
    destroyer: 3,
    patrol: 2
  }


  def initialize(grid = [])
    if grid.empty?
      @grid = Board.default_grid
    else
      @grid = grid
    end
    @height = @grid.length
    @width = @grid.first.length
  end

  def Board.default_grid
    Array.new(10) { Array.new(10, nil) }
  end

  def count
    @grid.inject(0) { |sum, row| sum + row.count(:s) }
  end

  def [](coordinates)
    @grid[coordinates.last][coordinates.first]
  end

  def []=(row, col, value)
    @grid[col][row] = value
  end

  def empty?(position = [0,0]) # W no params I think this should be handled differently.
    self[position].nil?
  end

  def full?
    total_grid_size = @grid.inject(0) { |sum, row| sum + row.length }
    total_grid_size - count == 0 ? true : false
  end

  def place_random_ship(vessel_size)
    raise "Board full" if full?
    y = rand(@height)
    x = rand(@width)
    orientation = rand(2)
    piece_placed = false


    until piece_placed
    case orientation
    when 0 #vertical
      if space_vertical?([x,y],vessel_size)
        place_vertical([x,y],vessel_size)
        piece_placed = true
      else
        y = rand(@height)
        x = rand(@width)
        orientation = rand(2)
      end
    when 1 #horizontal
      if space_horizontal?([x,y],vessel_size)
        place_horizontal([x,y],vessel_size)
        piece_placed = true
      else
        y = rand(@height)
        x = rand(@width)
        orientation = rand(2)
      end
    end
    end

  end

  def loss?
    count == 0
  end


  def display
    graph = "\n"
    f_grid = grid.flatten
    f_grid.each_with_index do |el,i|
      graph += " #{el || "~"} "
      if i % @width == @width - 1
        graph += "\n"
      end
    end
    graph += "\n\n"
    puts graph
  end

  def display_hidden
    graph = "\n"
    f_grid = grid.flatten
    f_grid.each_with_index do |el,i|
      if el == :s
      graph += " ~ "
      else
      graph += " #{el || "~"} "
      end
      if i % @width == @width - 1
        graph += "\n"
      end
    end
    graph += "\n\n"
    puts graph
  end


## Checks
  def space_vertical?(pos,ship_size)
    return false if pos.last + ship_size >= @height
    ship_size.times do |i|
      return false unless empty?([pos.first,pos.last+i])
    end
    true
  end

  def space_horizontal?(pos,ship_size)
    return false if pos.first + ship_size >= @width
    ship_size.times do |i|
      return false unless empty?([pos.first+i,pos.last])
    end
    true
  end

## Places

  def place_vertical(pos,ship_size)
    ship_size.times do |i|
      self[pos.first,pos.last+i] = :s
    end

  end

  def place_horizontal(pos,ship_size)
    ship_size.times do |i|
      self[pos.first+i,pos.last] = :s
    end
  end

end
