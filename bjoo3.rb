#Blackjack OO -- fourth commit

class Card
  attr_accessor :suit, :cvalue
    
  def initialize
    @suit = suit
    @cvalue = cvalue
  end
  
  #def extract(cards)
  #  cards.each do|card|
  #    return card[0]
  #  end
  #end
end
                  
class Deck
  attr_accessor :cards
  
  SUITS = ['H', 'D', 'S', 'C']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  
  def initialize
    @cards = []
    @card = Card.new
  end
  
  def shuffle
    @cards = CARDS.product(SUITS)
    @cards = @cards.shuffle! 
  end
end

module Hand
  
  def hand(person, cards)
    puts "\n#{person}'s hand is:\n"
    #puts "#{card.extract(cards)}"
    cards.each do|card|
    puts "#{card[0]} of #{card[1]}"
    end
  end

  def total(cards)
    arr = cards.map{|e| e[0] }
    total = 0
      arr.each do |value|
        if value == "A"
        total += 11
        elsif value.to_i == 0 # J, Q, K
        total += 10
        else
        total += value.to_i
        end
      end
    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
      total -= 10 if total > 21
      end
    total
    end
  end

class Player
  attr_accessor :name, :cards, :card
  
  include Hand

  def initialize(n)
    @name = n
    @cards = [] 
    @card = Card.new 
  end    
end

class Dealer
  attr_accessor :name, :cards
  
  include Hand

  def initialize
    @name = "Dealer"
    @cards = []
  end
  
  def first_hand(cards)
    puts "First card is hidden."
    puts "Second card is #{cards[1][0]} of #{cards[1][1]}\n\n"
    end
end

class Game
  attr_accessor :deck, :player, :dealer, :p_hand, :d_hand
  
  def initialize
    @deck = Deck.new
    @player = Player.new("Player 1")
    @dealer = Dealer.new
    @p_hand = []
    @d_hand = []
  end

  def new_game
    puts "Play again? (Y/N)"
    y=gets.chomp.upcase
    y == "Y" ? Game.new.play : exit
  end
  
  def blackjack
    player_total = player.total(@p_hand)
    dealer_total = dealer.total(@d_hand)
    puts "\n#{player.name}'s total is #{player.total(@p_hand)}."
      if (player_total == 21) && (dealer_total == 21) 
        puts "It's a tie with two blackjacks!"
        new_game
      elsif player_total == 21 
        puts "\n#{player.name} wins with blackjack!"
        dealer.hand("Dealer", @d_hand)
        puts "\nDealer's total is #{dealer.total(@d_hand)}.\n"
        new_game
      elsif dealer_total == 21
        dealer.hand("Dealer", @d_hand)
        puts "\nDealer wins with blackjack!"
        new_game
      end
    nil
  end
  
  def start_game
    puts "Welcome to a new round of Blackjack!\n"
    puts "What is Player's name?"
    player.name = gets.chomp
    puts "\n\nWelcome #{player.name}!\n\n"
  end

  def player_deal
    @deck=@deck.shuffle
    @p_hand = @deck.pop(2)
    player.hand(player.name, @p_hand)
  end
  
  def dealer_deal
    @d_hand = @deck.pop(2)
    puts "\n\nDealer's hand is:\n"
    dealer.first_hand(@d_hand)
  end
   
  def player_turn
    loop do
      puts "Hit or stand? (H/S)"
      x=gets.chomp.upcase
      if x == "H"
        puts "#{player.name} hits.\n\n"
        @p_hand << @deck.pop
        player.hand(player.name, @p_hand)
        total=player.total(@p_hand)
        puts "\n#{player.name}'s total is #{player.total(@p_hand)}.\n"
          if total > 21
            puts "#{player.name} went bust."
            new_game
          end
      else 
        puts "\n#{player.name} stands with #{player.total(@p_hand)}.\n\n"
        break
      end 
    end
  end
  
  def dealer_turn
    total=dealer.total(@d_hand)
    dealer.hand("Dealer", @d_hand)
    puts "\nDealer's total is #{dealer.total(@d_hand)}.\n"
    loop do
      if total < 17
        puts "Dealer hits.\n\n"
        @d_hand << @deck.pop
        dealer.hand("Dealer", @d_hand)
        total=dealer.total(@d_hand)
        puts "\nDealer's total is #{dealer.total(@d_hand)}.\n"
          if total > 21
            puts "Dealer went bust."
            new_game
          end
      else
        puts "\nDealer stands with #{total}.\n"
        break
      end
    end
  end
    
  def winner
    x= player.total(@p_hand)<=>dealer.total(@d_hand)
      if x == 0 
        puts "It's a tie."
      elsif x == 1 
        puts "#{player.name} wins."
      else 
        puts "Dealer wins"
      end
    new_game
  end
    
  def play
    puts "Welcome to a new round of Blackjack!\n\n"
    player_deal
    dealer_deal
    blackjack
    player_turn
    dealer_turn
    winner  
  end 

  def first_play
    start_game
    player_deal
    dealer_deal
    blackjack
    player_turn
    dealer_turn
    winner  
  end
end

Game.new.first_play 
  
