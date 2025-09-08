---- MODULE trafficLightsSync ----
EXTENDS Integers, TLC

states == {"Green", "Red"}
(*
--algorithm trafficLightsSync {
    variables light1 = "Red", light2 = "Red";
    process (switchLight1 = 1)  {
        a: while (TRUE) {
            await light2 = "Red";
            if (light1 = "Red") {
                light1 := "Green"
            } else {
                light1 := "Red"
            };
            assert ~((light1 = "Green") /\ (light2 = "Green")); 
        };
    };
    process (switchLight2 = 2) {
        b: while (TRUE) {
            await light1 = "Red";
            if (light2 = "Red") {
                light2 := "Green"
            } else {
                light2 := "Red"
            };
            assert ~((light1 = "Green") /\ (light2 = "Green")); 
        };
    };
}
*)
==============================
