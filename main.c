#include <linux/module.h> /* Needed by all modules */
#include <linux/kernel.h> /* Needed for KERN_INFO */

extern void adakernelmoduleinit (void);
//extern void ada_foo_libfinal (void);

extern int ada_foo(void);

int init_module(void)
{
    adakernelmoduleinit();
    printk(KERN_ERR "Hello Ada %d.\n", ada_foo());
 
    return 0;
}


void cleanup_module(void)
{
    //ada_foo_libfinal();
    printk(KERN_ERR "Goodbye Ada.\n");
}

