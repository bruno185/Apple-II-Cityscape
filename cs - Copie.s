
* pour les routines HGR, HPLOT etc. voir "Inside the Apple IIe.pdf" p. 276
* pour les routines FP : 
* "micro_22_mar_1980.pdf" 
* "micro_33_feb_1981.pdf"
* "Assembly Lines Complete.pdf" ; 
* "Apple-Orchard-v1n1-1980-Mar-Apr.pdf"
* Poms 18
* Poms 20
* "Apple_Programmers_Handbook_1984.pdf"
* Inside the Apple IIe.pdf"
****

****** FP routines ******
float   equ $e2f2
PRINTFAC equ $ED2E
FIN equ $EC4A           ; FAC = expression pointee par TXTPTR
FNEG equ $EED0          ; FAC = - FAC
FABS equ $EBAF          ; FAC = ABS(FAC)
F2INT16 equ $E752       ; FAC to 16 bits int in A/Y and $50/51 (low/hi)
FADD    equ $E7BE       ; FAC = FAC + ARG 
FSUBT   equ $E7AA       ; FAC = FAC - ARG
FMULT   equ $E97F       ; Move the number pointed by Y,A into ARG and fall into FMULTT 
FMULTT  equ $E982       ; FAC = FAC x ARG
FDIVT   equ $EA69       ; FAC = FAC / ARG
RND     equ $EFAE       ; FAC = random number
FOUT    equ $ED34       ; Create a string at the start of the stack ($100−$110)
MOVAF   equ $EB63       ; Move FAC into ARG. On exit A=FACEXP and Z is set
CONINT  equ $E6FB        ; Convert FAC into a single byte number in X and FACLO
YTOFAC  equ $E301
MOVMF   equ $EB2B       ; Routine to pack FP number. Address of destination must be in Y
          ; (high) and X (low). Result is packed from FAC
QUINT   equ $EBF2       ; convert fac to 16bit INT at $A0 and $A1
STROUT  equ $DB3A       ; 

****** 
printhex equ $FDDA
******

TXTPTR equ $b8
CHARGET equ $b1
CHARGOT equ $b7

fac equ $9d
arg equ $a5

ptr equ $06
************************************************
    put const
    org $8000


    jsr home
    jsr rdkey
    jsr initrandom

    jsr fondbleu
    jsr initHGR


init
    lda #$00
    sta passe
    sta xend
    lda #$00
    sta xstart

bigloop
    lda #$00
    sta xstart

mloop
* J = I +  INT (RND (1) * 3) + 2
    lda $4e 
    jsr RND     ; fac = random number (> 0 et < 1)

**************
    ldy #>myfac
    ldx #<myfac
    jsr MOVMF   ; move fac => memory (packed) = RND
    ldy #3
    jsr YTOFAC  ; fac = 3 
    ldy #>myfac 
    lda #<myfac
    jsr FMULT   ; move number in memory (Y,A) to ARG and mult. result in fac.
    ;jsr prnfaq

**************
* alternative au bloc précédent
    ;jsr MOVAF   ; arg = fac
    ;ldy #3
    ;jsr YTOFAC
    ;;jsr getsgn     ; alternative à jsr FABS cf. pom's 18
    ;jsr FMULTT      ; fac = fac * arg
    ;jsr FABS        ; cf. pom's 20 page 13 (alternative : jsr getsgn avant jsr FMULTT
    ;jsr prnfaq
**********

    jsr CONINT      ; x = fac
    txa
    clc
    adc #$02        ; add 2
    clc
    adc xstart
    sta xend        ; xend = xstart + rnd*3 +2 

*if J>39 then J = 39
    cmp #39         
    bcc ok39
    lda #39
    sta xend
ok39
    ;jsr prnstartend

* calcul de hauteur 
*T =  INT ( RND (1) * (4 - N) * 48) + N * 48

    jsr RND     ; fac = random number (> 0 et < 1)
    ldy #>myfac
    ldx #<myfac
    jsr MOVMF   ; move fac => memory (packed) = RND
    
    lda #4
    sec
    sbc passe       ; A = (4 - N)
    sta interligne
    tay
    jsr YTOFAC      ; fac = (4 - N) 
    ldy #>myfac 
    lda #<myfac
    jsr FMULT       ; move mem. to ARG and mult fac*arg. fac =  RND * (4 - N) 
    ldy #>myfac
    ldx #<myfac
    jsr MOVMF   ; move fac => memory (packed) = RND * (4 - N)
    ldy #48
    jsr YTOFAC      ; fac = 48
    ldy #>myfac 
    lda #<myfac
    jsr FMULT       ; move mem. to ARG and mult fac*arg. fac =  RND * (4 - N) * 48      
    *jsr prnfaq

    jsr CONINT      ; x = int(fac). NB : fac <= 191
    stx hauteur     ; update hauteur

    ldy passe 
    jsr YTOFAC      ; fac = passe
    ldy #>myfac
    ldx #<myfac
    jsr MOVMF   ; move fac => memory (packed) = passe 
    ldy #48
    jsr YTOFAC      ; fac = 48
    ldy #>myfac 
    lda #<myfac
    jsr FMULT       ; move mem. to ARG and mult fac*arg. fac =  passe * 48 
    jsr CONINT      ; x = passe * 48
    txa
    clc
    adc hauteur     ; hauteur = INT(RND *(4-passe)* 48)+passe*48
    sta hauteur
    sta value
    ;jsr debug
;wk  jsr rdkey



* plot

nextligne
    ldx hauteur
    lda lo,x 
    sta ptr
    lda hi,x 
    sta ptr+1
    ldy xstart
    lda #$80
plotloop
    sta (ptr),y
    iny 
    cpy xend
    bcc plotloop
    beq plotloop

    lda hauteur
    clc
    adc interligne
    sta hauteur
    cmp #191
    bcc nextligne
    beq nextligne


    lda xend
    cmp #39
    beq next
    lda xend
    clc
    adc #1
    sta xstart      ; xstart = xend + 1 
    jmp mloop

next
    jsr rdkey
    inc passe
    lda passe
    cmp #$04
    beq end 
    jmp bigloop
end rts





*********** UTIL ****************

initrandom
    lda $4e 
    ldy $4f 
    jsr float
    jsr prnfaq
    jsr RND
    jsr prnfaq
    rts

*** init HGR
initHGR
    lda page1       ; go HGR
    lda mixoff      ; no text
    lda graphics    ; graphic mode
    lda hires       ; hgr 
    rts
***

*** fond bleu
fondbleu
    ldx #$00
newline
    lda lo,x 
    sta ptr
    lda hi,x 
    sta ptr+1

    ldy #$00
doline
    lda #$d5 
    sta (ptr),y
    iny
    lda #$aa 
    sta (ptr),y
    iny
    cpy #$28            ; 40 bytes ?
    bne doline

    inx 
    cpx #$c0             ; 192 lines ?
    bne newline
    rts
***

*** debug routine
debug
    lda hauteur
    sta value
    jsr prtbyt
    lda #" "
    jsr cout
    lda xstart
    sta value
    jsr prtbyt
    lda #" "
    jsr cout   
    lda xend
    sta value
    jsr prtbyt
    lda #$8d
    jsr cout 
    rts  
***

*** another debug routine
prnstartend
    lda #$8d
    jsr cout
    lda #"$"
    jsr cout
    lda xstart 
    jsr printhex
    lda #" "
    jsr cout 
    jsr cout
    lda #"$"
    jsr cout
    lda xend 
    jsr printhex
    rts     
***

*** another debug routine
prnfaq
    jsr savfac
    lda #$8d
    jsr cout
    ldx #$00
print2
    lda fac,x
    jsr printhex
    lda #" "
    jsr cout
    inx
    cpx #$6
    bne print2
    lda #" "
    jsr cout
    ldy #>fleche
    lda #<fleche
    jsr STROUT
    jsr getfac
    jsr PRINTFAC        ; kills FAC
    jsr getfac
    rts
***

*** save FAC content to mem.
savfac
    ldx #$05
lsav
    lda fac,x
    sta myfac,x
    dex
    bpl lsav
    rts
***

*** restaore FAC content from mem.
getfac
    ldx #$05
lgf
    lda myfac,x
    sta fac,x
    dex
    bpl lgf
    rts  

getsgn              ; cf. pom's 18
    lda $aa         ; signe de fac
    eor $a2         ; signe de arg
    sta $ab         ; signe resultat dans $ab ??? 
    lda $9d         ; necessaire pour FMULT
    rts
***

*** print byte in memory (value) in decimal
prtbyt  
    pha             ;save registers
    txa
    pha
          ;
    ldx #$2         ;max of 3 digits (0-255)
    stx lead0       ;init lead0 to non-neg value
prtb1   
    lda #"0"        ;initialize digit counter
    sta digit
          ;
prtb2   sec
    lda value       ;get value to be output
    sbc tbl10,x     ;compare with powers of 10
    blt prtb3       ;if less than, output digit
          ;
    sta value       ;decrement value
    inc digit       ;increment digit couoter
    jmp prtb2       ;and try again
          ;
prtb3   lda digit       ;get character to output
    cpx #$0         ;check to see if the last digit
    beq prtb5       ;is being output
    cmp #"0"        ;test for leading zeros
    beq prtb4
    sta lead0       ;force lead0 neg if non-zero
          ;
prtb4   
    bit lead0       ;if all leading zeros, don't
    bpl prtb6       ;output this one
prtb5   
    jsr cout        ;output digit
prtb6   
    dex             ;move to next digit
    bpl prtb1       ;quit if three digits have
    pla             ;been handled
    txa
    pla
    rts

*** prtbyt data
tbl10   
    hex 01
    hex 0a
    hex 64
          
lead0   hex 00
digit   hex 00
value   hex 00

                
********** data **********
passe   hex 00
xstart  hex 00
xend    hex 00
hauteur hex 00
interligne  hex 00

trois   hex 0300
myfac hex ffffffffffffff
fleche asc "===> "
        hex 00
int hex 3801            ; = 312

*
hi      hex 2024282C3034383C    ; high byte of HGR memory address
        hex 2024282C3034383C
        hex 2125292D3135393D
        hex 2125292D3135393D
        hex 22262A2E32363A3E
        hex 22262A2E32363A3E
        hex 23272B2F33373B3F
        hex 23272B2F33373B3F
        hex 2024282C3034383C
        hex 2024282C3034383C
        hex 2125292D3135393D
        hex 2125292D3135393D
        hex 22262A2E32363A3E
        hex 22262A2E32363A3E
        hex 23272B2F33373B3F
        hex 23272B2F33373B3F
        hex 2024282C3034383C
        hex 2024282C3034383C
        hex 2125292D3135393D
        hex 2125292D3135393D
        hex 22262A2E32363A3E
        hex 22262A2E32363A3E
        hex 23272B2F33373B3F
        hex 23272B2F33373B3F
lo      hex 0000000000000000        ; low byte of HGR memory address
        hex 8080808080808080
        hex 0000000000000000
        hex 8080808080808080
        hex 0000000000000000
        hex 8080808080808080
        hex 0000000000000000
        hex 8080808080808080
        hex 2828282828282828
        hex A8A8A8A8A8A8A8A8
        hex 2828282828282828
        hex A8A8A8A8A8A8A8A8
        hex 2828282828282828
        hex A8A8A8A8A8A8A8A8
        hex 2828282828282828
        hex A8A8A8A8A8A8A8A8
        hex 5050505050505050
        hex D0D0D0D0D0D0D0D0
        hex 5050505050505050
        hex D0D0D0D0D0D0D0D0
        hex 5050505050505050
        hex D0D0D0D0D0D0D0D0
        hex 5050505050505050
        hex D0D0D0D0D0D0D0D0
*

      
R1       hex 00
R2       hex 00
R3       hex 00
R4       hex 00
*
RANDOM  ROR R4          ; Bit 25 to carry
        LDA R3          ; Shift left 8 bits
        STA R4
        LDA R2
        STA R3
        LDA R1
        STA R2
        LDA R4          ; Get original bits 17-24
        ROR             ; Now bits 18-25 in ACC
        ROL R1          ; R1 holds bits 1-7
        EOR R1          ; Seven bits at once
        ROR R4          ; Shift right by one bit
        ROR R3
        ROR R2
        ROR
        STA R1
        RTS

*Here is a routine to seed the random number generator with a
*reasonable initial value:

INITRAND 
        LDA $4E         ; Seed the random number generator
        STA R1          ; based on delay between keypresses
        STA R3
        LDA $4F
        STA R2
        STA R4
        LDX #$20        ; Generate a few random numbers
        ldx R1
INITLOOP JSR RANDOM       ; to kick things off
        DEX
        jsr RND
        BNE INITLOOP
        RTS

*Now to wrap this in a "fill the hi-res graphics screen" routine:

NOISEGEN JSR INITRAND     ; Seed the random number generator
        LDA #$00
        STA $3C         ; Borrow monitor variables for a pointer
        LDA #$20
        STA $3D
        LDY #$00        ; Initialize the offset
        LDX #$20        ; and the page count
FILLLOOP JSR RANDOM
        STA ($3C),Y
        INY
        BNE FILLLOOP
        INC $3D
        DEX
        BNE FILLLOOP
        RTS 