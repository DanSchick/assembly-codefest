.data
welcomePrompt: .asciiz "Welcome to our calculator!"
calcTypePrompt: .asciiz "What do you want to do?\n(1) Calculate a Derivative\n(2) Calculate an Integral"

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
    
    # take user input and move that to $t0
    li $v0, 5
    syscall
    move $t0, $a0
    
    
derivative:
    # this function will handle derivative input and calculation