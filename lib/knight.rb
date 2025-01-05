# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  def symbol
    if white?
      '♘'
    else
      '♞'
    end
  end

  def possible_moves
    [[2, 1],
     [1, 2],
     [-2, 1],
     [1, -2],
     [-1, 2],
     [2, -1],
     [-2, -1],
     [-1, -2]]
  end

  def can_jump?
    true
  end
end
