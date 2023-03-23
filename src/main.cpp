#include <stdio.h>

#include "printers/conversions.h"
#include "printers/output.h"

int main()
{
    char buffer[16] = "";
    int res = int_to_hex_str(0xDEADBEEF, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    res = int_to_bin_str(0xAA, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    res = int_to_dec_str(-512, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    const char* str = "Hello, world!\n";
    for (int i = 0; i < 14; i++)
        put_char_buffered(str[i]);

    flush_buffer();

    return 0;
}
