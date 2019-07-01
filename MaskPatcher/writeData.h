
//
//  writeData.h
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//  Inspired by https://gist.github.com/Razzile/e06957b1dc6e865b7d8377f8afe96554
//  Tested on ios10,11,12
//  For Uncover Jailbreak users please turn on get-task-allow and CS_DEBUGGED

#include <mach-o/dyld.h>
#include <mach/mach.h>
#include <dlfcn.h>
#include <stdio.h>
#include "LogView.h"

#define kCFCoreFoundationVersionNumber_iOS_12_0 1535.12
#define kCFCoreFoundationVersionNumber_iOS_11_3 1452.23
#define kCFCoreFoundationVersionNumber_iOS_11_0 1443.00

/* Get ASLR to bypass memory randomization */
uintptr_t getASLR()
{
    return _dyld_get_image_vmaddr_slide(0);
}

uintptr_t calculateASLRAddress(uintptr_t offset) {
    uintptr_t slide = getASLR();
    return (slide + offset);
}
/* Get data type */
int getType(unsigned long long data)
{
    int num =  (int)log2(data)+1;
    if(num > 16 && num <= 32) return 1;
    else if(num > 32 && num <= 64) return 2;
    else if(num <= 16) return 3;
    
    return 0;
}
/* write data to memory - 2,4,or 8 bytes */

bool writeData(uintptr_t offset, unsigned long long data) {
    kern_return_t err;
    mach_port_t port = mach_task_self();
    vm_address_t address = calculateASLRAddress(offset);
    
    //[LogView MLog:[NSString stringWithFormat:@"%lf", kCFCoreFoundationVersionNumber]];
    
    int type = getType(data);
    if(type == 1) {
        [LogView MLog:@"32 BITS"];
        data = (unsigned int)data;
        data = _OSSwapInt32(data);
    }else if(type == 2) {
        [LogView MLog:@"64 BITS"];
        data = _OSSwapInt64(data);
    }else if(type == 3) {
        data = (unsigned short)data;
        data = _OSSwapInt16(data);
    }else {
        [LogView MLog:@"Invalid bytes"];
        return false;
    }
    /* Set virtual memory permissions so that we can write */
    
    err = vm_protect(port, (vm_address_t)address, sizeof(data), false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if (err != KERN_SUCCESS) {
        [LogView MLog:@"vm_protect failure"];
        return false;
    }
    volatile uint64_t * const p_write = ((uint64_t *) address);
    *p_write = data;
    /* inline asm can also be used to write data */
    // asm volatile (
    //     "mov x0, %x[data];"
    //     "mov %x[p_write], x0;"
    //     : [p_write] "=r" (*p_write)
    //     : [data] "r" (data)
    //     : "x0"
    // );
    /* Set permissions back */
    err = vm_protect(port, (vm_address_t)address, sizeof(data), false, VM_PROT_READ | VM_PROT_EXECUTE);
    return true;
}





