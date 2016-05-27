require_relative 'board'

class Player
  attr_reader :game_board, :shots_fired, :name

  def initialize(board = Board.new, shots_fired = [], name)
    @game_board = board
    @shots_fired = shots_fired
    @name = name
  end

  def place_all_random
    Board::VESSELS.each do |_s_name, s_size|
      @game_board.place_random_ship(s_size)
    end
  end

  def display_specs
    puts "\n#{@name}"
    @game_board.display
  end

  def random_shot
    shot = [rand(@game_board.width), rand(@game_board.height)]
    while @shots_fired.include?(shot)
      shot = [rand(@game_board.width), rand(@game_board.height)]
    end
    shots_fired << shot
    shot
  end
end

class HumanPlayer < Player
  def initialize(board = Board.new, shots_fired = [], name = 'Human')
    @name = name
    super
  end

  def get_play
    puts 'Pick an attacking location or r for random!'
    user_choice = gets.chomp
    if user_choice == 'r'
      random_shot
    else
      user_choice = user_choice.split(',').map(&:to_i)
      while @user_choices_fired.include?(user_choice)
        puts 'You already chose that shot! Shoot again'
        user_choice = gets.chomp.split(',').map(&:to_i)
      end
      shots_fired << user_choice
      user_choice
    end
  end

  def assign_spot
    Board::VESSELS.each do |ship_name, s_size|
      @game_board.display
      puts "Place #{ship_name} which has #{s_size} spaces"
      puts "Pick a location and its orientation (v or h) or 'r' for random! Example: 0,0,v"
      pos_choice = gets.chomp
      if pos_choice == 'r'
        @game_board.place_random_ship(s_size)
      else
        pos_choice = pos_choice.split(',').map { |e| e =~ /\d+/ ? e.to_i : e }
        if pos_choice.last == 'h'
          puts 'horizontal called'
          redo unless @game_board.space_horizontal?([pos_choice.first, pos_choice[1]], s_size)
          @game_board.place_horizontal([pos_choice.first, pos_choice[1]], s_size)
        else
          redo unless @game_board.space_vertical?([pos_choice.first, pos_choice[1]], s_size)
          @game_board.place_vertical([pos_choice.first, pos_choice[1]], s_size)
        end
      end
    end
    @game_board.display
  end

  def species_prompt
    puts 'Do you want to randomly or manually place ships? (type r or m)'
    u_input = gets.chomp.downcase
    if u_input == 'm'
      assign_spot
    else
      place_all_random
    end
  end
end

class ComputerPlayer < Player
  def initialize(board = Board.new, shots_fired = [], name = 'Computer')
    @name = name
    super
  end

  def get_play
    random_shot
  end

  def species_prompt
    place_all_random
  end
end
