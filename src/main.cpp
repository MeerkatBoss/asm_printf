#include <stdio.h>

#include "conversions.h"

int main()
{
    char buffer[16] = "";
    int res = int_to_hex_str(0xBEEF, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    res = int_to_bin_str(0xAA, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    res = int_to_dec_str(-512, buffer, 16);
    if (res != 0) puts("error");
    else          puts(buffer);

    return 0;
}
