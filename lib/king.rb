# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  def symbol
    if white?
      '♔'
    else
      '♚'
    end
  end

  def possible_moves
    [[1, 0],
     [0, 1],
     [-1, 0],
     [0, -1],
     [1, 1],
     [1, -1],
     [-1, 1],
     [-1, -1]]
  end

  def capturable?
    false
  end
end
