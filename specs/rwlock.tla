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

ExclusiveWriteLock == w_lock = 1 => r_counter = 0
ConcurrentReaders == w_lock = 0 => r_counter >= 0
============================================================
