.data
welcomePrompt: .asciiz "Welcome to our calculator!"
calcTypePrompt: .asciiz "What do you want to do?\n(1) Calculate a Derivative\n(2) Calculate an Integral\n"
derivativePrompt: .asciiz "Enter in an equation. Maximum of 3 terms.\nExample: 4x^2+2x+4x^3\n"

array: .space 60

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
    
    li $v0, 4
    syscall
    
    srl $a0, $a0, 5
    li $v0, 4
    syscall
    
    
    