module Main where
import HDL.Hydra.Core.Lib
import HDL.Hydra.Circuits.Combinational
import TrafficLights

separator :: IO ()
separator = putStrLn (take 53 (repeat '-'))
separator1 :: IO ()
separator1 = putStrLn (take 111 (repeat '-'))

main :: IO ()
main =
    do
    separator
    putStrLn "1.1 Simulate controller1"
    run_controller1 controller1_input1

    separator
    putStrLn "1.2 Simulate controller1 with additional reset"
    run_controller1 controller1_input2

    separator
    separator1
    putStrLn "2.1 Simulate controller2 no requests"
    run_controller2 controller2_input1

    separator1
    putStrLn "2.2 Simulate controller2 single request"
    run_controller2 controller2_input2

    separator1
    putStrLn "2.3 Simulate controller2 multiple requests before green"
    run_controller2 controller2_input3

    separator1
    putStrLn "2.4 Simulate controller2 request after whole cycle"
    run_controller2 controller2_input4

    separator1
    putStrLn "2.5 Simulate controller2 counter"
    run_controller2 controller2_input5
    separator1


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

-- Test data for controller1
controller1_input1 =
  [[0], [0], [1], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]

controller1_input2 =
  [[0], [0], [1], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0], [0]]


run_controller2 input = runAllInput input output
    where

        -- Extract input signals
        reset = getbit input 0 
        walk_request = getbit input 1

        -- The circuit to be simulated
        (green, amber, red, walk, wait, request_count) = controller2 reset walk_request

        -- Format the output
        output =
          [string "Input: reset = ", bit reset, string " walk_request = ", bit walk_request,
          string "  Output: green = ", bit green, string " amber = ", bit amber, string " red = ", bit red, 
          string " walk = ", bit walk, string " wait = ", bit wait, string " request_count = 0x", hex request_count]

-- Test data for controller2
controller2_input1 =
  [[0, 0], [1, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

controller2_input2 =
  [[0, 0], [1, 0], [0, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

controller2_input3 =
  [[0, 0], [1, 0], [0, 0], [0, 0], [0, 1], [0, 1], [0, 1], [0, 0], [0, 0], [0, 1], [0, 0]]

controller2_input4 =
  [[0, 0], [1, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
  [0, 0], [0, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

controller2_input5 =
  [[0, 0], [1, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
  [0, 0], [0, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0],
  [0, 0], [0, 0], [0, 0], [1, 0], [0, 1], [0, 0], [0, 0], [1, 0], [0, 0],
  [0, 0], [0, 0], [0, 0], [0, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]



