module TrafficLights where
import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational

controller1 :: Clocked a => a -> (a,a,a)
controller1 reset = (green, amber, red)
    where
        reset' = inv reset 

--	state_green0 = dff(or3 reset state_amber8 (fault3 [green, amber, red]))
	state_green0 = dff(or2 reset state_amber8)
	state_green1 = dff(or2 reset state_green0)
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


fault3 :: Signal a => [a] -> a
fault3 [x, y, z] = fault
    where
        fault = inv (and3 (or2 x y) (or2 y z) (or2 x z))
{-
        reset' = inv reset 
        state_green = dff(or2 reset state_amber2)
        state_amber1 = dff()
	state_amber2 = dff()
        state_red = dff()
        green = orw [state_green]
        amber = orw [state_aber1, state_amber2]
        red = orw [state_red]
-}
