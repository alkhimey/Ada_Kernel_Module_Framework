/****************************************************************************
 *                                                                          *
 *                    LINUX MODULE DEVELOPMENT BINDINGS                     *
 *                                                                          *
 *                       L I N U X - W R A P P E R S                        *
 *                                                                          *
 *                          C Implementation File                           *
 *                                                                          *
 *          Copyright (C) 2017, Artium Nihamkin, artium@nihamkin.com        *
 *                                                                          *
 * GNAT is free software;  you can  redistribute it  and/or modify it under *
 * terms of the  GNU General Public License as published  by the Free Soft- *
 * ware  Foundation;  either version 3,  or (at your option) any later ver- *
 * sion.  GNAT is distributed in the hope that it will be useful, but WITH- *
 * OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY *
 * or FITNESS FOR A PARTICULAR PURPOSE.                                     *
 *                                                                          *
 *                                                                          *
 *                                                                          * 
 *                                                                          * 
 *                                                                          *
 * You should have received a copy of the GNU General Public License and    *
 * a copy of the GCC Runtime Library Exception along with this program;     *
 * see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    *
 * <http://www.gnu.org/licenses/>.                                          *
 *                                                                          *
 * GNAT was originally developed  by the GNAT team at  New York University. *
 * Extensive contributions were provided by Ada Core Technologies Inc.      *
 *                                                                          *
 ****************************************************************************/
 
 /*
 *  Some linux functions are macro definitions or have the __always_inline
 *  derictive. This file is used to facilitate the import of these functions
 *  into Ada code.
 *
 *  This file is required mostly for the RTS but it is more convinient to
 *  compiled it in the kbuild build stage and linked into the lernel module.
 */
 
 
#include <linux/printk.h>
#include <linux/slab.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/module.h>

/* 
 * #include <linux/printk.h>
 *
 **/

typedef enum {
    DEFAULT   = 0,  
    EMERGENCY = 1, 
    ALERT     = 2,
    CRITICAL  = 3, 
    ERROR     = 4,     
    WARNING   = 5,
    NOTICE    = 6,   
    INFO      = 7,
    DEBUG     = 8
} PrintkLevelType;


void printk_wrapper(char* str, PrintkLevelType level)
{
    switch(level) {
        case DEFAULT:
            printk(KERN_DEFAULT "%s\n", str);
            break;
        case EMERGENCY:
            printk(KERN_EMERG "%s\n", str);
            break;
        case ALERT:
            printk(KERN_ALERT "%s\n", str);
            break;
        case CRITICAL:
            printk(KERN_CRIT "%s\n", str);
            break;
        case ERROR:
            printk(KERN_ERR "%s\n", str);
            break;
        case WARNING:
            printk(KERN_WARNING "%s\n", str);
            break;
        case NOTICE:
            printk(KERN_NOTICE "%s\n", str);
            break;
        case INFO:
            printk(KERN_INFO "%s\n", str);
            break;
        case DEBUG:
            printk(KERN_DEBUG "%s\n", str);
            break;
        default:
            printk(KERN_DEFAULT "%s\n", str);
    }
}

/* 
 * #include <linux/slab.h>
 *
 **/

void *kmalloc_wrapper(size_t size, gfp_t flags) {
    return kmalloc(size, flags);
}



/* 
 * #include <linux/kdev_t.h>
 *
 **/

const unsigned minor_max = (1 << MINORBITS) - 1;
const unsigned major_max = (1 << (sizeof(dev_t) * 8 /* CHAR_BIT */ - MINORBITS)) - 1;


/**
 * #include <linux/fs.h>
 **/
int register_chrdev_wrapper(unsigned int major, const char*name, struct file_operations*ops)
{
    return register_chrdev(major, name, ops);
}

void unregister_chrdev_wrapper(unsigned int major, const char *name)
{
    unregister_chrdev(major, name);
}

/**
 * #include <linux/export.h>
 */
struct module * this_module = THIS_MODULE;





