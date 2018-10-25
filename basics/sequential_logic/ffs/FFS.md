# Flip Flops

## Latch vs Flip flop

A clocked latch changes the state synchronized with the clock pulse. It's state
changes only once during each occurence of a clock pulse. A sequential circuit
which operates with a clock and only changes state on the edge is said to be a
_synchronous sequential circuit_. The duration of the pulse is determined by
by the delay in the propagation of the signal. This clock needs to be short 
so the latch can only change once of state but long enough so the signal gets
propagated.

In general sequential circuits the outputs of the latch are inserted in a
combinational circuit, which generates the exitation functions for the latch.
As the process of tunning the length of the clock is hard and fragile we need
another type of synchronous memory element named _master-slave flip flop_


### Are latches ever useful?

See time stealing

## SR FF

Set reset latch, this has two inputs _S_ and _R_ and two outputs _y_ and _~y_.

## JK FF

## D FF

In the D latch the next state is equal to its present input value. This latch
behaves as a delay/storage element.

## T FF

Trigger or T latch