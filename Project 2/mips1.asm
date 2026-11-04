
.data

.text
.globl main

main:
    li $a0, 45           # n = 45
    jal fibonacci       # call fibonacci(n)

    move $a0, $v0       # print result
    li $v0, 1
    syscall

    li $v0, 10          # exit program
    syscall

fibonacci:
    # if n <= 1, return n
    ble $a0, 1, done_base

    # a = 0, b = 1
    li $t0, 0
    li $t1, 1

    # loop counter = n - 1
    addi $t2, $a0, -1

loop:
    move $t3, $t1       # temp = b
    add $t1, $t0, $t1   # b = a + b
    move $t0, $t3       # a = temp

    addi $t2, $t2, -1   # decrement counter
    bne $t2, $zero, loop

    move $v0, $t1       # return b
    jr $ra

done_base:
    move $v0, $a0       # return n
    jr $ra
