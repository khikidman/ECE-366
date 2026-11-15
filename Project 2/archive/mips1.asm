.data
n: .word 45
result: .word 0

.text
.globl main

main:
    lw $a0, n
    jal fibonacci

    sw $v0, result

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

fibonacci:
    ble $a0, 1, done_base

    li $t0, 0
    li $t1, 1

    addi $t2, $a0, -1

loop:
    move $t3, $t1
    add $t1, $t0, $t1
    move $t0, $t3

    addi $t2, $t2, -1
    bne $t2, $zero, loop

    move $v0, $t1
    jr $ra

done_base:
    move $v0, $a0
    jr $ra
