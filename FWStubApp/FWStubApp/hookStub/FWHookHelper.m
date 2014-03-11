//
//  FWHookHelper.m
//  FWStubApp
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWHookHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+FWSwizzle.h"


id getArgWithList(va_list* args, const char *typeDes){
    id result = nil;
    
    switch (typeDes[0]) {
    case _C_VOID:
        break;
    case _C_PTR:{
            void*ptr = va_arg(*args, void*);
            result = [NSValue valueWithPointer:ptr];
        }
        break;
    case _C_CHR: {
        char ch =  va_arg(*args, char);
        result = [NSNumber numberWithChar:ch];
    }
        break;
    case _C_SHT:{
            short num =  va_arg(*args, short);
            result = [NSNumber numberWithShort:num];
        }
        break;
    case _C_INT:{
            int num =  va_arg(*args, int);
            result = [NSNumber numberWithInt:num];
        }
        break;
    case _C_UCHR:{
            unsigned char ch =  va_arg(*args, unsigned char);
            result = [NSNumber numberWithUnsignedChar:ch];
        }
        break;
        
    case _C_UINT:{
            unsigned int ch =  va_arg(*args, unsigned int);
            result = [NSNumber numberWithUnsignedInt:ch];
        }
        break;
        
    case _C_USHT:
        {
            unsigned short ch =  va_arg(*args, unsigned short);
            result = [NSNumber numberWithUnsignedShort:ch];
        }
        break;
        
    case _C_LNG:
        {
            long ch =  va_arg(*args, long);
            result = [NSNumber numberWithLong:ch];
        }
        break;
        
    case _C_LNG_LNG:
        {
            long long ch =  va_arg(*args, long long);
            result = [NSNumber numberWithLongLong:ch];
        }
        break;
        
    case _C_ULNG:
        {
            unsigned long ch =  va_arg(*args, unsigned long);
            result = [NSNumber numberWithUnsignedLong:ch];
        }
        break;
        
    case _C_ULNG_LNG:
        {
            unsigned long long ch =  va_arg(*args, unsigned long long);
            result = [NSNumber numberWithUnsignedLongLong:ch];
        }
        break;
        
    case _C_FLT:
        {
        float rt =  va_arg(*args, float);
         result = [NSNumber numberWithFloat:rt];
        }
        break;
        
    case _C_DBL:
        {
            double rt =  va_arg(*args, double);
            result = [NSNumber numberWithDouble:rt];
        }
        break;
        
    case _C_BOOL:
        {
            BOOL ch =  va_arg(*args, BOOL);
            result = [NSNumber numberWithBool:ch];
        }
        break;
        
    case _C_CHARPTR:
        {
            char *ch = va_arg(*args, char*);
            result = [NSValue valueWithPointer:ch];
        }
        break;
        
    case _C_ID: {
        result =  va_arg(*args, id);
    }
            break;
    case _C_STRUCT_B: {
        if (strcmp(@encode(CGPoint), typeDes)==0) {
            CGPoint pt = va_arg(*args, CGPoint);
            result = [NSValue valueWithCGPoint:pt];
        }else if (strcmp(@encode(CGSize), typeDes)==0){
            CGSize sz = va_arg(*args, CGSize);
            result = [NSValue valueWithCGSize:sz];
        }else if (strcmp(@encode(CGRect), typeDes)==0){
            CGRect rt = va_arg(*args, CGRect);
            result = [NSValue valueWithCGRect:rt];
        }else{
            NSLog(@">>>unable to convert objc-C type _C_STRUCT_B :%s",typeDes);
        }
        break;
    }
        
    case _C_SEL:
        {
            SEL sel =  va_arg(*args, SEL);
            result = NSStringFromSelector(sel);
        }
        break;
        
    case _C_CLASS: {
        result =  va_arg(*args, Class);
        break;
    }
    default:
        NSLog(@">>>Unable to convert Obj-C type with type description '%s'", typeDes);
        break;
    }

    return result;
}

NSInvocation* generateInvocation(id self, SEL _cmd, va_list* args){
    NSMethodSignature *signature = [self methodSignatureForSelector:_cmd];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix, NSStringFromSelector(_cmd)];
    [invocation setSelector:NSSelectorFromString(newSeletor)];
    

    for (NSUInteger i = 2; i < length; ++i) {
        
        // The type of the argument at this index
        const char *type = [signature getArgumentTypeAtIndex:i];
        
        switch (type[0]) {
            case _C_VOID:
                break;
            case _C_PTR:{
                void*ptr = va_arg(*args, void*);
                [invocation setArgument:ptr atIndex:i];
            }
                break;
            case _C_CHR: {
                char ch =  va_arg(*args, char);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
            case _C_SHT:{
                short num =  va_arg(*args, short);
                [invocation setArgument:&num atIndex:i];
            }
                break;
            case _C_INT:{
                int num =  va_arg(*args, int);
                [invocation setArgument:&num atIndex:i];
            }
                break;
            case _C_UCHR:{
                unsigned char ch =  va_arg(*args, unsigned char);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_UINT:{
                unsigned int ch =  va_arg(*args, unsigned int);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_USHT:
            {
                unsigned short ch =  va_arg(*args, unsigned short);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_LNG:
            {
                long ch =  va_arg(*args, long);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_LNG_LNG:
            {
                long long ch =  va_arg(*args, long long);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_ULNG:
            {
                unsigned long ch =  va_arg(*args, unsigned long);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_ULNG_LNG:
            {
                unsigned long long ch =  va_arg(*args, unsigned long long);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_FLT:
            {
                float ch =  va_arg(*args, float);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_DBL:
            {
                double ch =  va_arg(*args, double);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_BOOL:
            {
                BOOL ch =  va_arg(*args, BOOL);
                [invocation setArgument:&ch atIndex:i];
            }
                break;
                
            case _C_ID: {
                id argument =  va_arg(*args, id);
                [invocation setArgument:&argument atIndex:i];
            }
                break;
            case _C_STRUCT_B: {
                if (strcmp(@encode(CGPoint), type)==0) {
                    CGPoint pt = va_arg(*args, CGPoint);
                    [invocation setArgument:&pt atIndex:i];
                }else if (strcmp(@encode(CGSize), type)==0){
                    CGSize sz = va_arg(*args, CGSize);
                    [invocation setArgument:&sz atIndex:i];
                }else if (strcmp(@encode(CGRect), type)==0){
                    CGRect rt = va_arg(*args, CGRect);
                    [invocation setArgument:&rt atIndex:i];
                }else{
                    NSLog(@">>>unable to convert objc-C type _C_STRUCT_B :%s",type);
                }
                break;
            }
                
            case _C_SEL:
            {
                SEL sel =  va_arg(*args, SEL);
                [invocation setArgument:&sel atIndex:i];
            }
                break;
                
            case _C_CLASS: {
                id cls =  va_arg(*args, Class);
                [invocation setArgument:&cls atIndex:i];
            }
                break;

            default:
            {
                // the argument is char or others
                int anInt = va_arg(*args, int);
                [invocation setArgument:&anInt atIndex:i];
                NSLog(@">>>Unable to convert Obj-C type with type description '%s'", type);
            }
                break;
        }

    }
    return invocation;
}

id getOriginReturnValue(NSInvocation*invocation , int lenth, const char*type){
    id result = nil;
    if (lenth >0) {
        switch (type[0]) {
            case _C_VOID:
                break;
            case _C_PTR:{
                void *ptr = NULL;
                [invocation getReturnValue:ptr];
                result = [NSValue valueWithPointer:ptr];
            }
                break;
            case _C_CHR: {
                char ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithChar:ch];
            }
                break;
            case _C_SHT:{
                short num;
                [invocation getReturnValue:&num];
                result = [NSNumber numberWithShort:num];
            }
                break;
            case _C_INT:{
                int num ;
                [invocation getReturnValue:&num];
                result = [NSNumber numberWithInt:num];
            }
                break;
            case _C_UCHR:{
                unsigned char ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithUnsignedChar:ch];
            }
                break;
                
            case _C_UINT:{
                unsigned int ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithUnsignedInt:ch];
            }
                break;
                
            case _C_USHT:
            {
                unsigned short ch ;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithUnsignedShort:ch];
            }
                break;
                
            case _C_LNG:
            {
                long ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithLong:ch];
            }
                break;
                
            case _C_LNG_LNG:
            {
                long long ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithLongLong:ch];
            }
                break;
                
            case _C_ULNG:
            {
                unsigned long ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithUnsignedLong:ch];
            }
                break;
                
            case _C_ULNG_LNG:
            {
                unsigned long long ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithUnsignedLongLong:ch];
            }
                break;
                
            case _C_FLT:
            {
                float rt;
                [invocation getReturnValue:&rt];
                result = [NSNumber numberWithFloat:rt];
            }
                break;
                
            case _C_DBL:
            {
                double rt;
                [invocation getReturnValue:&rt];
                result = [NSNumber numberWithDouble:rt];
            }
                break;
                
            case _C_BOOL:
            {
                BOOL ch;
                [invocation getReturnValue:&ch];
                result = [NSNumber numberWithBool:ch];
            }
                break;
                
            case _C_ID: {
                [invocation getReturnValue:&result];
            }
                break;
            case _C_STRUCT_B: {
                if (strcmp(@encode(CGPoint), type)==0) {
                    CGPoint pt;
                    [invocation getReturnValue:&pt];
                    result = [NSValue valueWithCGPoint:pt];
                }else if (strcmp(@encode(CGSize), type)==0){
                    CGSize sz;
                    [invocation getReturnValue:&sz];
                    result = [NSValue valueWithCGSize:sz];
                }else if (strcmp(@encode(CGRect), type)==0){
                    CGRect rt;
                    [invocation getReturnValue:&rt];
                    result = [NSValue valueWithCGRect:rt];
                }else{
                    NSLog(@">>>unable to convert objc-C type _C_STRUCT_B :%s",type);            
                }
                
                break;
            }
                
            case _C_SEL:
            {
                SEL sel;
                [invocation getReturnValue:&sel];
                result = NSStringFromSelector(sel);
            }
                break;
                
            case _C_CLASS: {
                [invocation getReturnValue:&result];
            }
                break;

            default:
                NSLog(@">>>Unable to convert Obj-C type with type description '%s'", type);
                break;
        }
    }
    return result;
}

#pragma mark - Private Backup
NSArray*getArgs(id self, SEL _cmd, ...){
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    va_list args;
    va_start(args, _cmd);
    va_list args_copy;
    va_copy(args_copy, args);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:_cmd];
    NSInteger nargs = [signature numberOfArguments] ;
    
    // start at 2 because to skip the automatic self and _cmd arugments
    for (NSInteger i = 2; i < nargs; i++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        id obj = getArgWithList(&args_copy, type);
        obj ? [mutArray addObject:obj] : [mutArray addObject:[NSNull null]];
        
        //You can manually get value from va_list, and then manually increment the args
        //Use va_arg will automatic increment args
        NSUInteger size = 0;
        NSGetSizeAndAlignment( type, &size, NULL );
        args += size;
    }
    
    va_end(args_copy);
    va_end(args);
    
    return [mutArray copy];
}

NSUInteger getSizeWithType(const char *typeDes){
    NSUInteger size = 0;
    NSGetSizeAndAlignment( typeDes, &size, NULL );
    return size;
}

/*
 
 for (NSUInteger i = 2; i < length; ++i) {
 
 // The type of the argument at this index
 const char *type = [signature getArgumentTypeAtIndex:i];
 
 
 // An if-elseif to find the correct argument type
 // Extendend comments only in the first two cases
 if (strcmp(@encode(id), type) == 0) {
 
 // The argument is an object
 // We obtain a pointer to the argument through va_arg, the second parameter is the lenght of the argument
 // va_arg return the pointer and then move it's pointer to the next item
 id argument = va_arg(*args, id);
 
 
 // Set the argument. The method wants a pointer to the pointer
 [invocation setArgument:&argument atIndex:i];
 }
 else if (strcmp(@encode(int), type) == 0)
 {
 // the argument is an int
 int anInt = va_arg(*args, int);
 [invocation setArgument:&anInt atIndex:i];
 }
 else if (strcmp(@encode(long), type) == 0)
 {
 // the argument is a long
 long aLong = va_arg(*args, long);
 [invocation setArgument:&aLong atIndex:i];
 }
 else if ((strcmp(@encode(double), type) == 0))
 {
 // the argument is float or double
 double aDouble = va_arg(*args, double);
 [invocation setArgument:&aDouble atIndex:i];
 }
 else if ((strcmp(@encode(float), type) == 0)){
 // the argument is float or double
 float afloat = va_arg(*args, float);
 [invocation setArgument:&afloat atIndex:i];
 }
 else if ((strcmp(@encode(CGRect), type) == 0))
 {
 // the argument is CGRect
 CGRect aRect = va_arg(*args, CGRect);
 [invocation setArgument:&aRect atIndex:i];
 }
 else
 {
 // the argument is char or others
 int anInt = va_arg(*args, int);
 [invocation setArgument:&anInt atIndex:i];
 }
 }

 */
