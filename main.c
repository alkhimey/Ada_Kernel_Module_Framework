#include <linux/module.h> /* Needed by all modules */
#include <linux/slab.h>
#include <linux/kthread.h>

extern void adakernelmoduleinit (void);
//extern void adakernelmodulefinal (void);

extern void ada_foo(void);

static struct task_struct *task;


/**
 * Ada's part is wrapped in a kernel thread.
 * If an exception is raised and not handled,
 * the last chance handler will terminate the 
 * container thread.
 * 
 */
int init_thread(void *data)
{
    printk(KERN_ERR "Hello Ada.\n");
    adakernelmoduleinit();
    ada_foo();
    printk(KERN_ERR "%s\n", "After Ada");
    return 0; // ?
}


int init_module(void)
{
    int err;
    printk(KERN_ERR "Init module.\n");    

    task = kthread_run(init_thread, (void *)NULL, "init_thread");
 
    if(IS_ERR(task)){ 
        printk("Unable to start kernel thread.\n");
        return PTR_ERR(task);
    }
//    return 0;
    err = kthread_stop(task);
    printk("%d\n", err);
    return 0;
}


void cleanup_module(void)
{
    //adakernelmodulefinal();
    printk(KERN_ERR "Goodbye Ada.\n");
}


//module_init(init_module);
//module_exit(cleanup_module);
