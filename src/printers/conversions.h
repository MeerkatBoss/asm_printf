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

/**
 * @brief Convert given unsigned integer value to hex representation and
 * store it in buffer.
 *
 * @param[in] value	        - integer to be converted
 * @param[in] buffer	    - result buffer
 * @param[in] buffer_size   - capacity of `buffer`
 *
 * @return -1 if buffer is too small to contain value representation,
 *          0 upon successful conversion
 */
extern "C" int int_to_hex_str(unsigned value, char* buffer, size_t buffer_size);

/**
 * @brief Convert given unsigned integer value to octal representation and
 * store it in buffer.
 *
 * @param[in] value	        - integer to be converted
 * @param[in] buffer	    - result buffer
 * @param[in] buffer_size   - capacity of `buffer`
 *
 * @return -1 if buffer is too small to contain value representation,
 *          0 upon successful conversion
 */
extern "C" int int_to_oct_str(unsigned value, char* buffer, size_t buffer_size);

/**
 * @brief Convert given unsigned integer value to binary representation and
 * store it in buffer.
 *
 * @param[in] value	        - integer to be converted
 * @param[in] buffer	    - result buffer
 * @param[in] buffer_size   - capacity of `buffer`
 *
 * @return -1 if buffer is too small to contain value representation,
 *          0 upon successful conversion
 */
extern "C" int int_to_bin_str(unsigned value, char* buffer, size_t buffer_size);

/**
 * @brief Convert given signed integer value to decimal representation and
 * store it in buffer.
 *
 * @param[in] value	        - integer to be converted
 * @param[in] buffer	    - result buffer
 * @param[in] buffer_size   - capacity of `buffer`
 *
 * @return -1 if buffer is too small to contain value representation,
 *          0 upon successful conversion
 */
extern "C" int int_to_dec_str(int      value, char* buffer, size_t buffer_size);

#endif /* conversions.h */
