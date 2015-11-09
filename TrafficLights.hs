module TrafficLights where
import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational

controller1 :: Clocked a => a -> (a,a,a)
controller1 reset = (green, amber, red)
    where
        reset' = inv reset 

        state_green0 = dff(or2 reset state_amber8)
        state_green1 = dff(state_green0)
        state_green2 = dff(state_green1)
        state_amber3 = dff(state_green2)
        state_red4 = dff(state_amber3)
        state_red5 = dff(state_red4)
        state_red6 = dff(state_red5)
        state_red7 = dff(state_red6)
        state_amber8 = dff(state_red7)

        green = orw [state_green1, state_green0, state_green2]
        amber = orw [state_amber3, state_amber8]
        red = orw [state_red4, state_red5, state_red6, state_red7]


controller2 :: Clocked a => a -> a -> (a, a, a, a, a, [a])
controller2 reset walk_request = (green, amber, red, walk, wait, request_count)
    where
        reset' = inv reset
        walk_request_state = dff(and2 walk_request state_green0)
        request_count = [0]

        state_green0 = dff(or2 reset (orw [state_green0, state_amber5)
        state_amber1 = dff(and2 walk_request_state state_green0)
        state_red2 = dff(and2 reset' state_amber1)
        state_red3 = dff(and2 reset' state_red2)
        state_red4 = dff(and2 reset' state_red3)
        state_amber5 = dff(and2 reset' state_red4)

        green = state_green0
        amber = orw [state_amber1, state_amber5]
        red = orw [state_red2, state_red3, state_red4]
        walk = red
        wait = orw [green, amber]
