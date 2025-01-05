# frozen_string_literal: true

require_relative 'piece'

class Bishop < Piece
  def symbol
    if white?
      '♗'
    else
      '♟'
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

  def can_run?
    true
  end
end
