require 'debugger'

class Piece
  attr_accessor :pos
  attr_reader :color, :board

  SLIDES = {
    :black => { :soldier => [ [1, 1], [1, -1] ],
                :king => [ [1, 1], [1, -1], [-1, 1], [-1, -1] ]
              },
    :red => { :soldier => [ [-1, 1], [-1, -1] ],
              :king => [ [1, 1], [1, -1], [-1, 1], [-1, -1] ]
            }
  }

  JUMPS = {
    :black => { :soldier => [ [2, 2], [2, -2] ],
                :king => [ [2, 2], [2, -2], [-2, 2], [-2, -2] ]
              },
    :red => { :soldier => [ [-2, 2], [-2, -2] ],
              :king => [ [2, 2], [2, -2], [-2, 2], [-2, -2] ]
            }
  }


  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
    @king = false
    @board.add_piece(self, pos)
  end

  def type
    king? ? :king : :soldier
  end

  def slides
    SLIDES[color][type]
  end

  def promote_row
    black? ? 7 : 0
  end

  def black?
    color == :black
  end

  def red?
    color == :red
  end

  def perform_slide(pos)
    @board.empty?(pos) && move_difs.include?(pos_dif(pos))
  end

  def perform_jump(pos)
    return false unless valid_jump?(pos)
    jumped_space = jumped_space(self.pos, pos)
    unless @board.empty?(jumped_space) || 
                                @board[jumped_space].color == self.color
      @board[jumped_space] = nil
      true
    else
      false
    end
  end

  def valid_jump?(pos)
    difference = pos_dif(pos)
    @board.empty?(pos) && possible_jumps.include?(difference)
  end

  def jumped_space(start_pos, end_pos)
    dif_to_jumped_piece = pos_dif(end_pos).map { |coord| coord / 2 }
    [start_pos[0] + dif_to_jumped_piece[0], start_pos[1] + dif_to_jumped_piece[1]]
  end

  def possible_jumps
    JUMPS[self.color][self.type]
  end

  def move_difs
    SLIDES[self.color][self.type]
  end

  def pos_dif(pos)
    #returns the difference between the start position and end position
    [pos[0] - self.pos[0], pos[1] - self.pos[1]]
  end

  def king?
    @king
  end

  def maybe_promote
    promote if self.pos[0] == promote_row
  end

  def promote
    @king = true
  end

  def display_char
    'O '
  end
end