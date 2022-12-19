* ROM routines
        lst off
*
home    equ $FC58
text    equ $FB2F
cout    equ $FDED
vtab    equ $FC22
getln   equ $FD6A
bascalc equ $FBC1
return  equ $FD8E      ; print carriage return
clreop  equ $FC42      ; clear from cursor to end of page
clreol  equ $FC9C      ; clear from cursor to end of line
xtohex  equ $F944
rdkey   equ $FD0C      ; wait for keypress
auxmov  equ $C311
xfer    equ $C314
wait    equ $FCA8
outport equ $FE95
*
* page  
*
cv      equ $25
ch      equ $24 
wndlft  equ $20
wndwdth equ $21
wndtop  equ $22
wndbtm  equ $23 
prompt  equ $33
*
*
* ROM switches
*
settext  equ $c051      ; display text
stor80   equ $C001
graphics equ $C050
mixoff   equ $C052      ; = C053 MIXSET 
mixclr   equ $C052      ; Display Full Screen
hires    equ $C057
dhgr     equ $C05E
page1    equ $C054
page2    equ $C055
clr80col equ $C000 
vbl      equ $C019   
kbd      equ $C000
kbdstrb  equ $C010  