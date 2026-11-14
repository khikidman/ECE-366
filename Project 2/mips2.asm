        .data
m:       .word 13           
result:  .word 0             
msg:     .asciiz "IsOdd(m) = "
nl:      .asciiz "\n"

        .text
        .globl main
main:
        lw   $a0, m              
        jal  IsOdd              
        sw   $v0, result         

        move $t0, $v0           
        li   $v0, 4
        la   $a0, msg
        syscall
        li   $v0, 1
        move $a0, $t0
        syscall
        li   $v0, 4
        la   $a0, nl
        syscall

        li   $v0, 10             
        syscall


IsOdd:
        addi $sp, $sp, -4       
        sw   $ra, 0($sp)

        li   $a1, 2              
        jal  division            

        lw   $ra, 0($sp)         
        addi $sp, $sp, 4

        beq  $v0, $zero, IsOdd_false
        li   $v0, 1              
        jr   $ra
IsOdd_false:
        li   $v0, 0              
        jr   $ra


division:
        move $v0, $a0           
        li   $v1, 0              
div_loop:
        blt  $v0, $a1, div_done  
        sub  $v0, $v0, $a1       
        addi $v1, $v1, 1        
        j    div_loop
div_done:
        jr   $ra                 # return x (remainder)
