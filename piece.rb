# encode: utf-8

require 'debugger'

class Piece
  attr_accessor :pos
  attr_reader :color, :board, :king

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


  def initialize(board, color, pos, king = false)
    @board = board
    @color = color
    @pos = pos
    @king = king
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
    @board.empty?(pos) && possible_slides.include?(pos_dif(pos))
  end

  def perform_jump(pos)
    jumped_space = jumped_space(self.pos, pos)
    return false unless valid_jump?(jumped_space, pos)
    @board[jumped_space] = nil
    true
  end

  def valid_moves(start_pos)
    valid_slides(start_pos) + valid_jumps(start_pos)
  end

  def valid_slides(start_pos)
    end_positions = []
    possible_slides.each do |slide| 
      #debugger
      end_pos = start_pos.zip(slide).map do |coords|
        coords.inject(:+)
      end
      end_positions << end_pos if perform_slide(end_pos) 
    end
    end_positions
  end

  def valid_jumps(start_pos)
    moves = []
    get_jump_positions.each do |jump_pos|
      if valid_jump?(jumped_space(self.pos, jump_pos), jump_pos)
        moves << jump_pos
      end
    end
    moves
  end

  def get_jump_positions
    jump_positions = []
    possible_jumps.each do |jump_dif|
      jump_positions << self.pos.zip(jump_dif).map do |coords|
        coords.inject(:+)
      end
    end
    jump_positions
  end

  def valid_jump?(jumped_space, pos)
    difference = pos_dif(pos)
    @board.empty?(pos) && possible_jumps.include?(difference) && 
        !@board.empty?(jumped_space) && @board[jumped_space].color != self.color
  end

  def jumped_space(start_pos, end_pos)
    dif_to_jumped_piece = pos_dif(end_pos).map { |coord| coord / 2 }
    [start_pos[0] + dif_to_jumped_piece[0], start_pos[1] + dif_to_jumped_piece[1]]
  end

  def possible_jumps
    JUMPS[self.color][self.type]
  end

  def possible_slides
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
    if self.pos[0] == promote_row
      self.promote 
    end
  end

  def promote
    @king = true
  end

  def display_char
    king? ? "\u26C3" : "\u26C2 "
  end
end