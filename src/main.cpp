#include "adapters/cdecl.h"
#include "printers/conversions.h"
#include "printers/output.h"
#include "printers/format.h"
int main()
{
    char buffer[16] = "";
    int res = 0;

    res = (int) (long)call_cdecl_function( // TODO: This looks really awkward
            (cdecl_func_t)print_format,
            "%s!\n", "Hello, World");

    res = int_to_dec_str(res, buffer, 16);
    put_str_buffered(buffer);
    put_char_buffered('\n');

    return 0;
}
