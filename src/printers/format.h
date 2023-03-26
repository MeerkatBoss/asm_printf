/**
 * @file format.h
 * @author MeerkatBoss (solodovnikov.ia@phystech.edu)
 * 
 * @brief Formatted output functions
 *
 * @version 0.1
 * @date 2023-03-24
 *
 * @copyright Copyright MeerkatBoss (c) 2023
 */
#ifndef __FORMAT_H
#define __FORMAT_H

/**
 * @brief Print arguments based on format string. The format
 * specifiers are as follows:
 *  %c - single ASCII character
 *  %s - NUL-terminated string
 *  %d - signed decimal integer
 *  %x - unsigned hexadecimal integer
 *  %o - unsigned octal integer
 *  %b - unsigned binary integer
 *  %% - literal '%'
 *  Any other characters are printed literally
 *
 * @param[in] format string	- format specifiers
 * @param[in] ...	        - output arguments
 *
 * @return Number of characters printed
 *
 * @warning This is a CDECL function. It cannot be called directly
 * from C++. Use cdecl adapters for it.
 */
extern "C" int print_format(const char* format_string, ...);


#endif /* format.h */
