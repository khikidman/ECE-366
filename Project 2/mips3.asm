        .data
n:       .word 9
result:  .word 0
msg:     .asciiz "IsFibonacciOdd(n) = "
nl:      .asciiz "\n"

        .text
        .globl main
main:
        lw   $a0, n
        jal  IsFibonacciOdd
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


# $a0 = n; $v0 = 1 if Fibonacci(n) is odd, otherwise 0.
IsFibonacciOdd:
        addi $sp, $sp, -8
        sw   $ra, 4($sp)         # preserve caller's return address

        jal  fibonacci
        move $a0, $v0           # use Fibonacci(n) as the input to IsOdd
        jal  IsOdd

        lw   $ra, 4($sp)
        addi $sp, $sp, 8
        jr   $ra


# $a0 = n (0 through 46); $v0 = Fibonacci(n).
fibonacci:
        ble  $a0, 1, done_base

        li   $t0, 0
        li   $t1, 1
        addi $t2, $a0, -1

loop:
        move $t3, $t1
        add  $t1, $t0, $t1
        move $t0, $t3

        addi $t2, $t2, -1
        bne  $t2, $zero, loop

        move $v0, $t1
        jr   $ra

done_base:
        move $v0, $a0
        jr   $ra


# $a0 = nonnegative m; $v0 = 1 if m is odd, otherwise 0.
IsOdd:
        addi $sp, $sp, -8
        sw   $ra, 4($sp)

        li   $a1, 2
        jal  division

        lw   $ra, 4($sp)
        addi $sp, $sp, 8

        beq  $v0, $zero, IsOdd_false
        li   $v0, 1
        jr   $ra
IsOdd_false:
        li   $v0, 0
        jr   $ra


# $a0 = nonnegative x, $a1 = positive y.
# $v0 = remainder, $v1 = quotient, using repeated subtraction.
division:
        move $v0, $a0
        li   $v1, 0
div_loop:
        blt  $v0, $a1, div_done
        sub  $v0, $v0, $a1
        addi $v1, $v1, 1
        j    div_loop
div_done:
        jr   $ra
