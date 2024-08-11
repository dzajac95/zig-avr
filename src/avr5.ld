/* Script for -n: mix text and data on same page */
/* Copyright (C) 2014-2015 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */
OUTPUT_FORMAT("elf32-avr","elf32-avr","elf32-avr")
OUTPUT_ARCH(avr:5)
__TEXT_REGION_LENGTH__ = DEFINED(__TEXT_REGION_LENGTH__) ? __TEXT_REGION_LENGTH__ : 32K;
__DATA_REGION_LENGTH__ = DEFINED(__DATA_REGION_LENGTH__) ? __DATA_REGION_LENGTH__ : 2K;
__DATA_REGION_ORIGIN__ = DEFINED(__DATA_REGION_ORIGIN__) ? __DATA_REGION_ORIGIN__ : 0x800100;
MEMORY
{
  FLASH   (rx)   : ORIGIN = 0, LENGTH = __TEXT_REGION_LENGTH__
  RAM     (rw!x) : ORIGIN = __DATA_REGION_ORIGIN__, LENGTH = __DATA_REGION_LENGTH__
}
SECTIONS
{
  /* Internal text space or external memory.  */
  .text   :
  {
    *(.vectors)
    KEEP(*(.vectors))
    *(.text*)
  }  > FLASH

  .data :
  {
     __data_start = . ;
    *(.data*)
    *(.rodata*)
    . = ALIGN(2);
     _edata = . ;
     __data_end = . ;
  }  > RAM AT> FLASH

  .bss (NOLOAD) :
  {
     __bss_start = . ;
    *(.bss*)
     __bss_end = . ;
  }  > RAM
   __data_load_start = LOADADDR(.data);
   __data_load_end = __data_load_start + SIZEOF(.data);
}
