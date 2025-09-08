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
\* BEGIN TRANSLATION (chksum(pcal) = "c9d5e898" /\ chksum(tla) = "4fc0d2ec")
VARIABLES pc, sem

vars == << pc, sem >>

ProcSet == (Procs)

Init == (* Global variables *)
        /\ sem = 1
        /\ pc = [self \in ProcSet |-> "idle"]

idle(self) == /\ pc[self] = "idle"
              /\ TRUE
              /\ pc' = [pc EXCEPT ![self] = "getMutex"]
              /\ sem' = sem

getMutex(self) == /\ pc[self] = "getMutex"
                  /\ sem = 1
                  /\ sem' = 0
                  /\ pc' = [pc EXCEPT ![self] = "critOp"]

critOp(self) == /\ pc[self] = "critOp"
                /\ TRUE
                /\ pc' = [pc EXCEPT ![self] = "releaseMutex"]
                /\ sem' = sem

releaseMutex(self) == /\ pc[self] = "releaseMutex"
                      /\ sem' = 1
                      /\ pc' = [pc EXCEPT ![self] = "idle"]

P(self) == idle(self) \/ getMutex(self) \/ critOp(self)
              \/ releaseMutex(self)

Next == (\E self \in Procs: P(self))

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in Procs : WF_vars((pc[self] # "idle") /\ P(self))

\* END TRANSLATION 
================================
