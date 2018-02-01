 #Blackjack OO -- fifth commit

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  SUITS = ['H', 'D', 'S', 'C']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize
    @cards = []
  end

  def shuffle
    @cards = []
    CARDS.each do |card|
      SUITS.each do |suit|
        @cards << Card.new(suit, card)
      end
    end

    @cards = @cards.shuffle!
  end
end

module Hand

  def hand(person, cards)
    puts "\n#{person}'s hand is:\n"
    cards.each do|card|
      puts card
    end
  end

  def total(cards)
    add_values = cards.map{|card| card.value }
    total = 0
      add_values.each do |value|
          if value == "A"
        total += 11
          elsif value.to_i == 0 # J, Q, K
        total += 10
          else
        total += value.to_i
        end
      end
    #correct for Aces
    add_values.select{|card| card == "A"}.count.times do
        total -= 10 if total > 21
      end
    total
    end
  end

class Participant
  attr_accessor :name, :cards

  include Hand

  def initialize(name = nil)
    @name = name
    @cards = []
  end
end

class Player < Participant

end

class Dealer < Participant

  def first_hand(cards)
    puts "First card is hidden."
    puts "Second card is #{cards[1]}\n\n"
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :player_hand, :dealer_hand

  def initialize
    @deck = Deck.new
    @player_hand = []
    @dealer_hand = []
  end

  def new_game
    puts "Play again? (Y/N)"
    answer = gets.chomp.upcase
    answer == "Y" ? restart_game : exit
  end

  def blackjack
    player_total = player.total(@player_hand)
    dealer_total = dealer.total(@dealer_hand)
    puts "\n#{player.name}'s total is #{player.total(@player_hand)}."
      if (player_total == 21) && (dealer_total == 21)
        puts "It's a tie with two blackjacks!"
        new_game
      elsif player_total == 21
        puts "\n#{player.name} wins w    @player = Player.new(player.name)ith blackjack!"
        dealer.hand(dealer.name, @dealer_hand)
        puts "\nDealer's total is #{dealer.total(@dealer_hand)}.\n"
        new_game
      elsif dealer_total == 21
        dealer.hand(dealer.name, @dealer_hand)
        puts "\nDealer wins with blackjack!"
        new_game
      end
    nil
  end

  def start_game
    puts "Welcome to a new round of Blackjack!\n"
    puts "What is Player's name?"
    @player = Player.new
    @player.name = gets.chomp
    @dealer = Dealer.new("Dealer")
    puts "\n\nWelcome #{player.name}!\n\n"
  end

  def player_deal
    @deck=@deck.shuffle
    @player_hand = @deck.pop(2)
    player.hand(player.name, @player_hand)
  end

  def dealer_deal
    @dealer_hand = @deck.pop(2)
    puts "\n\n#{dealer.name}'s hand is:\n"
    dealer.first_hand(@dealer_hand)
  end

  def player_turn
    loop do
      puts "Hit or stand? (H/S)"
      decide = gets.chomp.upcase
      if decide == "H"
        puts "#{player.name} hits.\n\n"
        @player_hand << @deck.pop
        player.hand(player.name, @player_hand)
        total=player.total(@player_hand)
        puts "\n#{player.name}'s total is #{player.total(@player_hand)}.\n"
          if total > 21
            puts "#{player.name} went bust."
            new_game
          end
      else
        puts "\n#{player.name} stands with #{player.total(@player_hand)}.\n\n"
        break
      end
    end
  end

  def dealer_turn
    total = dealer.total(@dealer_hand)
    dealer.hand("Dealer", @dealer_hand)
    puts "\nDealer's total is #{dealer.total(@dealer_hand)}.\n"
    loop do
      if total < 17
        puts "Dealer hits.\n\n"
        @dealer_hand << @deck.pop
        dealer.hand(dealer.name, @dealer_hand)
        total=dealer.total(@dealer_hand)
        puts "\n#{dealer.name}'s' total is #{dealer.total(@dealer_hand)}.\n"
          if total > 21
            puts "#{dealer.name} went bust."
            new_game
          end
      else
        puts "\n#{dealer.name} stands with #{total}.\n"
        break
      end
    end
  end

  def winner
    win = player.total(@player_hand)<=>dealer.total(@dealer_hand)
      if win == 0
        puts "It's a tie."
      elsif win == 1
        puts "#{player.name} wins."
      else
        puts "#{dealer.name} wins"
      end
    new_game
  end

  def play
    player_deal
    dealer_deal
    blackjack
    player_turn
    dealer_turn
    winner
  end

  def play_again
    puts "Welcome to a new round of Blackjack!\n\n"
    restart_game

  end

  def first_play
    start_game
    play
  end

  def restart_game
    @deck = Deck.new
    @player_hand = []
    @dealer_hand = []
    play
  end
end

Game.new.first_play
