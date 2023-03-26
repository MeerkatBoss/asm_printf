/**
 * @file output.h
 * @author MeerkatBoss (solodovnikov.ia@phystech.edu)
 * 
 * @brief Formatted output function declarations for assembly implementation
 *
 * @version 0.1
 * @date 2023-03-23
 *
 * @copyright Copyright MeerkatBoss (c) 2023
 */
#ifndef __OUTPUT_H
#define __OUTPUT_H

/**
 * @brief Prints character to stdout. '\n' forces buffer flush.
 *
 * @param[in] character     printed character
 *
 * @return 0 upon success, -1 upon IO error
 *
 */
extern "C" int put_char_buffered(char character);

/**
 * @brief Prints NUL-terminated string to stdout.
 *
 * @param[in] str           printed string
 *
 * @return number of characters printed upon success, -1 upon IO error
 *
 */
extern "C" int put_str_buffered(const char* str);

/**
 * @brief Empties output buffer and outputs its contents to `stdout`
 *
 * @return 0 upon success, -1 upon IO error
 *
 */
extern "C" int flush_buffer(void);

#endif /* output.h */
