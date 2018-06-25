require_relative  "die"
require_relative "game_turn"
require_relative "treasure_trove"
require 'csv'

module StudioGame
class Game
  attr_reader :title
  
  def initialize(title)
    @title = title
    @players = []
  end
  
  def print_scores
    puts "\n#{@title} High Scores\n\n"
    #sorted_players = @players.sort{ |player1, player2| player1.score <=> player2.score}
    #sorted_players.each do|player|
    @players.sort.each do |player|
      puts high_score_entry(player)
    end  
  end

  def print_name_and_health(player)
    player.each do |plyer|
      puts "#{plyer.name} (#{plyer.health})"
    end
  end
  
  def total_points
    @players.reduce(0){ |sum, player| sum + player.points}
  end
  
  def print_stats   
    strong, wimpy = @players.partition{ |player| player.strong? }
      
    puts "#{strong.length} strong players:\n"
    print_name_and_health(strong)
    
    puts "#{wimpy.length} wimpy players:\n"
    print_name_and_health(wimpy)
    
    @players.sort.each do |player|
      puts "#{player.name}'s point totals:\n"      
      player.each_found_treasure do |treasure|
        puts "#{treasure.name} total #{treasure.points} points"
      end  
    puts "TOTAL TREASURE POINTS: #{total_points}"
  end
      
  end
  
  def high_score_entry(player)
   formatted_name = player.name.ljust(20, '.')
   "#{formatted_name}, #{player.score}"
  end
  
  def save_high_scores(to_file="high_scores.txt")
    File.open(to_file, "w") do |file|
        file.puts "#{@title} High Scores:"
        @players.sort.each do |player|      
          file.puts high_score_entry(player)
        end
    end
  end
  
  def load_players(from_file)
    File.readlines(from_file).each do |line|
      add_player(Player.from_csv(line))
    end
  end
    
  def add_player(player)
    @players.push(player)
  end
  
  def play(rounds)
    1.upto(rounds) do |round|
      puts "\nRound Number: #{round}\n"
      puts "\nThere are #{@players.length} players in the game\n"
      treasures = TreasureTrove::TREASURES
      puts "\nThere are #{treasures.size} Treasures to be found\n"
      treasures.each do | treasure |
        puts "A #{treasure.name} is worth #{treasure.points} points"
      end
      
      @players.each do |player|
      GameTurn.take_turn(player)
      puts player  
      end
  end
end
end
end