

### Logic Design

The application of switching theory is the design of logic design. Switching
algebra will be used to describe the logical behaviour of networks composed of
these blocks as well as to manipulate and simplify switching expressions thereby
reducing the number of components used in the design. It concerns with the
logic functions that the circuit performs rather than with its electronic
structure or behaviour.

In FPGAs the combinational logic is implemented my storing the truth table in
the memory blocks for every logic cell. The synthetizer takes the task to
optimize the logic expression. Then most of the times is better to directly
implement a LUT instead of leaving it to compiler/optimizer/synth choice.





- - -

#### List of switching functions `f(x,y)` for vars `x` and `y`

| a<sub>1</sub> |      Are      |  Cool |
|:-------------:|:-------------:|------:|
|               |               |       |
|               |               |       |
|               |               |       |


| a<sub>3</sub> | a<sub>2</sub> | a<sub>1</sub> | a<sub>0</sub> |  `f(x,y)`     | fnc name      | symbol        |
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
|     `0`       |   `0`         |     `0`       |    `0`        |      `0`      |  Inconsistency|               |
|     `0`       |   `0`         |     `0`       |    `1`        |      `~x~y`   |  nor          | `~|`          |
|     `0`       |   `0`         |     `1`       |    `0`        |     `~xy`     |               |               |
|     `0`       |   `0`         |     `1`       |    `1`        |     `~x`      |  not          |  `~`          |
|     `0`       |   `1`         |     `0`       |    `0`        |     `x~y`     |               |               |
|     `0`       |   `1`         |     `0`       |    `1`        |     `~y`      |               |               |
|     `0`       |   `1`         |     `1`       |    `0`        |   `~xy+x~y`   |  xor          | `x^y`         |
|     `0`       |   `1`         |     `1`       |    `1`        |    `~x+~y`    |  nand         | `~&`          |
|     `1`       |   `0`         |     `0`       |    `0`        |     `xy`      |  and          |  `&`          |
|     `1`       |   `0`         |     `0`       |    `1`        |   `xy+~x~y`   |  equivalence  |  `==`         |
|     `1`       |   `0`         |     `1`       |    `0`        |      `y`      |               |               |
|     `1`       |   `0`         |     `1`       |    `1`        |    `~x+y`     |  implication  | `x->y`        |
|     `1`       |   `1`         |     `0`       |    `0`        |      `x`      |               |               |
|     `1`       |   `1`         |     `0`       |    `1`        |    `x+~y`     |  implication  | `y->x`        |
|     `1`       |   `1`         |     `1`       |    `0`        |    `x+y`      |  or           | `|`           |
|     `1`       |   `1`         |     `1`       |    `1`        |      `1`      |  Tautology    |               |


There are 2<sup>2<sup>2</sup></sup> = 16 functions corresponding to the 16
possible assignments of 0s and 1s to a<sub>0</sub>,a<sub>1</sub>,a<sub>2</sub> and
a<sub>3</sub>. There are six nonsimilar funcitions which are known as trivial

1. `f = 0`
2. `f = 1`
3. `f = x`

while 

4. `f = xy`
5. `f = x+y`
6. `f = xy + ~x~y`

are known as non-trivial functions. Any other function may be obtained from these six by
complementation or interchange of variables. 



