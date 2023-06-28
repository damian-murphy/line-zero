#!/bin/bash

zmakebas -a 10 -n loader -o loader.tap loader.bas
pasmo -v --tap hello.z80.asm bitz.tap
cat loader.tap bitz.tap > hello.tap
rm loader.tap bitz.tap
