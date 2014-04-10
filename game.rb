require_relative 'board'
require_relative 'players'

class Game

  TURNS = {
      :red => :black,
      :black => :red
    }

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new
    @player1.color, @player1.board = :red, @board
    @player2 = HumanPlayer.new
    @player2.color, @player2.board = :black, @board
  end

  def play
    system 'clear'
    current_player = get_player_by_color(:red)
    puts "Red goes first."
    until won?
      begin
        puts @board
        move_seq = current_player.play_turn
      rescue StandardError => e
        system 'clear'
        puts e
        retry
      end
      if @board.valid_move_seq?(move_seq)
        @board.perform_moves!(move_seq)
        current_player = get_player_by_color(next_turn(current_player.color))
        system 'clear'
      else
        system 'clear'
        puts "Not a valid move sequence!"
        next
      end

    end
    puts @board
    puts "#{current_player.color} wins!"
  end

  def won?
    @board.pieces.all? { |piece| piece.color == @board.pieces[0].color }
  end

  def get_player_by_color(color)
    color == :red ? @player1 : @player2
  end

  def next_turn(color)
    TURNS[color]
  end

end

class HumanPlayer
  attr_accessor :color, :board
  ALPHA_TO_COORD = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }

  X_TO_ROW = {
    -1 => 7,
    -2 => 6,
    -3 => 5,
    -4 => 4,
    -5 => 3,
    -6 => 2,
    -7 => 1,
    -8 => 0
  }

  def play_turn
    puts "#{color} pick a move e.x. a3,b4 :"
    positions = gets.chomp.downcase.split(',').map(&:strip)
    check_input(positions)
    positions.map! { |position| translate_coordinate(position) }
    start_pos = positions[0]
    raise "No piece present at start position" if @board.empty?(start_pos)
    raise "Not your piece!" if @board[start_pos].color != color
    positions
  end

  private
  def translate_coordinate(board_pos)
    col, row = board_pos.split('')
    [X_TO_ROW[row.to_i * -1], ALPHA_TO_COORD[col]]
  end

  def check_input(positions)
    regex = /[a-h][1-8]/
    unless positions.all? { |position| position =~ regex }
      raise "Invalid input! Input must be in the form f2,f3,f4 etc"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
