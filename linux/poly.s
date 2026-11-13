# Схема Горнера из RARS; отдельная программа, а не функция.
.text
.globl _start
_start:
    li a0, 2            # a
    li a1, 3            # b
    li a2, 4            # c
    li a3, 5            # d
    li a4, 2            # x
    mul t0, a0, a4      # 4
    add t0, t0, a1      # 7
    mul t0, t0, a4      # 14
    add t0, t0, a2      # 18
    mul t0, t0, a4      # 36
    add t0, t0, a3      # 41
    mv a0, t0           # код завершения Linux
    li a7, 93
    ecall
.section .note.GNU-stack,"",@progbits
