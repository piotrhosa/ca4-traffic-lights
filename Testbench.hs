module Main where

import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational
import TrafficLights

separator :: IO ()
separator = putStrLn (take 76 (repeat '-'))

main :: IO ()
main =
  do separator
     putStrLn "Simulate controller1"
     run_controller1 controller1_input1

     separator
     putStrLn "Simulate controller1 with more resets"
     run_controller1 controller1_input2



run_controller1 input = runAllInput input output
  where

-- Extract input signals
    reset = getbit input 0 

-- The circuit to be simulated
    (green, amber, red) = controller1 reset

-- Format the output
    output =
      [string "Input: reset = ", bit reset,
       string "  Output: green = ", bit green, string " amber = ", bit amber, string " red = ", bit red]

controller1_input1 =
  [[0], [0], [1], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]
controller1_input2 =
  [[0], [0], [1], [0], [0], [1], [0], [0], [0], [0], [0], [0], [0], [0]]
