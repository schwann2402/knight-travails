class Knight
  attr_reader :position
  attr_accessor :children, :parent

  MOVES = [[1, 2], [2, 1], [-1, -2], [-2, -1], [1, -2], [-1, 2], [2, -1], [-2, 1]].freeze

  def initialize(position, parent = nil)
    @position = position
    @children = []
    @parent = parent
  end

  def next_moves
    next_moves = MOVES.map do |move|
      move.each_with_index.map { |n, i| n + @position[i] unless (n + @position[i]).negative? || (n + @position[i]) > 7 }
    end
    next_moves.delete_if { |move| move.include?(nil) }
  end
end

# Frozen_string_literal: true

require_relative 'knight'

# Class defining the chessboard
class ChessBoard
  def initialize
    # @board = Array.new(8) { Array.new(8, nil) }
  end

  def knight_moves(start, destination)
    current = make_tree(start, destination)
    history = []
    make_history(current, history, start) #make_history([1,2], [], [0,0])
    print_knight_moves(history, start, destination)
  end

  private

  def make_tree(start, destination)   #destino [4,3]
    queue = [Knight.new(start)] # 
    current = queue.shift #current = [4,5], queue = [[5,4], [2,1], [1,2], [4,1], [3,5], [5,2], [1,4]]
    until current.position == destination
      current.next_moves.each do |move| #[5,7], [6,4], [3,5], [2,4] --> su papa es [4,5],    [4,3] su papa es [2,4], el papa de [4,5] es [3,3]
        current.children << knight = Knight.new(move, current)
        queue << knight  # queue = [[4,5], [5,4], [2,1], [1,2], [4,1], [3,5], [5,2], [1,4]]
      end
      current = queue.shift
    end
    current
  end

  def make_history(current, history, start) #([4,3])
    until current.position == start
      history << current.position #([4,3], [2,4], [4,5], [3,3])
      current = current.parent
    end
    history << current.position
  end

  def print_knight_moves(history, start, destination)
    puts "You made it in #{history.size - 1} moves!" #3 moves
    puts "To get from #{start} to #{destination} you must traverse the following path:"
    history.reverse.each { |move| puts move.to_s } #([[3,3], [4,5], [2,4], [4,3]])
  end
end

require_relative 'chess_board'

game = ChessBoard.new

game.knight_moves([0, 0], [3, 3])
puts ''

game.knight_moves([3, 3], [0, 0])
puts ''

game.knight_moves([3, 3], [4, 3])
puts ''