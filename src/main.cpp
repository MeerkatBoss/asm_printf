#include "adapters/cdecl.h"
#include "printers/conversions.h"
#include "printers/output.h"
#include "printers/format.h"
 // TODO: Remove linkage of standard library as it is not required.
int main()
{
    char buffer[16] = "";
    int res = 0;

    res = (int) (long)call_cdecl_function(
            (cdecl_func_t)print_format,
            "Hello%c %s! Today is %d-%o-%d\n",
            ',', "MeerkatBoss", 26, 03, 2023);
    res = int_to_dec_str(res, buffer, 16);
    put_str_buffered(buffer);
    put_char_buffered('\n');

    flush_buffer(); // TODO: This can be moved to custom standard library

    return 0;
}
