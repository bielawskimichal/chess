# frozen_string_literal: true

require 'colorize'

class Piece
  def initialize(color)
    @color = color
  end

  attr_reader :color

  def to_s
    symbol
  end

  def symbol
    if white?
      '♙'
    else
      '♟'
    end
  end

  # Returns true if a piece can be captured. Should be false for king.
  def capturable?
    true
  end

  # Returns false if piece can't jump over other pieces.
  def can_jump?
    false
  end

  # Returns false if piece can't go more than one position at once.
  def can_run?
    false
  end

  def white?
    return true if @color == 'white'

    false
  end

  def black?
    return true if @color == 'black'

    false
  end

  def possible_moves
    if white?
      [[1, 0]]
    else
      [[-1, 0]]
    end
  end
end
