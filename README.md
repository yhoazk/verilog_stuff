# Verilog

# Verilog review


**RTL**: A type of behavioral modeling, for the purpose of synthesis.

## Componentes of a verilog HDL module
- ports
- data types
- Assigning values and numbers
- operators
- behavioral modeling: A components is described by its in/out response
  - Continuous assingmentes
  - procedural blocks
- Structural modeling: A component is described by interconnecting
 low-level component/primitives

## Tasks and functions

- A function cannot call a task, but a task can call a function
- A function runs on time zero, no timing events are allowed
- A task may or may not run in time zero

## Delta simulation time

A delta simulation time are evaluation of expressions, followed by value updates,
causing more evaluations and more value updates.

## `timescale`

timescale is used to determine how time is represented as an integer internally
to the simulator

## Basic syntax and structure

- begins with keyword `module` and ends with the keyword `endmodule`
- case sensitive
- statements end with semi-colon (;)
- all keywords are lower case
- `//` single line comment
- `/**/` multiline comment
- three port types `ìnput output inout`
- port declaration `<port type> {[MSB:LSB]} <port_name>;`
- data types `Net` and `variable`
  - variable can sythesize in reg
  - Net data type: need to be driven all the time

| Type Net | Definition |
|----------|-------------|
| `wire` | Represents a node connection |
| `tri` | Represents a tri-state node |
| `supply0` | Logic 0 |
| `supply1` | Logic 1 |


Variable data types
can be assinged only within a procedure, or a task or a function.

| Type Var | Definition |
|----------|------------|
| `reg` | unsigned variable of any bit size |
| `integer` | signed 32-bit variable |
| `real` | no synthesis support |
| `time` | no synthesis support |
| `realtime` | no synthesis support |

### *Verilog support s connetcions by ordererd list or by name*

### Paramenters

- like defines in `C`, value assinged to a symbolic name
- must resolve to a constatn at compile time
- can be overwritten at compile time
- `localparam` Same as paramenter but cannot be overwritten

it is also possible to configure the parameters at the module's instantiation

```v
module multiplier
#(paramenter size = 8)(<por list>);
```

### Assigning values

 - Decimal (d or D) `16'd255` = 16 bit wide decimal
 - Hexadecimal (h or H) `8'h9A` = 8bit wide Hexadecimal
 - Binary (b or B) `'b1010` 32-bit wide binary number
 - Octal (o or O) `'o21` = 32-bit wide octal number
 - Signed (s or S) `16'shFA` = signed 16-bit hex value

Blocking and non-blocking assingment
(=) Blocking assingment:
The whole statement is executed before passing to the next one

(<=) non-blocking assingment:
evaluates all the right hand sides for the current time unit and assigns the
left hand sides at the end of the time unit


Verilog scheduling semantics implies a four-level deep queue for the current
simulation:
1.- Active events
2.- Inactive events
3.- non-blocking assign updates
4.- Monitor events


### Special numbers chars

- `_` for readability
- `x` unknown
- `z` high impedance

### Bit wise operations

| symbol | functionality | Example |
|--------|---------------|---------|
| `~`    | **invert** each bit |   |
| `&`    | **AND** each bit    |   |
| `pipe|`| **OR** each bit     |   |
| `^`    | **XOR** each bit    |   |
|`~^`or`^~`| **XNOR** each bit |   |

Result is the size of the largest operand
operates on each bit or bit pairing pf operands
Operands are left-extended if sizes are different

### reduction Operands

| symbol | functionality |
|--------|---------------|
| `&`  |  **AND** all bits |
| `~&`  |  **NAND** all bits |
| `|`  |  **OR** all bits |
| `~|`  |  **NOR** all bits |
| `^`  |  **XOR** all bits |
| `^~` or `~^`  |  **XNOR** all bits |

Reduces a vector to a single value

### Relational operators

### Equality operators

- `==` result unknown if vector contains x or z
- `!=` result unknown if vector contains x or z
- `===` takes into account z and x for comparison
- `!==` takes into account z and x for comparison

### Logical operators

- `!`
- `&&`
- `||`

For if and while
Same as in C
Returns a 1 bit scalar value of boolean true or false
x or z are both considered unknown in operands and result is always unknown

### shift operators

- `<<` logical shift left
- `>>` logical shift right
- `<<<` arithmetic shift left (signed)
- `>>>` arithmetic shift right  (Signed)

Right shifts:

* Logical: Vacated positions always filled with zero
* arithmetic (unsigned) Vacated positions filled with zero
* arithmetic (signed): vacated positions filled with the value of the MSB
Logical shift: Vacated positions always filled with zero
Shifted values  are lost

### Miscellaneous operators

`?:` Conditional test. eg:

```v
 (condition)? true_value : false_value;
```

`{}` concatentate

```verilog
  ain = 3'b010; bin = 3'b110
  {ain, bin} = 6'b010_1100;
```

`{{}}` replicate

```verilog
{3{3'b101}} => 9'b101101101

```

## Continuous assingment

## procedutal assingment

**white space insensitive**
### Basis structure of a module

```v
module module_name(port lists);
  [port declarations]

  [Data type declarations]

  [circuit functionality]

  [timing specifications]
endmodule
```

![]()

## All about resets

The purpose of the reset is to take the ASIC, FPGA or related
to a known state and/or synchronize it to an input data
stream. process the data, and then output it.

### Asyncronous resets

- Requires less gates than Sync reset
- Does not requires the clk to be active
- Suffers from metastability problems

``` verilog
  always @ (posedge clk )
  if ( reset == 1'b1) begin
    c <= 0;
  end else begin
    c <= a;
  end
```

### Synchronous resets

- This kind of resets requires more gates to implement
- Requires that the clk is active always
- Synchronous reset does not have metastability problems
- Synchronous reset is slow

```verilog
always @ (posedge clk or posedge reset)
 if ( reset == 1'b1) begin
   c <= 0;
 end else begin
   c <= a;
 end
```
