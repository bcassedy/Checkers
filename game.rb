class Game

end

class HumanPlayer
  class HumanPlayer
  attr_accessor :board
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

  def play_turn(color)
    puts "#{color} pick a move e.x. f2,f4 :"
    start_pos, end_pos = gets.chomp.downcase.split(',')
    check_input(start_pos, end_pos)
    start_pos = translate_coordinate(start_pos)
    raise "No piece present at start position" if @board[start_pos].nil?
    raise "Not your piece!" if @board[start_pos].color != color
    end_pos = translate_coordinate(end_pos)
    [start_pos, end_pos]
  end

  private
  def translate_coordinate(board_pos)
    col, row = board_pos.split('')
    [X_TO_ROW[row.to_i * -1], ALPHA_TO_COORD[col]]
  end

  def check_input(start_pos, end_pos)
    regex = /[a-h][1-8]/
    unless start_pos =~ regex && end_pos =~ regex
      raise "Invalid input! Input must be in the form f2,f3"
    end
  end

end
end
