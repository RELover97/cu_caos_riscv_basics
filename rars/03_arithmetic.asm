# Задача: сравнить 64-битное и 32-битное сложение, деление.
.text
.globl main
main:
    li   t0, 1
    # shift left logical immediate
    slli t0, t0, 31     # t0 = 0x0000000080000000
    addi t0, t0, -1     # t0 = 0x000000007fffffff
   
    li   t1, 1
    # сложение по модулю 2^64 (unsigned)
    add  t2, t0, t1     # t2 = 0x0000000080000000
    # сложить младшие 32 бита и знаково расширить до 64 (signed)
    addw t3, t0, t1     # t3 = 0xffffffff80000000: расширение знака
    slli t4, t3, 32     # отбросить старшие 32 бита
    # shift right logical immediate
    srli t4, t4, 32     # t4 = 0x0000000080000000: расширение нулями
    li   t0, -17
    li   t1, 5
    # signed division
    div  t5, t0, t1     # -3: деление с округлением к нулю
    rem  t6, t0, t1     # -2: остаток, -17 = (-3)*5 + (-2)
    mv   a0, t5         # вывести частное
   
    # division by zero is defined!
    li   t0, 1
    li	 t1, 0
    div  t2, t0, t1 # t2 - 0xfff...f
    rem  t3, t0, t1 # t3 = t0

    # Служебные инструкции RARS: напечатать a0 и завершить программу.
    # Пока считаем их готовым шаблоном, механизм ecall изучим позже.
    li a7, 1
    ecall
    li a7, 10
    ecall
