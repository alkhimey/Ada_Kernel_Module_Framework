
//#include <stdint.h>
#include <linux/types.h

void print_kernel_chars(char* s)
{
  printk(KERN_ERR "%s\n", s);
}

void print_kernel_uint32_t(uint32_t d)
{
  printk(KERN_ERR "%d\n", d);
}

void print_kernel_int32_t(int32_t d)
{
  printk(KERN_ERR "%d\n", d);
}
