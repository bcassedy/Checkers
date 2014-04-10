class Piece
  attr_accessor :pos
  attr_reader :color

  def initialize(color, pos)
    @color = color
    @pos = pos
    @king = false
  end

  def king?
    @king
  end

  def promote
    @king = true
  end
  
end