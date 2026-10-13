# Raptor BASIC

## Mission

To give creativity back to the users with a fast, readable, efficient C64 game engine

- Accessible: Built for the everyday user who knows BASIC and wants to make fast and smooth games without needing to master assembly.
- Modern & Readable: Block statements with scope, named labels, inline array literals [...], and native QUE types.
- Hardware-Native Speed: 4-byte jump targets, pre-calculated CONST tokens, and 1-cycle bitwise ring buffers run at pure machine speed.
- 100% Portable: Runs directly on any stock C64 from disk, custom ROM, or cartridge—no external modern PC compiler required, but can be used for for more features, such as variable aliases.

## What is Raptor BASIC

Raptor BASIC is an Ahead Of Time (AOT) BASIC interpreter designed specifically for game development. It uses unsigned integer and byte values, and pointers for all code jumping. There is no line scanning, variable lookup, character interpretation, or garbage collection. The code that the user enters is immediately converted into a low level reference map and does not include the characters typed by the user. The RUN command initializes all variables and jump pointers before the program is run. The List command decodes the program back into readable lines matching what the user entered.
