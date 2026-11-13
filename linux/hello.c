/* Только демонстрация кросс-компиляции C и подключения libc.
 * Соглашения о вызовах функций здесь не изучаем. */
#include <stdio.h>
int main(void)
{
    puts("Hello, RISC-V!");
    return 0;
}
