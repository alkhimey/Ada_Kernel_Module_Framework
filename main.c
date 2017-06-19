#include <linux/module.h> /* Needed by all modules */
#include <linux/slab.h>

extern void adakernelmoduleinit (void);
//extern void adakernelmodulefinal (void);

extern void ada_foo(void);



int init_module(void)
{

    kmalloc(1,1);
    adakernelmoduleinit();
    printk(KERN_ERR "Hello Ada.\n");
    ada_foo();
    
    return 0;
}


void cleanup_module(void)
{
    //adakernelmodulefinal();
    printk(KERN_ERR "Goodbye Ada.\n");
}


//module_init(init_module);
//module_exit(cleanup_module);
