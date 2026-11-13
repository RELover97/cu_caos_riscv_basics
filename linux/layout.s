# Данные для исследования ELF, НЕ программа для запуска.
# Здесь нет ни одной инструкции чтения или записи в память.
.section .rodata
message: .asciz "Hi"
.data
.globl data1
.balign 4
data1: .word 0x11223344
.byte 0x55
.balign 8               # GNU: выровнять по 8 байтам
wide: .dword 0x0102030405060708
end_data:
.equ DATA_SIZE, end_data-data1 # константа, не отдельная ячейка
.bss
.balign 8
buffer: .zero 16        # нулевое содержимое без 16 байт в файле
.section .note.GNU-stack,"",@progbits
