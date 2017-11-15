with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;

with tools; use tools;
procedure main is
 drawDeck: deck; -- Deck cards are drawn fromt
 discardDeck: deck; -- Deck removed cards are placed to
 playerHand: deck; -- Player's current hand
 dealerHand: deck; -- Dealers's current hand
 Player,Dealer : Boolean := False;
 temp:integer := 1;
 response : integer; 
 counter : Integer := 0;
 chipTotal : Integer := 500;
 wager : integer := 500;

-- ===================================================
-- PLAY GAME
-- ===================================================
procedure displayAll(hand:in deck) is 

begin
    new_page;
    ada.text_io.put("~~~~~~~~~~~~~~~~~~~Playing for :$");
    ada.integer_text_io.put(item =>wager, width =>6);
    ada.text_io.put(" ~~~~~~~~~~~~~~~~~~~~");
    new_line;
    ada.text_io.put("============DEALER=============");
    new_line;
    display(dealerHand);
    ada.text_io.put("Current total ~");
    ada.integer_text_io.put(getScore(dealerHand));
    new_line;
    ada.text_io.put("============PLAYER=============");
    new_line;
    display(playerHand);
    ada.text_io.put("Current total ~");
    ada.integer_text_io.put(getScore(playerHand));
    new_line;
    ada.text_io.put("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    new_line;
end displayAll;

Procedure playGame(chips: in integer) is

 begin
 loop 
   ada.text_io.put("How much do you want to bet? Current total ~$");
   ada.integer_text_io.put(item=>chipTotal, width => 6);
   new_line;
   ada.integer_text_io.get(wager);
   new_line;
   if wager > chipTotal or wager <= 0 then 
     ada.text_io.put("Invalid entry, try again");
     new_line;
   else 
     chipTotal := chipTotal - wager;
     exit;
   end if;
  end loop;     
 -- Draw starting hands
  drawToHand(dealerHand,drawDeck,discardDeck);
  drawToHand(dealerHand,drawDeck,discardDeck);
  drawToHand(playerHand,drawDeck,discardDeck);
  drawToHand(playerHand,drawDeck,discardDeck);
  displayAll(playerHand);
 -- Player Turn
 Loop 
   ada.text_io.put("1 to hit 2 to stay");
   ada.integer_text_io.get(response);
   new_line;
   if response = 1 then
     drawToHand(playerHand,drawDeck,discardDeck);
   elsif response = 2 then
        exit;
 --  elsif response = 3 then
 --     showdeck(drawDeck);
 --     new_line;
 --     showdeck(playerHand);
 --     new_line;
 --     showdeck(dealerHand);
   end if;
    displayAll(playerHand);
   if checkBust(getScore(playerHand)) then
    exit;
   end if;
  end loop;
 -- Dealer Turn
 Loop 
  -- Dealer stays on >17, if player busts or is currently winning
   if getScore(PlayerHand) > 21 or getScore(dealerHand)> getScore(playerHand) then
     exit;
   elsif getScore(dealerHand) > 17 and (getScore(playerHand)< getScore(dealerHand)) then
     exit;
   else
     drawToHand(dealerHand,drawDeck,discardDeck);
   end if;
 end loop; 
  displayAll(dealerHand);
 -- Pick winner, reward wager
 if (checkBust(getScore(playerHand))) then 
   -- player lose
   new_line;
   ada.text_io.put("Dealer Wins, you lost $");
   ada.integer_text_io.put(wager);
   
 elsif (checkBust(getScore(dealerHand))) then
   -- player win
    new_line;
   ada.text_io.put("Player Wins, you won $");
   ada.integer_text_io.put(wager);
   chipTotal := chipTotal + (2*wager);
 elsif getScore(dealerHand) >= getScore(playerHand) then
  -- player loses ties
    new_line;
    ada.text_io.put("Dealer Wins, you lost $");
    ada.integer_text_io.put(wager);
 
 elsif  getScore(playerHand) > getScore(dealerHand) then 
   -- player win
   new_line;
   ada.text_io.put("Player Wins, you won $");
   ada.integer_text_io.put(wager);
   chipTotal := chipTotal + (2*wager);
 end if;
 new_line;
 -- Discard both hands at the end
  discardHand(dealerHand,discardDeck);
  discardHand(playerHand,discardDeck);
 end playGame;
-- ===========================================
begin-- Set up defaults for decks
  drawDeck := makeDeck(drawDeck); -- Makes a new deck, puts it in drawDeck
  discardDeck := makeEmptyDeck(discardDeck); -- Makes a new, empty deck
  playerHand :=  makeEmptyDeck(playerHand); -- ''
  dealerHand :=  makeEmptyDeck(dealerHand);-- ''
 loop
   exit when counter = 50;   -- why repeat so much?
   shuffle(discardDeck, drawDeck);
   shuffle(drawDeck, discardDeck);
   counter := counter+1;
  end loop;
-- ==================================================
--MAIN LOOP
-- =================================================
  new_page;
 loop
  -- =======================================
  --  Main Menu
  -- =======================================

   ada.text_io.put("MAIN MENU ");
   new_line;
   ada.text_io.put("Current Money ~ $");
   ada.integer_text_io.put(chipTotal);
   new_line;
   ada.text_io.put("1) Play New Game");
   new_line;
   ada.text_io.put("2) Quit)");
   new_line;
   ada.integer_text_io.get(response);
   case response is 
     when 1 =>
        -- play game
        playGame(chipTotal);
     when 2 => 
        -- quit
         exit;
     when others =>
        -- bad input
         ada.text_io.put("Invalid input, try again");
         new_line;
   end case;
   if chipTotal = 0 then
     new_line;
     ada.text_io.put("You are out of money. You are being escorted out of the building.");
     new_line;
     ada.text_io.put("GAME OVER");
     exit;
   end if;
 end loop;
end main;

