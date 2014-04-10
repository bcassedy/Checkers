require 'colorize'
require_relative 'piece.rb'

class InvalidMoveError < StandardError
end

class Board
  attr_reader :board
  def initialize(board = nil)
    @board = board || Array.new(8) { Array.new(8) }
    unless board
      setup_board
    end
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @board[row][col] = piece
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def valid_move_seq?(moves)
    begin
      start_pos = moves[0]
      board_copy = copy_game_state(start_pos)
      board_copy.perform_moves!(moves)
    rescue InvalidMoveError
      return false
    end
    true
  end

  def perform_moves(moves)
    raise InvalidMoveError unless valid_move_seq?(moves)
    perform_moves!(moves) 
  end

  def perform_moves!(moves)
    # need to finish this method
    return if moves.count == 1
      start_pos = moves[0]
      end_pos = moves[1]
      move(start_pos, end_pos)
      perform_moves!(moves[1..-1])
  end

  def won?
    pieces.all? { |piece| piece.color == pieces[0].color }
  end

  def copy_game_state(start_pos)
    #Dup the board and the relevant piece
    board_copy = Board.new(dup)
    piece = board_copy[start_pos]
    new_piece = Piece.new(board_copy, piece.color, piece.pos)
    board_copy
  end


  def dup
    copy = []
    @board.each do |row|
      copy << row.dup
    end
    copy
  end



  def move(start_pos, end_pos)
    piece = self[start_pos]
    if piece.perform_slide(end_pos) || piece.perform_jump(end_pos)
      self[start_pos] = nil
      self[end_pos] = piece
      piece.pos = end_pos
      piece.maybe_promote
    else
      raise InvalidMoveError
    end
  end

  def empty?(pos)
    self[pos].nil?
  end

  def setup_board
    [0,1,2,5,6,7].each do |row_num|
      row_num < 4 ? color = :black : color = :red
      row_num.even? ? to_fill = :odd? : to_fill = :even?
      (0..7).each do |col_num|
        pos = [row_num, col_num]
        self[pos] = Piece.new(self, color, pos) if col_num.send(to_fill)
      end
    end
    nil
  end

  def pieces
    @board.flatten.compact
  end

  def to_s
    next_color = { :green => :white, :white => :green }
    output = "   a b c d e f g h\n "
    cur_color = :green
    @board.each_with_index do |row, row_index|
      cur_color = next_color[cur_color]
      output << "#{8 - row_index} "
      row.each do |space|
        if space.nil?
          output << "  ".colorize(:background => cur_color)
        else
          output << space.display_char.colorize(:color => space.color,
          :background => cur_color)
        end
        cur_color = next_color[cur_color]
      end
      output << "#{8 - row_index}"
      output << "\n "
    end
    output << "  a b c d e f g h\n "
    output
  end

end