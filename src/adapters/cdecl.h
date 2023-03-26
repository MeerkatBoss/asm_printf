/**
 * @file cdecl.h
 * @author MeerkatBoss (solodovnikov.ia@phystech.edu)
 * 
 * @brief Adapter for calling CDECL function from C++
 *
 * @version 0.1
 * @date 2023-03-24
 *
 * @copyright Copyright MeerkatBoss (c) 2023
 */
#ifndef __CDECL_H
#define __CDECL_H

typedef void* (*cdecl_func_t)(...);

/**
 * @brief Call function at specified address using parameter list
 * 
 * @param[in]    function_address - address of function to be called
 * @param[inout] ...              - function parameters	
 *
 * @return The result of function execution
 *
 * @TODO: This should have been inline-assembly macro, but I don't
 * know those yet
 */
extern "C" void* call_cdecl_function(cdecl_func_t function, ...);

#endif /* cdecl.h */
