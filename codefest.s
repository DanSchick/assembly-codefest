.data
welcomePrompt: .asciiz "Welcome to our calculator!"
calcTypePrompt: .asciiz "What do you want to do?\n(1) Calculate a Derivative\n(2) Calculate an Integral\n"
derivativePrompt: .asciiz "Enter in an equation. Maximum of 3 terms.\nExample: 4x^2+2x+4x^3\n"

plusHex: .byte 0x2B
minusHex: .byte 0x2D
caretHex: .byte 0x5E
xHex: .byte 0x78

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
    
    # srl $a0, $a0, 5
    # li $v0, 4
    # syscall
    
    j tokenize
    
    
tokenize:
    # this function takes a user input array in $a0 and reads each term into seperate registers
    li $v0, 4
    syscall
    
    
    
    
    j getTerm1
    
    
getTerm1:
    move $s1, $a1
    # lb $s1, $a1
    li $s2, 0
    
    lb $t0, 0($a0)
    lb $t1, 1($a0)
    lb $t2, 2($a0)
    lb $t3, 3($a0)
    lb $t4, 4($a0)
    j firstCharacter
    
addToA1:
    sb $s7, 0($s1)
    # addi $s2, 4
    # add $s3, $s2, $a1
    # move $s1, $s3
    
    jr $ra
     
firstCharacter:
    lb $s0, minusHex
    beq $t0, $s0, operationMinus
    lb $s0, xHex
    beq $t0, $s0, x
    move $s6, $t0
    
    jr number
    
    j secondCharacter

secondCharacter:
    lb $s0, xHex
    beq $t1, $s0,  x
    lb $s0, caretHex
    beq $t1, $s0,  caret
    lb $s0, minusHex
    beq $t1, $s0, getTerm2
    lb $s0, plusHex
    beq $t1, $s0, getTerm2
    move $s6, $t1
    
    jr number
    
    j thirdCharacter
    
thirdCharacter:
    lb $s0, xHex
    beq $t2, $s0, x
    lb $s0, caretHex
    beq $t2, $s0, caret
    lb $s0, minusHex
    beq $t2, $s0, getTerm2
    lb $s0, plusHex
    beq $t2, $s0, getTerm2
    move $s6, $t2
    jr number
    
    j fourthCharacter
    
fourthCharacter:
    lb $s0, caretHex
    beq $t3, $s0, caret
    lb $s0, minusHex
    beq $t3, $s0, getTerm2
    lb $s0, plusHex
    beq $t3, $s0, getTerm2
    move $s6, $t3
    
    jr number
    
    j fifthCharacter
    
fifthCharacter:
    lb $s0, minusHex
    beq $t4, $s0, getTerm2
    lb $s0, plusHex
    beq $t4, $s0, getTerm2
    move $s6, $t4
    
    jr number
    
    j getTerm2
    
operationMinus:
    lb $s7, minusHex
    jr addToA1
    jr $ra
    
operationPlus:
    lb $s7, plusHex
    jr addToA1
    jr $ra
caret:
    lb $s7, caretHex
    jr addToA1
    jr $ra
x:
    lb $s7, xHex
    jr addToA1
    jr $ra

number:
    move $s7, $s6
    jr addToA1
    jr $ra



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