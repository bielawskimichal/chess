# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

require 'colorize'

class Game
  def initialize
    @board = Array.new(8) { Array.new(8) }
    @turn = 0
  end

  def play
    welcome_message
    setup_board

    loop do
      switch_turn
      print_board
      attempt_to_move
    end
  end

  def attempt_to_move
    loop do
      print_whose_turn
      piece_to_move = gets.chomp!
      ask_for_destination
      destination = gets.chomp!
      return [piece_to_move, destination] if move_possible?(piece_to_move, destination)

      next
    end
  end

  def print_whose_turn
    puts "#{current_player} move. Type in which piece you want to move, for example: 1A."
  end

  def ask_for_destination
    puts 'Type in the destination.'
  end

  def move_possible?(from, to)
    unless input_correct?(from, to)
      puts 'Please try again. The location of a piece and destination, where you want to move has to be in a following form: number of row followed by letter corresponding with a column.' # rubocop:disable Layout/LineLength
      return false
    end

    from = decode_input(from)

    unless correct_color?(from)
      puts "The chosen piece does'nt belong to you. Please try again."
      return false
    end

    to = decode_input(to)

    if from == to
      puts "You can't move a piece to the same spot ;)"
      return false
    end

    unless not_empty?(from)
      puts 'There is no piece in the given spot. Please try again.'
      return false
    end

    unless is_empty?(to)
      x, y = to
      if @board[x][y].is_a?(Pawn)
        puts "Pawn can't beat in a straight line!"
        return false

        elsif! @board[x][y].capturable?
        puts "Oh that's brave but unfortunately one can't capture a king."
        return false

      elsif @board[x][y].white? && current_player == 'WHITES'
        puts "You can't attack yourself!"
        return false
      elsif @board[x][y].black? && current_player == 'BLACKS'
        puts "You can't attack yourself!"
        return false
      end

    end

    unless move_possible_for_piece?(from, to)
      puts 'This move is not possible for this piece.'
      return false
    end

    true
  end

  def move_possible_for_piece?(from, to)
    x, y = from
    dx, dy = to
    piece = @board[x][y]

    cx = dx - x
    cy = dy - y

    if piece.can_run?
      cx.zero? ? cy /= cy : cy
      cy.zero? ? cx /= cx : cx
    end

    check = [cx, cy]
    return true if piece.possible_moves.include?(check)

    false
  end

  def is_empty?(cell)
    x, y = cell
    if @board[x][y].nil?
      true
    else
      false
    end
  end

  def not_empty?(cell)
    x, y = cell
    if !@board[x][y].nil?
      true
    else
      false
    end
  end

  def correct_color?(from)
    x, y = from
    if current_player == 'WHITES' && !@board[x][y].white?
      false
    elsif current_player == 'BLACKS' && !@board[x][y].black?
      false
    else
      true
    end
  end

  def input_correct?(from, to)
    pattern = /\A[1-8][a-h]\z/i

    return true if pattern.match(from) && pattern.match(to)

    false
  end

  def decode_input(input)
    input = input.split('')
    input[0] = input[0].to_i - 1
    input[1] = input[1].downcase.ord - 97
    input
  end

  def current_player
    if @turn.odd?
      'WHITES'
    else
      'BLACKS'
    end
  end

  def ask_for_player_input
    gets.chomp!
  end

  def switch_turn
    @turn += 1
  end

  def print_board
    vertical_divider = ' | '.yellow
    horizontal_divider = '   +---+---+---+---+---+---+---+---+'.yellow
    files = '     A   B   C   D   E   F   G   H'.yellow
    row_nb = 9

    position_for_display = ->(position) { position || ' ' }

    row_for_display = lambda { |row|
      " #{row_nb} | ".yellow + row.map(&position_for_display).join(vertical_divider) + " | #{row_nb}".yellow
    }
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

  def welcome_message
    print "\n\n\n        --------+--+-----+-----\n"
    print '         WELCOME '.red + 'TO '.yellow + 'CHESS '.green + "GAME\n".blue
    print "        --------+--+-----+-----\n\n"
    print '            --'.yellow + "LET\'s" + '-'.yellow + 'PLAY' + "--\n\n".yellow # rubocop:disable Style/StringConcatenation
  end

  def setup_board
    setup
    setup(7)
  end

  def setup(color = 0)
    col = color.zero? ? 'white' : 'black'
    @board[color] = [
      Rook.new(col),
      Knight.new(col),
      Bishop.new(col),
      Queen.new(col),
      King.new(col),
      Bishop.new(col),
      Knight.new(col),
      Rook.new(col)
    ]

    @board[1].each_with_index { |_position, index| @board[1][index] = Pawn.new(col) } if color.zero?
    @board[6].each_with_index { |_position, index| @board[6][index] = Pawn.new(col) } unless color.zero?
  end
end
