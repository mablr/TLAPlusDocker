---- MODULE mutex ----
EXTENDS TLC, Integers, Sequences
Procs == {"p1", "p2"}
(* --algorithm SemMutex {
   variable sem = 1 ; 
   fair process (P \in Procs) {
     idle:- while (TRUE) {
             skip ;
      getMutex: await sem = 1 ;
             sem := 0 ;
         critOp: skip ;
       releaseMutex: sem := 1 ;
           }
   }
} *)
================================
