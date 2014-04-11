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

  def initialize(color, board)
    @color = color
    @board = board
  end

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

class ComputerPlayer
  attr_accessor :color, :board

  def initialize(color, board)
    @color = color
    @board = board
    @my_pieces = board.pieces.select { |piece| piece.color == color }
  end

  def play_turn

  end

  def determine_moves
    moves = []
    @my_pieces.each do |piece|
      moves += piece.valid_moves(piece.pos)
    end
    moves
  end
end









