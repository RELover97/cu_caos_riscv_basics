# Дополнительное чтение: собрать, но не запускать как программу.
# Zba, Zbb, Zbs не входят в базовый RV64I, и не обязаны работать в RARS.
.text
.globl extension_examples
extension_examples:
    sh2add t0, a0, a1   # Zba: (a0 << 2) + a1
    andn   t1, a0, a1   # Zbb: a0 & ~a1
    rev8   t2, a0       # Zbb: поменять порядок байт
    cpop   t3, a0       # Zbb: число единичных битов
    clz    t4, a0       # Zbb: ведущие нули
    ror    t5, a0, a1   # Zbb: циклический сдвиг
    bseti  t6, a0, 3    # Zbs: установить бит 3
.section .note.GNU-stack,"",@progbits
