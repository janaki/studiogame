require_relative "player"
require_relative "die"
require_relative "treasure_trove"
require_relative "loaded_die"

module StudioGame
module GameTurn

  def self.take_turn(player)
    die = LoadedDie.new
    number_rolled = die.roll
    case number_rolled
    when 1..2
      puts "#{player.name} got BLAMMED!"
      player.blam
    when  3..4
      puts "#{player.name} is skipped"   
    else
      player.w00t
    end
    
    treasure = TreasureTrove.random
    player.found_treasure(treasure)
  end
  
end
end