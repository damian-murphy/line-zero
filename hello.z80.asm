; Hello world
; in z80 assembler
; for the ZX Spectrum
.Z80

; ZX System Variables
LAST_K equ #5c08

org $8000
  ; Call Clear screen in ROM
  call $0DAF
  call BORDERS

  ; Load BC register with address of first byte of STRING
  ld bc, STRING

  ; Call our print routine
  call PRINTSTRING
  
  ; Now loop until space is pressed
  WAITK:
    call BORDERS
    ld hl,LAST_K
    ld a, (hl)	; put last keyboard press into A
    cp #20		  ; was "space" pressed?
    jr nz,WAITK	; If not, back to the cycle
  
  ; All done, jump to exit
  jr EXIT

PRINTC:
  ; Print a character to main screen (CHAN 2)
  ; Save registers and pop after to be safe
  push hl
  push bc
  push de
  push af
  ld a,2
  ; open channel
  call $1601
  pop af
  push af
  ; call rom routine to print a char in A register
  rst 16
  pop af
  pop de
  pop bc
  pop hl
  ret

PRINTSTRING:
  ; print a string of chars
  ; bc contains the memory address of the start of string
  ; string is 0 terminated
  ld a, (bc)    ; load A register with contents of memory at (bc)
  cp 0          ; compare A register with 0
  ret z         ; return if compare is true (i.e. it's zero)
  inc bc        ; increment bc to point at next memory location
  call PRINTC   ; call our printchar routine

  ; Loop until done (null byte termination)
  jr PRINTSTRING

EXIT
  ; return to whence we came (probably BASIC interpreter)
  ret

STRING
  defb "Hello Dee!\x0D\x0D"
  defb "I can write machine code for the ZX Spectrum!"
  defb 0x00 ; terminate with null

BORDERS:
  ld a,0        ; start with black
  BORDER_LOOP:
    out (#fe),a   ; set the border color
    cp 7          ; go through the colours to white (7)
    ret z         ; if compare is true, return
    inc a         ; next colour
    ld bc,250     ; load a value for delay
    call Delay
    jr BORDER_LOOP
  ret

; Delays code execution
Delay:
    djnz Delay
    ret
