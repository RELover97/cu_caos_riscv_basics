# Та же арифметика, что в rars/01_first.asm, но для Linux ELF.
.text
.globl _start
_start:
    addi t0, zero, 19   # первое слагаемое
    addi t1, zero, 23   # второе слагаемое
    add  t2, t0, t1     # результат 42
    # Служебный шаблон Linux: exit(42). Это НЕ вызов функции C.
    addi a0, t2, 0      # код завершения
    addi a7, zero, 93   # Linux RISC-V: номер системного вызова exit
    ecall
.section .note.GNU-stack,"",@progbits
