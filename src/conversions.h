/**
 * @file conversions.h
 * @author MeerkatBoss (solodovnikov.ia@phystech.edu)
 * 
 * @brief ASM string conversion function declarations
 *
 * @version 0.1
 * @date 2023-03-22
 *
 * @copyright Copyright MeerkatBoss (c) 2023
 */
#ifndef __CONVERSIONS_H
#define __CONVERSIONS_H

#include <stddef.h>

extern "C" int int_to_hex_str(unsigned value, char* buffer, size_t buffer_size);

extern "C" int int_to_bin_str(unsigned value, char* buffer, size_t buffer_size);

extern "C" int int_to_dec_str(int value, char* buffer, size_t buffer_size);

#endif /* conversions.h */
