.data
welcomePrompt: .asciiz "Welcome to our calculator!"
calcTypePrompt: .asciiz "What do you want to do?\n(1) Calculate a Derivative\n(2) Calculate an Integral\n"
derivativePrompt: .asciiz "Enter in an equation. Maximum of 3 terms.\nExample: 4x^2+2x+4x^3\n"

plusHex: .byte 0x2B
minusHex: .byte 0x2D
caretHex: .byte 0x77
xHex: .byte 0x78
zeroHex: .byte '0'
oneHex: .byte '1'
twoHex: .byte '2'
threeHex: .byte '3'
fourHex: .byte '4'
fiveHex: .byte '5'
sixHex: .byte '6'
sevenHex: .byte '7'
eightHex: .byte '8'
nineHex: .byte '9'
array: .space 60
sanitizedArr: .word '0','0','0','0','0','0','0','0','0','0'

.text
.globl main
main:
    li $v0, 4
    la $a0, welcomePrompt
    syscall
    
    j loopstart
    

loopstart:
    # this is the function that will select which type of calculation to do
    # first print out the prompt
    li $v0, 4
    la $a0, calcTypePrompt
    syscall
    
    # take user
    li $v0, 5
    syscall
    
    li $t0, 1
    beq $a0, $t0, derivative
    
    
derivative:
    # this function will handle derivative input and calculation
    # print prompt
    li $v0, 4
    la $a0, derivativePrompt
    syscall
    
    
    li $v0, 8
    la $a0, array
    li $a1, 60
    syscall
    
    la $a1, sanitizedArr
    
    j tokenize
    
    
tokenize:
    # this function takes a user input array in $a0 and reads each term into seperate registers
    li $v0, 4
    syscall
    
    j getTerm1
    
    
getTerm1:
    move $s1, $a1 # load start of arr
    # lb $s1, $a1
    li $s2, 0 # index of array (i)
    
    li $v1, 0 # for branch checking
    li $t9, 0
    
    lb $t0, 0($a0) #Loads each byte into General Purpose registers
    lb $t1, 1($a0)
    lb $t2, 2($a0)
    lb $t3, 3($a0)
    lb $t4, 4($a0)
    j firstCharacter
    
addToA1:
    sb $s7, 0($s1)
    addi $s2, $s2, 4
    add $s3, $s2, $a1
    move $s1, $s3
    
    j selectNextCharacter
     
firstCharacter:
    li $s4, 0
    lb $s0, minusHex
    beq $t0, $s0, operationMinus
    lb $s0, xHex
    beq $t0, $s0, x
    move $s6, $t0
    
    beq $v1, $s4, number
    

secondCharacter:
    li $s4, 0
    lb $s0, xHex
    beq $t1, $s0, x
    lb $s0, caretHex
    beq $t1, $s0, caret
    lb $s0, minusHex
    beq $t1, $s0, getTerm2
    lb $s0, plusHex
    beq $t1, $s0, getTerm2
    move $s6, $t1
    
    beq $v1, $s4, number
    
    
thirdCharacter:
    li $s4, 0
    lb $s0, xHex
    beq $t2, $s0, x
    lb $s0, caretHex
    beq $t2, $s0, caret
    lb $s0, minusHex
    beq $t2, $s0, getTerm2
    lb $s0, plusHex
    beq $t2, $s0, getTerm2
    move $s6, $t2
    
    beq $v1, $s4, number
    
    
fourthCharacter:
    li $s4, 0
    lb $s0, caretHex
    beq $t3, $s0, caret
    lb $s0, minusHex
    beq $t3, $s0, getTerm2
    lb $s0, plusHex
    beq $t3, $s0, getTerm2
    move $s6, $t3
    
    beq $v1, $s4, number
    
fifthCharacter:
    li $s4, 0
    lb $s0, minusHex
    beq $t4, $s0, getTerm2
    lb $s0, plusHex
    beq $t4, $s0, getTerm2
    move $s6, $t4
    
    beq $v1, $s4, number
    
    
operationMinus:
    li $s4, 1
    lb $s7, minusHex
    j addToA1
    
    
operationPlus:
    li $s4, 1
    lb $s7, plusHex
    j addToA1
    
caret:
    li $s4, 1
    lb $s7, caretHex
    j addToA1
x:
    li $s4, 1
    lb $s7, xHex
    j addToA1

number:
    # move $s7, $s6
    li $s0, 31
    beq $s6, $s0, if1
    li $s0, 32
    beq $s6, $s0, if2
    li $s0 33
    beq $s6, $s0, if3
    li $s0, 34
    beq $s6, $s0, if4
    li $s0, 35
    beq $s6, $s0, if5
    li $s0, 36
    beq $s6, $s0, if6
    li $s0, 37
    beq $s6, $s0, if7
    li $s0, 38
    beq $s6, $s0, if8
    li $s0, 39
    beq $s6, $s0, if9
    j addToA1
    
if1: 
    lb $s7, oneHex
    j addToA1
if2: 
    lb $s7, twoHex
    j addToA1
if3: 
    lb $s7, threeHex
    j addToA1
if4: 
    lb $s7, fourHex
    j addToA1
if5: 
    lb $s7, fiveHex
    j addToA1
if6: 
    lb $s7, sixHex
    j addToA1
if7: 
    lb $s7, sevenHex
    j addToA1
if8: 
    lb $s7, eightHex
    j addToA1
if9: 
    lb $s7, nineHex
    j addToA1


selectNextCharacter:
    addi $t9, $t9, 1
    li $t8, 1
    beq $t9, $t8, secondCharacter
    
    li $t8, 2
    beq $t9, $t8, thirdCharacter
    
    li $t8, 3
    beq $t9, $t8, fourthCharacter
    
    li $t8, 4
    beq $t9, $t8, fifthCharacter
    
    li $t8, 5
    beq $t9, $t8, getTerm2
    
    
getTerm2:
    li $v0, 10
    syscall

    
    
    
    
    
    
    
    # lb $t0, 0($a0)
    # lb $t1, 1($a0)
    # lb $t2, 2($a0)
    # lb $t3, 3($a0)
    # lb $t4, 4($a0)
    # lb $t5, 5($a0)
    # lb $s0, 6($a0)
    # lb $s1, 7($a0)                                                                      
    # lb $s2, 8($a0)
    # lb $s3, 9($a0)
    # lb $s4, 10($a0)
    # lb $s5, 11($a0)
    # lb $s6, 12($a0)
    # lb $s7, 13($a0)
    # lb    , 14($a0)
    # lb    , 15($a0)