---- MODULE rwlock ----
EXTENDS TLC, Integers, Sequences
Readers == {"r1"}
Writers == {"w1", "w2"}
(* --algorithm rwlock {
    variable buffer = 0, r_counter = 0, w_lock = 0;
    process (Reader \in Readers) {
        get_read: await w_lock = 0;
            r_counter := r_counter + 1;
        \* possible print of buffer
        release_read: r_counter := r_counter - 1;
    };
    process (Writer \in Writers) {
        get_write: await w_lock = 0 /\ r_counter = 0;
            w_lock := 1;
        write: buffer := self;
        release_write: w_lock := 0;
    };
} *)
\* BEGIN TRANSLATION (chksum(pcal) = "ae7f3f5a" /\ chksum(tla) = "6f30ef13")
VARIABLES pc, buffer, r_counter, w_lock

vars == << pc, buffer, r_counter, w_lock >>

ProcSet == (Readers) \cup (Writers)

Init == (* Global variables *)
        /\ buffer = 0
        /\ r_counter = 0
        /\ w_lock = 0
        /\ pc = [self \in ProcSet |-> CASE self \in Readers -> "get_read"
                                        [] self \in Writers -> "get_write"]

get_read(self) == /\ pc[self] = "get_read"
                  /\ w_lock = 0
                  /\ r_counter' = r_counter + 1
                  /\ pc' = [pc EXCEPT ![self] = "release_read"]
                  /\ UNCHANGED << buffer, w_lock >>

release_read(self) == /\ pc[self] = "release_read"
                      /\ r_counter' = r_counter - 1
                      /\ pc' = [pc EXCEPT ![self] = "Done"]
                      /\ UNCHANGED << buffer, w_lock >>

Reader(self) == get_read(self) \/ release_read(self)

get_write(self) == /\ pc[self] = "get_write"
                   /\ w_lock = 0 /\ r_counter = 0
                   /\ w_lock' = 1
                   /\ pc' = [pc EXCEPT ![self] = "write"]
                   /\ UNCHANGED << buffer, r_counter >>

write(self) == /\ pc[self] = "write"
               /\ buffer' = self
               /\ pc' = [pc EXCEPT ![self] = "release_write"]
               /\ UNCHANGED << r_counter, w_lock >>

release_write(self) == /\ pc[self] = "release_write"
                       /\ w_lock' = 0
                       /\ pc' = [pc EXCEPT ![self] = "Done"]
                       /\ UNCHANGED << buffer, r_counter >>

Writer(self) == get_write(self) \/ write(self) \/ release_write(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Readers: Reader(self))
           \/ (\E self \in Writers: Writer(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

ExclusiveWriteLock == w_lock = 1 => r_counter = 0
ConcurrentReaders == w_lock = 0 => r_counter >= 0
============================================================
