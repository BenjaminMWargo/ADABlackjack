
with ada.text_io; use ada.text_io;
with ada.integer_text_io;
with Ada.Unchecked_Deallocation; 
with ada.unchecked_conversion;
--use ada.unchecked_conversion;
package tools is
  type deck is private;
  type card is private;
  type cardPTR is private;-- all funct here

   function makeDeck(d:deck  ) return deck;
   function makeEmptyDeck (d:deck  ) return deck;
   procedure showDeck( d: in deck );
--   function drawCard( drawDeck: in out deck; discardDeck: in out deck ) return cardPTR;
   procedure drawToHand (hand : in out deck; drawDeck: in out deck; discardDeck: in out deck);
   procedure shuffle ( draw:in out deck; discard: in out deck );
   procedure display(Hand : in deck );
   procedure discardHand(Hand: in out deck;discard: in out deck);
   function getScore(hand : in deck ) return integer;
   function checkBust(total : in integer) return boolean;
--                  --   function Convert is new ada.unchecked_conversion ( Source =>
--                  --   function Convert is new ada.unchecked_conversion ( Source => cardValue, Target => Character);
   private
        --   subtype cardValue is integer 1..13;
--                   --  subtype cardSuit is integer 1..4;
   type cardValue is ('A','J','Q','K','1','2','3','4','5','6','7','8','9');
   Type cardSuit is (C,S,H,D);
   package Value_IO is new Ada.Text_IO.Enumeration_IO(cardValue);
   package Suit_IO is new Ada.Text_IO.Enumeration_IO(cardSuit);
   --   type cardPtr is access card;
        type cardPTR is access card;
        type card is
              record
                val : cardValue;
               suit : cardSuit;
               next : cardPTR;
              end record;
        type deck is
              record
              first :cardPTR;
              end record;
                                                                                                                --   type deck is
--                                                                                                                   --      record
--                                                                                                                      --       next : cardPTR;
--                                                                                                                         --     end record;
 end tools;

