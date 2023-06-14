# frozen_string_literal: true

class Board
  attr_accessor :fields, :index, :win_patterns
  attr_reader :interlines

  def initialize
    @fields = (1..9).to_a
    @interlines = "\t---+---+---\n"
    @index = -1
    @win_patterns = [[1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 7], [7, 8, 9], [4, 5, 6], [1, 2, 3], [7, 5, 3]]
  end

  def place_piece(piece, field)
    fields[field] = piece
  end

  def display
    puts "\n#{value_line}#{interlines}#{value_line}#{interlines}#{value_line}\n"
    self.index = -1
  end

  private

  def value
    self.index += 1
    fields[self.index]
  end

  def value_line
    "\t #{value} | #{value} | #{value}\n"
  end
end

class Player
  attr_accessor :taken_fields, :piece, :name

  def initialize(name, piece)
    @taken_fields = []
    @name = name
    @piece = piece
  end

  def move(game_board)
    game_board.display
    puts "#{name}! It's your turn. Where do you want to place your piece?:\n"
    loop do
      field = gets.chomp.to_i
      if game_board.fields.any?(field)
        taken_fields.push(field)
        game_board.fields[field - 1] = piece
        break
      else
        puts "Your answer isn't valid or the field is taken already! Please retry!:"
      end
    end
  end

  def win?(game_board)
    game_board.win_patterns.any? do |pattern|
      (pattern - taken_fields).empty?
    end
  end
end

module Game
  def self.new_board
    Board.new
  end

  def self.restart
    puts "\n\n\n\n\n\n\n\nGame will restart\n"
    start
  end

  def self.create(player_number, piece)
    puts "What is your name #{player_number}?"
    player_name = gets.chomp
    puts "Welcome #{player_name}.\nYou will be playing the #{piece}'s.\n\n"
    Player.new(player_name, piece)
  end

  def self.tie?(game_board, player, opponent)
    game_board.win_patterns.all? do |pattern|
      pattern_values = pattern.map { |value| game_board.fields[value - 1] }
      pattern_values.any?(player.piece) && pattern_values.any?(opponent.piece)
    end
  end

  def self.over?(player, opponent, game_board)
    if player.win?(game_board)
      puts "#{player.name} won the game!"
      true
    elsif Game.tie?(game_board, player, opponent)
      puts 'Tie! No one won.'
      true
    else
      false
    end
  end

  def self.start
    game_board = Game.new_board
    puts 'Welcome to TicTacToe!'
    player1 = Game.create('player 1', 'X')
    player2 = Game.create('player 2', 'O')

    loop do
      player1.move(game_board)
      break if Game.over?(player1, player2, game_board)

      player2.move(game_board)
      break if Game.over?(player2, player1, game_board)
    end

    restart
  end
end


Game.start
