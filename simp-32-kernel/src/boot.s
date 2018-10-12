/* Declare constants for the multiboot header. */
.set ALIGN,      1<<0   /* Align loaded modules on page boundaries. */
.set MEMINFO,    1<<1   /* Provide memory map. */
.set FLAGS,      ALIGN | MEMINFO   /* This is the multiboot 'flag' field. */
.set MAGIC,      0x1BADB002  /* magic number lets the bootloader find the header. */
.set CHECKSUM,   -(MAGIC + FLAGS) /* checksum the above. */

/*
 * Declare the multiboot header that marks the program as akernel. 
 */
 .section   .multiboot
 .align 4
 .long  MAGIC
 .long  FLAGS
 .long  CHECKSUM

 /* Declare the stgack pointer in its own section, in order to 
  * mark it as nobits that means this file does not contain an 
  * uninitialized  stack.
  */
  .section  .bss
  .align 16
  stack_bottom:
   .skip 16834 # 16 KiB
  stack_top:

/* Define the entry point  so that the bootloader can jump to this
 * position once the kernel has been loaded.
 */
 .section .text
 .global _start
 .type _start, @function
 _start:
 /* Move stack_top to the esp register or stack pointer. */
 mov  $stack_top, %esp
 /* Now enter the kernel program. */
 call kernel_main
 /* If the system has nothing more to do then put the computer
  * in an infinite loop. 
  */
  cli  /* clear interrupt enable in flags pr diable interrupts. */
  1:  hlt
  jmp 1b
/* Finally set the size of the start symbol to the current location. 
 * useful for debugguing. 
 */
 .size _start, . - _start

