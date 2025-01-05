# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

class Game
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def play
    setup_board
    print_board
  end

  def print_board
    vertical_divider = ' | '
    horizontal_divider = '   +---+---+---+---+---+---+---+---+'
    files = "     A   B   C   D   E   F   G   H"
    row_nb = 9


    position_for_display = ->(position) { position || ' ' }

    row_for_display = ->(row) { " #{row_nb} | " + row.map(&position_for_display).join(vertical_divider) + " | #{row_nb}" }
    rows_for_display = @board.reverse.map do |row|
      row_nb -= 1
      row_for_display.call(row)
    end
    puts "\n\n" + # rubocop:disable Style/StringConcatenation
        files + # rubocop:disable Layout/MultilineOperationIndentation
        "\n" + # rubocop:disable Layout/MultilineOperationIndentation
        horizontal_divider + # rubocop:disable Layout/MultilineOperationIndentation
        "\n" + # rubocop:disable Layout/MultilineOperationIndentation
        rows_for_display.join("\n#{horizontal_divider}\n") + # rubocop:disable Layout/MultilineOperationIndentation
        "\n" + # rubocop:disable Layout/MultilineOperationIndentation
        horizontal_divider + # rubocop:disable Layout/MultilineOperationIndentation
        "\n" + # rubocop:disable Layout/MultilineOperationIndentation
        files # rubocop:disable Layout/MultilineOperationIndentation
  end

  def setup_board
    setup_whites
    setup_blacks
  end

  def setup_whites
    col = 'white'
    @board[0][0] = Rook.new(col)
    @board[0][1] = Knight.new(col)
    @board[0][2] = Bishop.new(col)
    @board[0][3] = Queen.new(col)
    @board[0][4] = King.new(col)
    @board[0][5] = Bishop.new(col)
    @board[0][6] = Knight.new(col)
    @board[0][7] = Rook.new(col)

    @board[1].each_with_index { |_position, index| @board[1][index] = Pawn.new(col) }
  end

  def setup_blacks
    col = 'black'
    @board[7][0] = Rook.new(col)
    @board[7][1] = Knight.new(col)
    @board[7][2] = Bishop.new(col)
    @board[7][3] = Queen.new(col)
    @board[7][4] = King.new(col)
    @board[7][5] = Bishop.new(col)
    @board[7][6] = Knight.new(col)
    @board[7][7] = Rook.new(col)

    @board[6].each_with_index { |_position, index| @board[6][index] = Pawn.new(col) }
  end
end
