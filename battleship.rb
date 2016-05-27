require_relative "board"
require_relative "player"



class BattleshipGame
  attr_reader :player_one, :player_two

  def initialize(player_one = HumanPlayer.new, player_two = ComputerPlayer.new)
    @player_one = player_one
    @player_two = player_two
    @main_player = @player_one
    @other_player = @player_two
  end

  def switch_player
    if @main_player == @player_one
      @main_player, @other_player = @player_two, @player_one
    else
      @main_player, @other_player = @player_one, @player_two
    end
  end

  def attack(position)
    if @other_player.game_board.empty?(position)
      @other_player.game_board[position.first,position.last] = :o
    else
      @other_player.game_board[position.first,position.last] = :x
    end
  end

  def play_turn
    puts "\n#{@main_player.name}"
    @main_player.game_board.display
    puts "\n#{@other_player.name}"
    @other_player.game_board.display_hidden
    attack(@main_player.get_play)
    switch_player
  end

  def game_over?
    @player_one.game_board.loss? || @player_two.game_board.loss?
  end

## Functionality
  def play

    @player_one.species_prompt
    @player_two.species_prompt

    until game_over?
      play_turn
    end

    puts @player_one.game_board.loss? ? "#{@player_two.name} wins!" : "#{@player_one.name} wins!"

  end


end


if __FILE__ == $PROGRAM_NAME
  BattleshipGame.new.play
end
