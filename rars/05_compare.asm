# Задача: сравнить один и тот же битовый шаблон как signed/unsigned.
.text
.globl main

main:
    li   t0, -1         # все 64 бита равны 1
    li   t1, 1
    # set less than
    slt  t2, t0, t1     # 1: -1 < 1 в знаковом смысле
    # set less than unsigned
    sltu t3, t0, t1     # 0: 2^64-1 не меньше 1
    # set less than immdeiate
    slti t4, t1, 2      # 1: сравнение с непосредственным числом
    
    seqz t5, t3         # 1: t3 == 0 (псевдоинструкция: sltiu rd,rs,1)
    snez t6, t2         # 1: t2 != 0 (псевдоинструкция: sltu rd,zero,rs)
    mv   a0, t2         # результат знакового сравнения

    # Служебные инструкции RARS: напечатать a0 и завершить программу.
    # Пока считаем их готовым шаблоном, механизм ecall изучим позже.
    li a7, 1
    ecall
    li a7, 10
    ecall
