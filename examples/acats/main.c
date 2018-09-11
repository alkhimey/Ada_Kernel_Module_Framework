#include <linux/module.h> /* Needed by all modules */
#include <linux/slab.h>
#include <linux/kthread.h>

// Required for __class_Create to be exported.
MODULE_LICENSE("GPL");

extern void adakernelmoduleinit (void);
//extern void adakernelmodulefinal (void);

extern void ada_foo(void);
extern void ada_unfoo(void);


int init_module(void)
{
    printk(KERN_ERR "Init module.\n");    

    printk(KERN_ERR "Hello Ada.\n");
    adakernelmoduleinit();
    ada_foo();
    printk(KERN_ERR "%s\n", "After Ada");

    return 0;
}


void cleanup_module(void)
{
     ada_unfoo();
    //adakernelmodulefinal();
    printk(KERN_ERR "Goodbye Ada.\n");
}


//module_init(init_module);
//module_exit(cleanup_module);
