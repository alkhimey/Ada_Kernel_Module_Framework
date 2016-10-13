#include <linux/module.h> /* Needed by all modules */
#include <linux/kernel.h> /* Needed for KERN_INFO */

extern void adainit (void);
extern void adafinal (void);
extern int ada_foo(void);

int init_module(void)
{
    adainit();
    printk(KERN_ERR "Hello Ada %d.\n", ada_foo());
 
    return 0;
}


void cleanup_module(void)
{
    adafinal();
    printk(KERN_ERR "Goodbye Ada.\n");
}

