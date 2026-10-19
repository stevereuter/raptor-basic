# Raptor BASIC Specifications

## Number Variables

Will be set to 0 without a default value.

LET BYTE B
LET INT I

Setting a default will use double the memory, one for the actual storage location and 1 (byte or int) for the default value.

LET BYTE B = 255
LET INT I = 1000
Stored as PETSCII byte value
LET CHAR C = "C"

LET BYTE A, B, C = 23, D, E = 100

Fast, instead of linking all references with a pointer, all references will use the actual value.
CONST BYTE B = 255

CONST BYTE A = 10, B = 20, C = 20

## Arrays, Strings, and Queues

Define the size
DIM BYTE[10] B
Infer the size from the default
DIM BYTE B = [1, 2, 3, 4]

LET STRING[10] SV
LET STRING SV = "HELLO"
Define the size and infer the length
LET STRING[10] SV = "HELLO"

CONST STRING SC = "JUST THIS"

Define an array type list that can continuously grow by looping the indexes that are used. The 2 pointers would only be set to the same index when empty.
DIM QUE BYTE[100] QB
Add values to the top of the queue
PUSH(QB, 10)
PUSH(QB, 20)
PUSH(QB, 30)

[10, 20, 30]

Get the top value
B = TOP(QB)
30

Get the bottom value
B = BOT(QB)
10

Return the bottom value while moving the bottom pointer up.
B = POP(QB)
10, [20, 30]

Return the top value while moving the top pointer down.
B = PULL(QB)
30, [20]

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

## User defined Functions

DEF FN CB(INT A, INT B, INT C) => A*B*C

DEF FN RD(BYTE D) => RND(D) + 1

DEF FN SC(BYTE X, BYTE Y)
IF !X THEN RETURN 0
IF !Y THEN RETURN 0
RETURN X\*Y
ENDFN

## BASIC Functions and Keywords

### REM

REM THIS IS A COMMENT
REM:MAIN THIS CAN BE USED TO GOTO

### GOTO

GOTO 10
GOTO :MAIN

### GOSUB

GOSUB 500
GOSUB :DRAW

### IF

IF A THEN 200
IF A THEN 200 ELSE 300

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

### FOR

FOR [type] {name} = {start} TO {end} [step operator (defaults to name++)]

FOR BYTE I = 0 TO 10
PRINT I
NEXT

FOR INT I = 0 TO 1000 STEP I += 100
PRINT I
NEXT

DIM BYTE BA = [1, 2, 3]
FOR BYTE B IN BA
PRINT B
NEXT

FOR BYTE I IN [1, 2, 3]
PRINT I
NEXT

### BREAK

REM:DRAW
PRINT "DRAWING"
BREAK

FOR I IN [1, 2, 3]
IF I == 2 THEN BREAK
NEXT

### END

### PRINT

### POKE and PEEK

POKE(57280, 1)
B = PEEK(57820)

### Array Functions

Get the first byte value from the array. For DIM types (BYTE, INT, QUE) the size is returned. For STRING the length is returned.

LET STRING[10] ST = "HI"

L = LEN(ST) will return 2

Writing to and reading from memory.

WRITE(1024, [1, 2, 3])

LET BYTE BA = {1, 2, 3}
WRITE(1024, BA)

LET BYTE[3] BA
BA = READ(1024)

WRITE(52244, "HELLO WORLD")
PRINT(READ(52244))

### String Functions

S = SUBSTR(SV, 2, 2)

L = LEFT(SV, 2)

R = RIGHT(SV, 2)

### LIST

### RUN

## Structure

### Zero Page usage

| Register | Use                      |
| -------- | ------------------------ |
| $03      | status                   |
| $04      | current position pointer |
| $06      | next position pointer    |
| $08      | return value holder      |
| $0a      | first parameter holder   |
| $0c      | second parameter holder  |
| $0e      | third parameter holder   |

### Program header

## Interpreter

### Type system

| Bit     | Description | Values                                      |
| ------- | ----------- | ------------------------------------------- |
| 1       | source      | 0: system 1: user                           |
| 2 and 3 | data        | 00: byte, 01: int, 10: string, 11: function |
| 4       | mutable     | 0: static, 1: variable                      |
| 5       | array       | 0: single, 1: array                         |
| 6       | value       | 0: stored, 1: reference                     |
| 7 and 8 | options     | func param count 0 - 3                      |

### Line entry

### AOT line linker

### AOT variable resolver

### AOT block scoped variable resolver

### Run time processor
