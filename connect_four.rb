# connect four game
# played in the console

class Player
  @@player_num = 1
  attr_reader :name, :symbol
  def initialize(name)
    @name = name
    @symbol = get_symbol
    @player_num = @@player_num
    @@player_num += 1
  end

  def get_symbol
    symbols = ["\e[31m\u263a\e[0m", "\e[34m\u263b\e[0m"]
    @@player_num == 1 ? symbol = symbols[0] : symbol = symbols[1]
    symbol
  end
end

class Space
  attr_accessor :symbol
  def initialize(symbol = ' ')
    @symbol = symbol
  end
end

class Column 
  attr_reader :col_num
  attr_accessor :spaces
  def initialize(col_num, spaces = [])
    @col_num = col_num
    @spaces = spaces
  end

  def check_space(player)
    @spaces.each do |space| 
      if space.symbol == ' '
        space.symbol = player.symbol
        break
      end
    end
  end
end

class Game 
  attr_reader :board, :players
  def initialize()
    @board = create_board
    introduction
    @players = get_players
    @turns = 0
  end

  def get_players
    players = []
    player_num = 1
    2.times do
      p "Player #{player_num}, what is your name?"
      name = gets.chomp
      players.push(Player.new(name))
      puts "Your symbol is: #{players[player_num - 1].symbol}\n\n"
      player_num += 1
    end
    return players
  end

  def create_board
    board = []
    col_num = 1
    4.times do
      board.push(Column.new(col_num))
      col_num += 1
    end
    board.each_index { |i| 4.times { board[i].spaces.push(Space.new) } }
  end
  
  def display_board
    puts "\n"
    temp_board = @board.map { |col| col.spaces.reverse }
    temp_board.each_index do |i| # row index
      row = "|"
      temp_board.each_index do |j| # column index
        row += " #{temp_board[j][i].symbol} |"
      end
      puts row
      puts "_________________\n\n"
    end
    puts "  1   2   3   4\n\n"
  end

  def winner?
    check_columns? || check_rows? || check_diagonals? ? true : false
  end

  def check_columns?
    @board.each do |column|
      column_symbols = []
      column.spaces.each { |space| column_symbols.push(space.symbol) }
      return true if column_symbols.uniq.length == 1 && column_symbols.uniq[0] != ' '
    end
    return false
  end

  def check_rows?
    @board.each_index do |i| # row index
      row = []
      @board.each_index do |j| # column index
        row.push(@board[j].spaces[i].symbol)
      end
      return true if row.uniq.length == 1 && row.uniq[0] != ' '
    end
    return false
  end

  def check_diagonals?
    diagonal = []
    @board.each_index { |i| diagonal.push(@board[i].spaces[i].symbol) }
    return true if diagonal.uniq.length == 1 && diagonal.uniq[0] != ' '
    return true if
      @board[0].spaces[3].symbol == @board[1].spaces[2].symbol &&
      @board[0].spaces[3].symbol == @board[2].spaces[1].symbol &&
      @board[0].spaces[3].symbol == @board[3].spaces[0].symbol &&
      @board[0].spaces[3].symbol != ' '
    return false
  end

  def introduction
    puts "\n\nLet's play Connect Four!\n\n"
    sleep 1
    self.display_board
    sleep 1
  end

  def update_board(player, move)
    @board[move].check_space(player)
  end

  def draw?
    return true if @turns == 16 && !winner?
  end

  def winner_message(player)
    puts "#{player.name} wins!"
  end

  def draw_message(player)
    puts "The game was a draw, nobody wins."
  end

  def switch_player(player)
    player == @players[0] ? player = @players[1] : player = @players[0]
    return player
  end

  def play
    player = @players.shuffle[0]
    puts "#{player.name} will go first!"
    until winner? || draw?
      move = Turn.new(@board, player).move - 1
      update_board(player, move)
      self.display_board
      @turns += 1
      player = switch_player(player)
    end
    player = switch_player(player)
    winner? ? winner_message(player) : draw_message(player)
  end
end

class Turn
  attr_reader :board, :player, :move
  def initialize(board, player)
    @board = board
    @player = player
    @move = get_move
  end

  def check_move(column)
    symbols = []
    @board[column].spaces.each do |space|
      symbols.push(space.symbol)
    end
    symbols.include?(' ') ? true : false
  end

  def get_move
    puts "#{player.name}, which column do you choose for your move?"
    column = gets.chomp until
      check_move(column.to_i - 1) &&
      column == '1' ||
      column == '2' ||
      column == '3' ||
      column == '4'
    return column.to_i
  end
end

Game.new.play
