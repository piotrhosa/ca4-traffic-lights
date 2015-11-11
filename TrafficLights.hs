module TrafficLights where
import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational
import HDL.Hydra.Circuits.Register

{-
controller1

input:
reset - signal that starts and resets the circuit 

output:
green, amber, red - treffic light signals
-}

controller1 :: Clocked a => a -> (a, a, a)
controller1 reset = (green, amber, red)
    where
        reset' = inv reset 

        state_green0 = dff(or2 reset state_amber8)
        state_green1 = dff(and2 reset' state_green0)
        state_green2 = dff(and2 reset' state_green1)
        state_amber3 = dff(and2 reset' state_green2)
        state_red4 = dff(and2 reset' state_amber3)
        state_red5 = dff(and2 reset' state_red4)
        state_red6 = dff(and2 reset' state_red5)
        state_red7 = dff(and2 reset' state_red6)
        state_amber8 = dff(and2 reset' state_red7)

        green = orw [state_green1, state_green0, state_green2]
        amber = orw [state_amber3, state_amber8]
        red = orw [state_red4, state_red5, state_red6, state_red7]

{-
controller2 

input:
reset - signal that starts and resets the circuit
walk_request - signal that kicks off the cycle for light change

output:
green, amber, red - traffic light signals
walk, wait - pedestrian signals; walk is connected to red and wait depends on green and amber
request_count - word that specifies how many times the walk_request button has been pressed; 
    reset sets this to 0x0000
-}
controller2 :: Clocked a => a -> a -> (a, a, a, a, a, [a])
controller2 reset walk_request = (green, amber, red, walk, wait, request_count)
    where
        reset' = inv reset
        walk_request_internal = and2 walk_request state_green0
        walk_request' = inv walk_request

        state_green0 = dff(or3 reset state_amber5 (and2 walk_request' state_green0))
        state_amber1 = dff(and2 walk_request_internal state_green0)
        state_red2 = dff(and2 reset' state_amber1)
        state_red3 = dff(and2 reset' state_red2)
        state_red4 = dff(and2 reset' state_red3)
        state_amber5 = dff(and2 reset' state_red4)

        green = state_green0
        amber = orw [state_amber1, state_amber5]
        red = orw [state_red2, state_red3, state_red4]
        walk = red
        wait = orw [green, amber]
        request_count = walkCount reset walk_request_internal

{-
walkCount takes in a reset signal and a signal that increments the counter.

input:
reset - reset signal that sets the register to 0x0000 if high
increment - internally part of a bus that is added to the current value in the register.

output:
count - the current request count stored in the register
-}
walkCount :: Clocked a => a -> a -> [a]
walkCount reset increment = count
    where
        increment_internal = replicate 15 zero ++ [increment]
        zero_bus = replicate 16 zero
        (carry, reg_input) = rippleAdd zero (bitslice2 count increment_internal)
        count = reg 16 (or2 increment reset) (resetBus reset reg_input zero_bus)

{-
resetBus takes two words and a control bit. The control bit decides which word appears at the output.

input:
reset - control bit
input1 - first input word; appears on output if control bit low
input2 - second input word; appears on output if control bit high

output:
[a] - output from mux
-}
resetBus :: Signal a => a -> [a] -> [a]-> [a]
resetBus reset input1 input2 = map2 (mux1 reset) input1 input2