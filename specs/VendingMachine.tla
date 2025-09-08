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
\* BEGIN TRANSLATION (chksum(pcal) = "cf6c13d2" /\ chksum(tla) = "bc17ef56")
VARIABLES pc, inp, state, i

vars == << pc, inp, state, i >>

Init == (* Global variables *)
        /\ inp = <<"Coin", "ChooseSoda", "GetSoda">>
        /\ state = "Pay"
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert((\A n \in 1..Len(inp) : inp[n] \in stateEvents) /\ (state \in states), 
                   "Failure of assertion at line 10, column 6.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << inp, state, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i =< Len(inp)
               THEN /\ IF state = "Pay" /\ inp[i] = "Coin"
                          THEN /\ state' = "Select"
                          ELSE /\ IF state = "Select" /\ inp[i] = "ChooseSoda"
                                     THEN /\ state' = "Soda"
                                     ELSE /\ IF state = "Select" /\ inp[i] = "ChooseBeer"
                                                THEN /\ state' = "Beer"
                                                ELSE /\ IF state = "Soda" /\ inp[i] = "GetSoda"
                                                           THEN /\ state' = "Pay"
                                                           ELSE /\ IF state = "Beer" /\ inp[i] = "GetBeer"
                                                                      THEN /\ state' = "Pay"
                                                                      ELSE /\ state' = "Fail"
                    /\ Assert(state' \in states, 
                              "Failure of assertion at line 25, column 9.")
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << state, i >>
         /\ inp' = inp

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
==================
