# Raptor BASIC Specifications

Raptor BASIC is a multi-level, Ahead-of-Time (AOT) compiled interpreter for the Commodore 64. It is specifically designed to be:

- **Fast:** Code is fully tokenized, linked, and optimized before execution ever starts.
- **Accessible:** Native on-hardware development — runs entirely on the C64 with no external PC or cross-compiler required, while offering a modern, clean syntax.
- **Efficient:** Only compiled bytecode is stored, with variable allocations and references resolved inline.

## The Compilation Pipeline

Raptor BASIC operates through four distinct processing phases:

- **Entry:** Converts source code text into intermediate byte data.
- **Linker:** Performs pre-run symbol resolution and pointer linking.
- **Runtime:** Executes the flattened bytecode stream with maximum 6502 speed.
- **List:** Reconstructs readable source lines back from the compiled byte data.

## Performance Comparison: C64 BASIC 2.0 vs. Raptor BASIC

### Memory Layout Example

**C64 BASIC 2.0 (20 bytes total):** Allocates 13 bytes for code and 7 bytes for the variable, split across separate memory locations.

```basic
1000 X = 255
```

**_Raptor BASIC _** (6 bytes total): Code and variable data are stored compactly inline.

```basic
1000 LET BYTE X = 255
```

### Execution Speedups

1. Variable Resolution: At runtime, C64 BASIC 2.0 must perform a lookup in its variable table every time X is referenced. The Raptor BASIC linker updates all variable references to direct pointers at compile time, making values instantly available.
2. Control Flow (GOTO): Stock C64 BASIC has to sequentially traverse the program's linked list to find target line numbers during jumps. The Raptor BASIC linker replaces all line number references with direct memory pointers for instant jumps.

## Program Structure

### Zero Page usage

- **Entry:** Holds input stream and parsed byte code line
- **Linker:** Holds pointer references
- **Runtime:** Holds status and function values
- **List:** Holds byte code line and parsed readable line

#### Input Layout

#### Run Time Layout

| Register | Use                     |
| -------- | ----------------------- |
| $03      | status                  |
| $04      | return value holder     |
| $06      | first parameter holder  |
| $08      | second parameter holder |
| $0a      | third parameter holder  |

### Program header

## Interpreter

### Type system

#### General

| Bit     | Description | Values                                      |
| ------- | ----------- | ------------------------------------------- |
| 1       | source      | 0: system 1: user                           |
| 2 and 3 | data        | 00: byte, 01: int, 10: string, 11: function |
| 4       | mutable     | 0: static, 1: variable                      |
| 5       | array       | 0: single, 1: array                         |
| 6       | value       | 0: value, 1: reference                      |
| 7 and 8 | options     | func param count/scope level 0 - 3          |

#### Variables

| Bit     | Description | Values                                      |
| ------- | ----------- | ------------------------------------------- |
| 1       | source      | 1: user                                     |
| 2 and 3 | data        | 00: byte, 01: int, 10: string, 11: function |
| 4       | mutable     | 0: static, 1: variable                      |
| 5       | array       | 0: single, 1: array                         |
| 6       | value       | 0: value, 1: reference                      |
| 7 and 8 | options     | scope level 0 - 3                           |

#### System Functions

| Bit     | Description | Values                 |
| ------- | ----------- | ---------------------- |
| 1       | source      | 0: system              |
| 2 and 3 | data        | 11: function           |
| 4       | mutable     | 0: static              |
| 5       | array       | 0: single              |
| 6       | value       | 1: reference           |
| 7 and 8 | options     | func param count 0 - 3 |

### Line entry

Nested functions will be written first to anonymous variables which will be referenced as the parent functions parameter.

### AOT line linker

### AOT variable resolver

### AOT block scoped variable resolver

Functions and subroutines will push the return register into the hardware stack. The end keywords will pop the register and jump back to the program.

GOSUB and FN will push the next register into the stack. ENDSUB and ENDFN will pull register and jump.
Inline FN will do the same thing with a hidden ENDFN keyword at the end of the line.

### Run time processor

## Assignment operators

Assign the value of 25:
B = 25

Assign a run time value based on a condition:
Ternary operator (condition) ? assign if true : assign if false
B = (A == 5) ? 1 : 0

Using shorthand to add to and subtract from the variable value:
B += 10 (B = B + 10)
B -= 10 (B = B - 10)

Shorthand for single increment and decrement:
B++ (B = B + 1)
B-- (B = B - 1)

Using shorthand to multiply and divide the variable value:
B \* = 10 (B = B \* 10)
B /= 10 (B = B / 10)

## Comparison operators

Comparison operators are evaluated using a false value of 0. All other values are considereed truethy.

IF A THEN PRINT "TRUE"

IF !A THEN PRINT "FALSE"

| Comparison               | Expression |
| ------------------------ | ---------: |
| equal to                 |     3 == 3 |
| not equal to             |     3 != 5 |
| greater than             |      5 > 3 |
| less than                |      3 < 5 |
| greater than or equal to |     5 >= 5 |
| less than or equal to    |     5 <= 5 |

All comparisons are done from left to right with the type being set by the left value. So comparing a byte with an int would ignore the high byte of the int. If comparing a byte to a string, the length will be used.

## Bitwise Operators

AND
| Expression | Result |
| --- | ---: |
| 0 AND 0 | 0 |
| 0 AND 1 | 0 |
| 1 AND 0 | 0 |
| 1 AND 1 | 1 |

OR
| Expression | Result |
| --- | ---: |
| 0 OR 0 | 0 |
| 0 OR 1 | 1 |
| 1 OR 0 | 1 |
| 1 OR 1 | 1 |

XOR
| Expression | Result |
| --- | ---: |
| 0 XOR 0 | 0 |
| 0 XOR 1 | 1 |
| 1 XOR 0 | 1 |
| 1 XOR 1 | 0 |

## Language Paradigms: Subroutines vs. Functions

Raptor BASIC makes a strict distinction between Subroutines (imperative commands) and Functions (value-returning operations). This design keeps high-level code readable while giving the compiler room to generate optimal bytecode.

**_Subroutines_** (Imperative Commands)
Subroutines perform actions or control program flow. They use a natural-language, clause-driven syntax with contextual keywords (such as STEP, TO, or FROM) to modify their behavior without wrapping parameters in heavy function calls.

- Syntax Style: Natural keyword clauses, separated by commas or modifiers.
- Return Value: None.
- Side Effects: Directly alters system state, memory, or execution flow.

Subroutine examples using contextual modifier keywords

```Basic
FOR I = 0 TO 100 STEP 2
WRITE 1024, AR STEP 40
```

**_Functions_** (Functional Expressions)
Functions transform input data into a single output value. They rely on strict functional scope marked by parentheses () to clarify operator precedence and nested parameter boundaries.

- Syntax Style: Explicit parenthesized argument lists NAME(arg1, arg2).
- Return Value: Evaluates to a typed result (BYTE, WORD, STR).
- Placement: Used inline within assignments, logic checks, or passed as arguments into Subroutines.

Function examples operating within expressions and subroutines

```Basic
LET BYTE X = ABS(Y)
PRINT LEFT$(S, 1)
```

## System Stack

The hardware stack is used when jumping to a function or subroutine so that the interpreter can return to the part of the progrem that if left. All system functions and subroutines do this automatically. For user define functions and subroutines this is handled with specific keywords.

Used to push the current position into the stack:

- [FN](#def-fn)
- [GOSUB](#gosub)

Use to pop the position off of the stack and continue the interpreter:

- [ENDFN](#endfn)
- [ENDSUB](#endsub)

## System Keywords

### BOT

Returns the bottom index of a [QUE](#que). Unlike [POP](#pop) the bottom index is not changed leaving the value at the bottom of the QUE.

```basic
RETURN_VALUE = BOT(QUE_REFERENCE)
B = BOT(Q)
```

### BREAK (TBD)

TODO: this is not really needed as GOTO can be used to achieve the same goal, this would be syntactical sugar that would require some walking to resolve as it would essentially a target less GOTO

The `BREAK` keyword can be used to break out of the current block. It is essentially a `GOTO` without a line number. It will store the register of end block part of code to jump to and do a `GOTO` to that position.

```basic
REM:DRAW
PRINT "DRAWING"
BREAK (this is the same GOTO the line with ENDSUB)
REM SKIPPED
ENDSUB

FOR I IN [1, 2, 3]
IF I == 2 THEN BREAK (this is the same as a GOTO after the NEXT)
NEXT
```

### BYTE

For defining a byte type variable or constant, see [CONST](#const) and [LET](#let), and a function for parsing a string to a byte.

[Variable](#let) or type byte

```basic
LET BYTE B
```

[Constant](#const) of type byte

```basic
CONST BYTE CB = 25
```

A [block scoped variable](#block-scoped-variables) with type byte

```basic
FOR BYTE I = 0 TO 9
PRINT I
NEXT
```

The `BYTE` function can be used to convert a string to a byte

```basic
RETURN_BYTE = BYTE(STRING_VALUE)
B = BYTE("255")
```

### CONST

Saving a value as a constant instead of a variable will add speed as the value will actually be copied to all locations instead of the pointer reference. It will take up no more space than a variable but will avoid the lookup. Like variables, multiple constants can be defined inline.

```basic
CONST BYTE B = 255

CONST BYTE A = 10, B = 20, C = 20
```

### DEF FN

For defining custom functions that return a value from any part of the program. Functions use 3 character names, can have 1 to 3 parameters which work like [block scope variables](#temporary-block-scope-variables), and return a value. Functions can be written 2 ways.

**_Inline functions_** are for simple calculations and address immediately returned.

```basic
DEF FN NAME(PARAM_1, PARAM_2, PARAM_3) => RETURN_OPEEATION

DEF FN RLL(BYTE D) => RND(D) + 1
```

**_Block Functions_** can be any number of lines, must return a value using [RETURN](#RETURN), and must end using [ENDFN](#endfn).

```basic
DEF FN SUP(BYTE X, BYTE Y)
IF !X THEN RETURN 0
IF !Y THEN RETURN 0
RETURN X\*Y
ENDFN
```

#### RETURN

For setting the return value in user defined block functions. This will also trigger a jump to the [ENDFN](#endfn) keword at the end of the block.

#### ENDFN

For defining the end of a user defined block function.

### DIM

Define an array dimension of a specified type. A string cannot be defined as an array because it is actually an array type. See [STR](#str) for more details.

`{type}{name x2}{size x2}{data...}`

Define with an explicit size

```basic
DIM BYTE[10] B
```

Define with an implicit size

```basic
DIM BYTE B = [1, 2, 3, 4]
```

### END

Stops the runtime interpreter.

```basic
END
```

### FOR

For creating a loop based on a range or array.

#### FOR TO

Loop through a number range from a specified starting point, end point, and increment step. A block scoped variable is use to hold the index value. See [block scoped variables](#block-scoped-variables) for more details.

Default single step increment

```basic
FOR TYPE INDEX_NAME = START_VALUE TO END_VALUE [STEP STEP_VALUE = 1]

FOR BYTE I = 0 TO 10
PRINT I
NEXT
```

Increment with a different value.

```basic
FOR INT I = 0 TO 1000 STEP 100
PRINT I
NEXT
```

Use a decending index with a decrement.

```basic
FOR INT I = 100 TO 0 STEP -10
PRINT I
NEXT
```

#### FOR IN

Loop through an array. A block scoped variable is use to hold the value of the current array element. See [block scoped variables](#block-scoped-variables) for more details.

Use an array reference.

```basic
DIM BYTE BA = [1, 2, 3]

FOR BYTE B IN BA
PRINT B
NEXT
```

Use an inline array constant.

```basic
FOR BYTE I IN [1, 2, 3]
PRINT I
NEXT
```

### GOTO

Used to jump to a different line in the program. A line number, variable, or [label](#labels) can be used for the target.

```basic
GOTO 10
GOTO ST
GOTO :MAIN
```

### GOSUB

Used to jump to a user defined [SUB](#sub), and return when complete. A line number, variable, or [label](#labels) can be used for the target.

```basic
GOSUB 500
GOSUB DW
GOSUB :DRW
```

#### SUB

User defined subroutine definition. A subroutine is any block of code that starts with `SUB` ends with [ENDSUB](#endsub). Which is used to return to the [GOSUB](#gosub) command that called it. A `SUB` can be called by name which must be 3 characters or by line number. These should only be reached via a `GOSUB` due to how the [Stack](#system-stack) is used.

#### ENDSUB

Defines the end of a user subroutine. This is a trigger that will return the program to the code that called the subroutine.

```basic
GOSUB :BDR
...
SUB BDR
POKE 53281, 0
ENDSUB
```

### IF

Used to conditionally execute code. The `IF` code will be executed when the condition evaluates to a truthy value, and an `ELSE` can be used to execute values of a falsy value. There are 2 ways to write an `IF` statement.

**_Inline IF Statements_** are writton on a single line and can be used to either execute code or jump to a line.

Using if to jump to lines of code.

```basic
IF CONDITION_TRUTHY THEN GOTO_LINE [ELSE GOTO_LINE]

IF A THEN 200
IF A THEN 200 ELSE 300
```

**_Block IF Statements_** are written across multiple lines using block scope.

```basic
IF A == 3
PRINT "A IS 3"
GOSUB 500
ENDIF

IF A ==3
PRINT "A IS 3"
GOSUB 500
ELSE
PRINT "A IS NOT 3"
GOSUB 600
ENDIF
```

### INT

For defining a integer type variable or constant, see [CONST](#const) and [LET](#let), and a function for parsing a string to an integer.

[Variable](#let) or type integer

```basic
LET INT B
```

[Constant](#const) of type integer

```basic
CONST INT CB = 25
```

A [block scoped variable](#block-scoped-variables) with type integer

```basic
FOR INT I = 0 TO 9
PRINT I
NEXT
```

The `INT` function can be used to convert a string to an integer.

```basic
RETURN_INT = INT(STRING_VALUE)
B = INT("255")
```

### Labels

You can create a label that can be used to jump to using [GOTO](#goto) and [GOSUB](#gosub) instead of using the line number. The interpreter will replace the label with the correct pointer to the line. Labels must be 3-4 characters

```basic
MAIN:
...
GOTO MAIN
```

### LEFT

Returns the left part of a string of X length.

```basic
RETURN_STR = LEFT(STR_VAL, LENGTH)

L = LEFT(SV, 2)
```

### LEN

Returns the length byte value from an array. For [DIM](#dim) type arrays ([BYTE](#byte), [INT](#int), [QUE](#que)) the size of the array is returned. For [STR](#str) the length is returned.

```basic
RETURN_VAL = LEN(ARRAY)

LET STR[10] ST = "HI"
REM RETURNS 2
L = LEN(ST)

LET BYTE[10] BT
REM RETURNS 10
L = LEN(BT)
```

### LET

Define a variable with global scope that can be accessed and assigned to at any point in the program (except when overwritten by [block scoped variables](#block-scoped-variables).) Variables must use 1-2 character names.
A string is handled as an array type in Raptor BASIC. See [STR](#str) for more information.

Define an integer or byte variable.
Memory: {type}{name x2}{value base on data type} (byte 4, int 5)

```basic
LET BYTE B
LET CHAR C (TODO: do we really need another byte with an auto parser)
LET INT I
```

Multiple definition of the same type can be defined inline.

```basic
LET BYTE A, B, C, D, E
```

Defining with a default value will add that value into memory. TODO: should it be okay to run these lines of code multiple times as we are really only doing an assignment, as the actual definition will be handled AOT?
Memory: {type}{name x2}{value base on data type}{default value} (byte 5, int 7)

```basic
LET BYTE B = 255
LET INT I = 1000
```

Single characters can be stored and will use a single byte containing the PETSCII value, and printing these variables would output the string representation.

```basic
LET CHAR C = "C"
```

#### Block Scoped Variables

Variables defined with [LET](#let) and [CONST](#const) have global scope and can be accessed anywhere. Block scoped variables can only be defined within a block scope, will only be available in that block, and will prevent access to any global variables with the same name within that block. Block Scoped variables must use a single character name.

`FOR` loops use these for the index variable, `I` below:

```basic
FOR BYTE I = 1 TO 10
REM I IS ONLY AVAILABLE HERE AND
REM WILL PREVENT ACCESS TO A GLOBAL I
NEXT
```

Custom functions use these as parameters, `X` and `Y` below:

```basic
DEF FN ARA(BYTE X, BYTE Y)
REN X AND Y ARE ONLY AVAILABLE HERE
ENDIF
```

But you can also add them inside any block:

```basic
REM THESE VARIABLES ARE NOT AVAILABLE IN THE BLOCK BELOW DUE TO HAVING THE SAME NAMES
LET INT X, Y, Z
REM BLOCK START
DEF FN ARA(BYTE X, BYTE Y)
INT Z = X * Y
RETURN Z
REM BLOCK END
ENDFN
```

A block of code is code that has a specific start and end point that is only reached via a condition. See the table below for all blacks:

| Start         | End                              |
| ------------- | -------------------------------- |
| [FOR](#for)   | [NEXT](#next)                    |
| [IF](#if)     | [ELSE](#else) or [ENDIF](#endif) |
| [ELSE](#else) | [ENDIF](#endif)                  |
| [FN](#def-fn) | [ENDFN](#endfn)                  |
| [SUB](#sub)   | [ENDSUB](#endsub)                |

### LINK

### LIST

### PRINT

### PEEK

Returns the value stored in memory.

```basic
RETURN_VAL_BYTE = PEEK(REGISTER)
B = PEEK(57820)
```

### POKE

Set the value in memory.

```basic
POKE REGISTER_INT, VALUE_BYTE
POKE 57280, 1
```

### POP

Returns the bottom value from a [QUE](#que) and updates the bottom index pointer. Unlike [BOT](#bot), this will essentially remove the value returned as it is now beyond the index pointer.

```basic
VALUE = POP(QUE_REF)
V = POP(Q)
```

### PULL

Returns the top value from a [QUE](#que) and updates the top index pointer. Unlike [TOP](#top), this will essentially remove the value returned as it is now beyond the index pointer.

```basic
VALUE = PULL(QUE_REF)
V = PULL(Q)
```

### PUSH

Pushes the value to the top of a [QUE](#que) and updates the top index pointer. This is the only way to add values to a QUE.

```basic
PUSH QUE_REF, VALUE
PUSH QUE, 25
```

### QUE

A queue is an array with a top and bottom pointer for tracking items that are added and removed. A negative 1 offset is used for an empty state which requires an extra register in the array to allow for the correct length. If a pointer reaches either end of the index range, they will loop to the other end based on the current action. This allows value to be continuosly added as long as the 2 pointers don't meet. The [PUSH](#push), [PULL](#pull), and [POP](#pop) functions are used to add and remove value based on FIFO or FILO principals. The [TOP](#top) and [BOT](#bot) can be used to return the end values without moving the pointers.

`{type}{name x2}{size x2}{top x2}{bottom x2}{data...}`

Empty state
| 0 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- |
| top | | | | | |
| | | | | | |
| | bot | | | | |

```basic
DIM QUE BYTE[5] QB
REM ADD VALUES
PUSH(QB, 10)
PUSH(QB, 20)
PUSH(QB, 30)
```

| 0   | 1   | 2   | 3   | 4   | 5   |
| --- | --- | --- | --- | --- | --- |
|     |     |     | top |     |     |
|     | 10  | 20  | 30  |     |     |
|     | bot |     |     |     |     |

Get the top value of 30

```basic
B = TOP(QB)
```

Get the bottom value of 10

```basic
B = BOT(QB)
```

Return the bottom value while moving the bottom pointer up.

```basic
B = POP(QB)
```

| 0   | 1   | 2   | 3   | 4   | 5   |
| --- | --- | --- | --- | --- | --- |
|     |     |     | top |     |     |
|     | 10  | 20  | 30  |     |     |
|     |     | bot |     |     |     |

Return the top value while moving the top pointer down.

```basic
B = PULL(QB)
```

| 0   | 1   | 2   | 3   | 4   | 5   |
| --- | --- | --- | --- | --- | --- |
|     | top |     |     |     |     |
| 10  | 20  | 30  |     |     |     |
|     | bot |     |     |     |     |

To allow the queue to work continuously, wne a push occurs with top at the max index, it will be set to 0 and the value added in the first index. Values will constantly loop in this way.
Pushing a 6th value to a queue with a size of 5 would hit the zero state of a negative 1 offset and all values would be lost. So it's important to use the correct size.

| 0   | 1   | 2   | 3   | 4   | 5   |
| --- | --- | --- | --- | --- | --- |
| top |     |     |     |     |     |
| 60  | 10  | 20  | 30  | 40  | 50  |
|     | bot |     |     |     |     |

The `QUE` keyword can also be used to get all the current data from bottom to top.

```basic
PRINT QUE(Q)
```

### READ

Returns data from memory into an array.

```basic
BYTE_ARR = READ(START_REG, LENGTH)
LET BYTE[3] BA
BA = READ(1024, 3)

WRITE 52244, "HELLO WORLD"
PRINT READ(52244, 11)
```

### RIGHT

Returns the left pay off a string up to X length.

```basic
RETURN_STR = RIGHT(STR_REF, LENGTH)
R = RIGHT(SV, 2)
```

### REM

Used for leaving a comment (remark) in the program. The interpreter will automatically jump over these lines by creating a hidden `GOTO` to the next line number.

```basic
REM THIS IS A COMMENT
```

### RND

### RPTSTR

Returns a string of repeated characters X number of times.

```basic
RETURN_STR = RPTSTR(CHAR, COUNT)
S = RPTSTR("*", 10)
```

### RUN

Starts the program execution. This will first run [LINK](#link) if the program status is dirty, then runs the program.

### STR

String are a type of array that require a length to be defined. This is due to how Raptor BASIC stores all data within the program. See [DIM](#dim) for more details. The main difference between a string and array is that the size is split into 2 values, the first byte is the length and the second is the size. This means string are limited to 255 in length. When [LEN](#len) is used it will only return the length data.

`{type}{name x2}{length}{size}{data...}`

Define a string by explicit length.

```basic
LET STR[10] SV
```

Define a string with an implicit length and default value.

```basic
LET STR SV = "HELLO"
```

Define a string with an explicit length and a default value which is less than the length.

```basic
LET STR[10] SV = "HELLO"
```

You can also manipulate the string length by assigning a number value. Assigning a byte will be stored in the length. The string data is not changed, so setting it back will restore the original value.

```basic
LET STRING HI = "HELLO"
HI = 0
```

The `STR` function can be used to convert a number to a string.

```basic
LET STR[4] NM
NM = STR(1234)
```

### SUBSTR

Returns party of a string.

```basic
RETURN_STR = SUBSTR(STR_REF, START_POS, LENGTH)
S = SUBSTR(SV, 2, 2)
```

### TOP

Returns the top value from a [QUE](#que). Unlike [PULL](#pull) the index is not changed and the value stays at the top.

```basic
VALUE = TOP(QUE_REF)
V = TOP(Q)
```

### WRITE

Write the elements of an array to memory.

Write from static array.

```basic
WRITE(1024, [1, 2, 3])
```

Write from array variable.

```basic
LET BYTE BA = [1, 2, 3]
WRITE 1024, BA
```

Write to non consecutive registers by step interval.

```basic
WRITE 1024, BA STEP 40
```
