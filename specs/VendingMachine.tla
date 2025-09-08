--------------------------- MODULE VendingMachine ---------------------------
EXTENDS Integers, Sequences, TLC

stateEvents == {"Coin", "ChooseSoda", "GetSoda", "ChooseBeer", "GetBeer"}
states == {"Pay", "Select", "Soda", "Beer"}
(***
--algorithm VendingMachine {
   variables inp = <<"Coin", "ChooseSoda", "GetSoda">>, state = "Pay", i = 1 ;    
   { 
     assert (\A n \in 1..Len(inp) : inp[n] \in stateEvents) /\ (state \in states);
     while ( i =< Len(inp)) {
        if (state = "Pay" /\ inp[i] = "Coin") {
            state := "Select";
        } else if (state = "Select" /\ inp[i] = "ChooseSoda") {
            state := "Soda";
        } else if (state = "Select" /\ inp[i] = "ChooseBeer") {
            state := "Beer";
        } else if (state = "Soda" /\ inp[i] = "GetSoda") {
            state := "Pay";
        } else if (state = "Beer" /\ inp[i] = "GetBeer") {
            state := "Pay";
        } else {
            state := "Fail"
        };
        assert state \in states;
        i := i + 1;
     };
   }
}

***)
=================
