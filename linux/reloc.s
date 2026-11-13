# Ассемблер не знает адрес data1: он определён в layout.s.
# Линкер должен заполнить восьмибайтовое поле правильным адресом.
.data
.globl data_address
.balign 8
data_address: .dword data1
.section .note.GNU-stack,"",@progbits
