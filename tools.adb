with ada.text_io; use ada.text_io;
With ada.integer_text_io; use ada.integer_text_io;
with Ada,Ada.Numerics.Discrete_Random;
use Ada,Ada.Numerics;
with Ada.Unchecked_Deallocation;
package body tools is
 procedure Free is new ada.Unchecked_Deallocation (Object => card, Name   => cardPTR);
 function  makeEmptyDeck (d:deck ) return deck is
  temp: deck;
  begin -- Make deck with no cards
   temp.first := new card;
   temp.first := NULL;
   return temp;
 end makeEmptyDeck;
-- -------------------------------------------
function makeDeck (d:deck ) return deck is
   temp : deck;
  begin -- Nested loops to load deck with each combo of value/suits
   temp.first := NULL;
   for i in cardValue'Range loop
     for j in cardSuit'Range loop
         temp.first := new card'(val => i, suit => j, next =>temp.first);
     end loop;
   end loop;
   return temp;
 end makeDeck;
-- -------------------------------------------
procedure showDeck ( d: in deck ) is
   temp: deck;
 begin
   temp.first := d.first;
  -- Traverses deck, printing val and suit for eachg
  while ( temp.first /= NULL ) loop
     put( " |");
     put(cardValue'Image(temp.first.Val ));
     Put ( "|");
     suit_IO.put(temp.first.Suit);
     Put ( "| ");
     new_line;
     temp.first := temp.first.next;
   end loop;
   new_line;
 end showDeck;
-- -----------------------------------------

procedure drawToHand (hand : in out deck; drawDeck: in out deck; discardDeck: in out deck) is
-- Takes top card of drawDeck and puts it on the top of hand
 temp:cardPTR;
  begin
--Check for empty deck, if empty, shuffle in discard into deck
 if (drawDeck.first = NULL) then
     shuffle(drawDeck,discardDeck);
 end if;
   temp := hand.first;
   -- if hand was empty
   if temp = NULL then
     hand.first := drawDeck.first;
     drawDeck.first := drawDeck.first.next;
     hand.first.next := NULL;
   else
    while not (temp.next = NULL) loop
     temp := temp.next;
    end loop;
    temp.next := drawDeck.first;
    drawDeck.first := drawDeck.first.next;
    temp.next.next := NULL;
   end if;  -- Put card at end of hand
end drawToHand;
-- ------------------------------------------------------
procedure shuffle( draw: in out deck; discard: in out deck) is
  Temp1: cardPTR;
     Temp2: cardPTR;
     Temp3: CardValue;
     Temp4: CardSuit;
     counter, num1, num2: Integer;
     count : Integer := 0;
     outercount : Integer := 0;
     cardTotal : integer :=0;
    SUBTYPE RandomRange IS Positive RANGE 1..52;

    PACKAGE Random_52 IS NEW Ada.Numerics.Discrete_Random
    (Result_Subtype => RandomRange);

    G: Random_52.Generator;
BEGIN
--  ada.text_io.put("ShuffleCalled");
-- if draw.first /= NULL then                    -- makes sure draw is not null
--   temp1 := draw.first;
--   loop
--    exit when Temp1.next =NULL;        -- traverses the list to get to the last node
--      Temp1 := Temp1.next;
--   end loop;
-- end if;
-- temp1 is last card of drawDeck
 temp1 := discard.first;
 while temp1 /= NULL loop
     temp1 := temp1.next;
 end loop;
-- ada.text_io.put("Loop 1");

-- temp1 points to last card of discard
 if (draw.first /= NULL) then
   Temp1.next := draw.first; 
    draw.first := NULL;
        -- puts all cards in the discard deck
 end if;
-- ada.text_io.put("if 1");

-- draw.first := NULL;
-- ============================
 temp1 := discard.first;
 while temp1 /= NULL loop
   cardTotal := cardTotal +1;
   temp1 := temp1.next;
 end loop;
-- ada.text_io.put("Loop 2");

-- ============================
  Temp1 := discard.first;
  Temp2 := discard.first;
  counter := 0;
--  loop                                          -- outer loop
  Random_52.Reset (Gen => G);
  loop
     num1 := Random_52.Random(Gen => G);        -- gets two random numbers
     num2 := Random_52.Random(Gen => G);
     num1 := (num1+1) rem (cardTotal+1);
     num2 := (num2+1) rem (cardTotal+1);
   --  ada.integer_text_io.put(num1);
   --  new_line;
  --   ada.integer_text_io.put(num2);
  --   new_line;
     delay Duration(0.00001);
 --    Random_52.Reset (Gen => G);
 --    if (num1 <= cardTotal) and (num2 <= cardTotal) then
 --       exit;
 --    end if;
--   end loop;
     if (num1 /= num2) then                     -- compare the numbers to make sure they are not the same
         if (Temp1 /= NULL) then              -- checks to make sure Temp1 is not null
            if (count/= num1) then
               Temp1 := Temp1.next;
            end if;
         end if;
         If (Temp2 /= NULL) then              -- checks to make sure Temp2 is not null
            If (count /= num2) then
               Temp2 := Temp2.next;
            end if;
         end if;
         count := count +1;
         If (Temp1 /= NULL) then                    -- If Temp1 does not equal NULL Temp3 holds Temp1's value and Temp4 holds Temp1's suit
           Temp3 := Temp1.val;
           Temp4 := Temp1.suit;
         end if;
         if (Temp2 /= NULL and Temp1 /= NULL) then  -- if Temp1 and Temp2 are not null then
          Temp1.val := Temp2.val;                          -- the values and suits from Temp1 and Temp2 are switched
          Temp1.suit := Temp2.suit;
          Temp2.val := Temp3;
          Temp2.suit := Temp4;
         end if;
     end if;
      exit when counter = 52;
     counter := counter+1;                  -- increments counter to insure loop will be exited from
   end loop;
  draw.first := discard.first;
  discard.first := NULL;
 end shuffle;
----------------------------------------------
--
function getScore(hand : in deck ) return integer is
        temp : deck := hand;
        Num : Integer:=0;
        Total : Integer := 0;
        aCount : Integer:= 0;
   begin
     loop
       exit when temp.first = NULL;
      
        if temp.first.val = '1' then
          Num := 10;
        end if;

        if temp.first.val = '2' then
          Num := 2;
        end if;
        if temp.first.val = '3' then
          Num := 3;
        end if;
        if temp.first.val = '4' then
          Num := 4;
        end if;
        if temp.first.val = '5' then
          Num := 5;
        end if;
        if temp.first.val = '6' then
          Num := 6;
        end if;
        if temp.first.val = '7' then
          Num := 7;
        end if;
        if temp.first.val = '8' then
          Num := 8;
        end if;
        if temp.first.val = '9' then
          Num := 9;
        end if;
        if temp.first.val = 'J' then
          Num := 10;
        end if;
        if temp.first.val = 'Q' then
          Num := 10;
        end if;
        if temp.first.val = 'K' then
          Num := 10;
        end if;
        if temp.first.val = 'A' then
          num :=11;
          aCount := aCount + 1; -- Add up all the A's and put them in at the end;
        end if;
        Total := Total +Num;
        temp.first := temp.first.next;
     end loop;
  -- add in A's at the end
     loop
        exit when aCount = 0; 
       if ((total >21) and (aCount>0)) then
          total := total - 10;
       --   aCount := aCount - 1;
        end if;
    --    if (total > 10) and (aCount>0) then
    --      total := total + 1;
          aCount := aCount - 1;
       end loop;
    return Total;
end GetScore;
-- ---------------------------
function checkBust(total : in integer) return boolean is

begin
      if (total > 21) then
        return True;
      else
        return False;
      end if;
end checkBust;
-- --------------------------------
procedure discardHand(Hand: in out deck;discard: in out deck) is
 temp: cardPTR;
 begin
  temp := hand.first;
  Loop 
   exit when temp = NULL;
      hand.first := hand.first.next;
      temp.next := discard.first;
      discard.first := temp;
     temp:= hand.first;
--   drawToHand(discard,hand,discard); -- Draws cards from the hand, into the discard;
     
  end loop;
end discardHand;
-- ---------------------------------
procedure display (Hand : in deck) is

        temp : deck;
        Value : Character;
      --  count : Integer;
begin
-- ===========================
-- TOP OF EACH CARD
-- ===========================
  temp := Hand;
   loop
       exit when temp.first = NULL;
         if temp.first.val = '1' then
          Value := 'T';
        end if;
	if temp.first.val = '2' then
          Value := '2';
        end if;
        if temp.first.val = '3' then
          Value := '3';
        end if;
        if temp.first.val = '4' then
          Value := '4';
        end if;
        if temp.first.val = '5' then
          Value := '5';
        end if;
        if temp.first.val = '6' then
          Value := '6';
        end if;
        if temp.first.val = '7' then
          Value := '7';
        end if;
        if temp.first.val = '8' then
          Value := '8';
        end if;
        if temp.first.val = '9' then
          Value := '9';
        end if;
        if temp.first.val = 'J' then
          Value := 'J';
        end if;
        if temp.first.val = 'Q' then
          Value := 'Q';
        end if;
        if temp.first.val = 'K' then
          Value := 'K';
        end if;
       if temp.first.val = 'A' then
         Value := 'A';
       end if;
       Put(".------.");
    temp.first := temp.first.next; 
   end loop;
   temp := Hand;
-- ==========================
-- LINE 2 OF EACH CARD
-- ==========================
 new_line;
     loop
       exit when temp.first = NULL;
    if temp.first.val = '1' then
          Value := 'T';
        end if;

        if temp.first.val = '2' then
          Value := '2';
        end if;
        if temp.first.val = '3' then
          Value := '3';
        end if;
        if temp.first.val = '4' then
          Value := '4';
        end if;
        if temp.first.val = '5' then
          Value := '5';
        end if;
        if temp.first.val = '6' then
          Value := '6';
        end if;
        if temp.first.val = '7' then
          Value := '7';
        end if;
        if temp.first.val = '8' then
          Value := '8';
        end if;
        if temp.first.val = '9' then
          Value := '9';
        end if;
        if temp.first.val = 'J' then
          Value := 'J';
        end if;
        if temp.first.val = 'Q' then
          Value := 'Q';
        end if;
        if temp.first.val = 'K' then
          Value := 'K';
        end if;
       if temp.first.val = 'A' then
         Value := 'A';
       end if;
      if temp.first.suit = C then
         Put("|");
         Put(Value);
         Put(" _   ");
         Put("|");
      elsif temp.first.suit = H then
         Put("|");
         Put(Value);
         Put("_  _ ");
         Put("|");
      elsif temp.first.suit = D then
         Put("|");
         Put(Value);
         Put(" /\  ");
         Put("|");
      elsif temp.first.suit = S then
         Put("|");
         Put(Value);
         Put(" .   ");
         Put("|");
      end if;
    temp.first := temp.first.next;
    end loop;
     temp := Hand;
     new_line;
 -- =================================
 -- LINE 3 OF EACH CARD
 -- ================================

   loop
       exit when temp.first = NULL;
    if temp.first.val = '1' then
          Value := 'T';
        end if;

        if temp.first.val = '2' then
          Value := '2';
        end if;
        if temp.first.val = '3' then
          Value := '3';
        end if;
        if temp.first.val = '4' then
          Value := '4';
        end if;
        if temp.first.val = '5' then
          Value := '5';
        end if;
        if temp.first.val = '6' then
          Value := '6';
        end if;
        if temp.first.val = '7' then
          Value := '7';
        end if;
        if temp.first.val = '8' then
          Value := '8';
        end if;
        if temp.first.val = '9' then
          Value := '9';
        end if;
        if temp.first.val = 'J' then
          Value := 'J';
        end if;
        if temp.first.val = 'Q' then
          Value := 'Q';
        end if;
        if temp.first.val = 'K' then
          Value := 'K';
        end if;
       if temp.first.val = 'A' then
         Value := 'A';
       end if;
      if temp.first.suit = C then
         Put("|");
         Put(" (");
         Put(" ");
         Put(")");
         Put("  ");
         Put("|");

      elsif temp.first.suit = H then
         Put("|");
         Put("(");
         Put(" ");
         Put("\");
         Put("/");
         Put(" )");
         Put("|");
      elsif temp.first.suit = D then
         Put("| /  \ |");
      elsif temp.first.suit = S then
           Put("| / \  |");
      end if;
    temp.first := temp.first.next;
    end loop;
     temp := Hand;
     new_line;
-- ===================================
-- LINE 4
-- ===================================

   loop
       exit when temp.first = NULL;
    if temp.first.val = '1' then
          Value := 'T';
        end if;

        if temp.first.val = '2' then
          Value := '2';
        end if;
        if temp.first.val = '3' then
          Value := '3';
        end if;
        if temp.first.val = '4' then
          Value := '4';
        end if;
        if temp.first.val = '5' then
          Value := '5';
        end if;
        if temp.first.val = '6' then
          Value := '6';
        end if;
        if temp.first.val = '7' then
          Value := '7';
        end if;
        if temp.first.val = '8' then
          Value := '8';
        end if;
        if temp.first.val = '9' then
          Value := '9';
        end if;
        if temp.first.val = 'J' then
          Value := 'J';
        end if;
        if temp.first.val = 'Q' then
          Value := 'Q';
        end if;
        if temp.first.val = 'K' then
          Value := 'K';
        end if;
       if temp.first.val = 'A' then
         Value := 'A';
       end if;
      if temp.first.suit = C then
         Put("|");
         Put("(");
         Put("_");
         Put("x");
         Put("_");
         Put(") ");
         Put("|");
      elsif temp.first.suit = H then
         Put("| \  / |");
      elsif temp.first.suit = D then
         Put("| \  / |");
      elsif temp.first.suit = S then
         Put("|(_,_) |");
      end if;
       temp.first := temp.first.next;
    end loop;
     temp := Hand;
     new_line;

-- ==================================
-- LINE 5
-- ==================================
  loop
       exit when temp.first = NULL;
    if temp.first.val = '1' then
          Value := 'T';
        end if;

        if temp.first.val = '2' then
          Value := '2';
        end if;
        if temp.first.val = '3' then
          Value := '3';
        end if;
        if temp.first.val = '4' then
          Value := '4';
        end if;
        if temp.first.val = '5' then
          Value := '5';
        end if;
        if temp.first.val = '6' then
          Value := '6';
        end if;
        if temp.first.val = '7' then
          Value := '7';
        end if;
        if temp.first.val = '8' then
          Value := '8';
        end if;
        if temp.first.val = '9' then
          Value := '9';
        end if;
        if temp.first.val = 'J' then
          Value := 'J';
        end if;
        if temp.first.val = 'Q' then
          Value := 'Q';
        end if;
        if temp.first.val = 'K' then
          Value := 'K';
        end if;
       if temp.first.val = 'A' then
         Value := 'A';
       end if;
      if temp.first.suit = C then
         Put("|  ");
         Put("Y");
         Put("  ");
         Put(Value);
         Put("|");
      elsif temp.first.suit = H then
         Put("|  \/ ");
         Put(Value);
         Put("|");
      elsif temp.first.suit = D then
         Put("|  \/ ");
         Put(Value);
         Put("|");
      elsif temp.first.suit = S then
         Put("|  I  ");
         Put(Value);
         Put("|");
      end if;
     temp.first := temp.first.next;
    end loop;
     temp := Hand;
 -- ================================
 -- Bottom of card
 -- ================================
     new_line;
    loop
       exit when temp.first = NULL;
       Put(".------.");
       temp.first := temp.first.next;
    end loop;


-- ==================================
--
-- ==================================
   new_line;
end display;
-- ----------------------------------
end tools;                 
