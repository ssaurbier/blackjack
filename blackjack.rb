#!/usr/bin/env ruby
require 'pry'
# YOUR CODE HERE
class Card
#Use to represent an individual playing card.
#This class should contain the suit and the value
# provide methods for determining what type of card it is (e.g. face card or ace).
  attr_reader :rank, :suit
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ace
    rank == 'A'
  end

  def face_card
    rank == 'J' || rank =='Q' || rank == 'K'
  end

  def to_s
    "#{suit}#{rank}#{suit}"
  end
end

class Deck
  # represent a collection of 52 cards.
  # When dealing a hand this class can be used to supply the Card objects.
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  SUITS = ['♥', '♠', '♦', '♣']

  def initialize
    @cards = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
    @cards.shuffle!
  end

  def draw
    @cards.pop
  end
end

class Hand
#represent the player's and dealer's hand.
#This class will need to determine the best score based on the cards that have been dealt.
  def initialize
    @cards = []
  end

  def hit(card)
    @cards << card
  end

  def score
    total = 0
    has_ace = false

    @cards.each do |card|
      if card.ace
        total += 1
        has_ace = true
      elsif card.face_card
        total += 10
      else
        total += card.rank.to_i
      end
    end
    if total <= 11 && has_ace
      total += 10
    end
    total
  end

  def busted
    score > 21
  end

  def to_s
    @cards.join(", ")
  end
end


# _______________________________________________
# Functionality
# _______________________________________________


puts "\n Dealing you in: \n \n"

def deal(deck, hand, name)
  card = deck.draw
  hand.hit(card)
  puts "#{name} drew #{card}"
end

def show_hand(hand, name)
  puts "#{name}'s hand: #{hand}"
  puts "#{name}'s score: #{hand.score}"
end


deck = Deck.new
player_hand = Hand.new
dealer_hand = Hand.new

2.times do
  deal(deck, player_hand, "Player")
end

deal(deck, dealer_hand, "Dealer")
show_hand(player_hand, "Player")

puts "Hit or stand (choose H or S): "
input = gets.chomp.upcase
while input != 'S'
  if input == "H"
    deal(deck, player_hand, "Player")
    show_hand(player_hand, "Player")

    if player_hand.busted
      puts "BUST! You've lost the hand."
      exit 0
    end

  else
    "Please just follow the directions. H or S."
  end
  puts "Hit or stand (choose H or S): "
  input = gets.chomp.upcase
end

deal(deck, dealer_hand, "Dealer")
show_hand(dealer_hand, "Dealer")

while dealer_hand.score < 17
  deal(deck, dealer_hand, "Dealer")
  show_hand(dealer_hand, "Dealer")

  if dealer_hand.busted
    puts "Dealer busted! You win."
    exit 0
  end
end

if player_hand.score > dealer_hand.score
  puts "Player wins!"
elsif dealer_hand.score > player_hand.score
  puts "Dealer wins."
else
  puts "tie"
end
