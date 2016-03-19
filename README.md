# PokerHandMatch

In the card game poker, a hand consists of five cards and are ranked, from lowest to highest, in the following way:

High Card: Highest value card.
One Pair: Two cards of the same value.
Two Pairs: Two different pairs.
Three of a Kind: Three cards of the same value.
Straight: All cards are consecutive values.
Flush: All cards of the same suit.
Full House: Three of a kind and a pair.
Four of a Kind: Four cards of the same value.
Straight Flush: All cards are consecutive values of same suit.
Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.

The cards are valued in the order:
2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace.

See http://www.pokerhands.com/poker_rank_of_hands.html

If two players have the same ranked hands then the rank made up of the highest value wins; for example, a pair of eights beats a pair of fives (see example 1 below). But if two ranks tie, for example, both players have a pair of queens, then highest cards in each hand are compared (see example 2 below); if the highest cards tie then the next highest cards are compared, and so on.

For a complete listing see http://www.pokerhands.com/poker_hand_tie_rules.html

Example	 	Player 1 	 	Player 2	 		Winner
1	 	5H 6S KD 7S 5C 		2C 8S 3S 8D TD		Player 2
		Pair of Fives		Pair of Eights

2	 	8C AC 8H JS 9S 		2C 8S 8D QH 5C		Player 1
		Highest card Ace	Highest card Queen

3	 	2D AS 9C AH AC		3D 7D 6D TD QD		Player 2
		Three Aces			Flush with Diamonds

The file, poker.json, contains one-thousand random hands dealt to two players. 
Each line of the file contains an array, split into two arrays of five strings: the first array for Player 1's cards and the second for Player 2's cards.
You can assume that all hands are valid (no invalid characters or repeated cards), each player's hand is in no specific order, and in each hand there is a clear winner.

How many hands does Player 1 win?
