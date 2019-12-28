# OperatorPrecedence

- `[]() .`and post inc `++`, `--`: Associativity: L2R
- predecrement `++`, `--` `sizeof`, pointers `&`,`*`, sign changes, negation `~`, `!`: associativity: R2L
- typecasts: associativiy R2L
- `*`, `/`, `%` multiplication, division, modulo : associativity: L2R
- `+`, `-`: L2R
- `<<`, `>>` bitwise shift L2R
- `<`, `>`, `<=`, `=>` relational operands: L2R
- `==`, `!=`, equality L2R
- `&` unary bitwise and L2R
- `^` xor L2R
- `|` or L2R
- `&&` logical and : L2R
- `||` logical or : L2R
- `?:` ternary operator: R2L
- `=`, `[+,-,*,/,%]=`, `<<`: simple and compound assignment R2L
- `;` sequential evaluation L2R



## Static variable
A Static variable behaves differently depending upon whether is a global or a local variable.
A static global varaible is the same as an ordinary global varaible except that cannot be accessed by other files in the sae program project.
Even hen the extern operator is used.

A static local variable is different fro a local variable in that it is initialzed __only once__ no matter how many times the function in which it resided is called.


External variables: belong to external storage class are stored in the main memory. The external modifier is used when a function or variable is implemented in otherfile in the same project. The scope is global.

## Global variables 

Normally declared above the main function they can be accessed by any function in the program. Thier default value is 0.

Initial values of different storage classes:

`auto`: garbage
`register`: garbage
`static`: zero
`external`: zero

## Setting bits

Turn on single bit: `var &= ~(1 << bit_no)`
Turn off single bit: `var |= 1 << bit_no`

### where is an auto variable stored?

main memory and cpu registers are the two memory locations where auto variables are stored.

Auto variable:
__storage__: main memory
__default value__: garbage
__scope__: local
__lifetime__: until the control remains in scope.
