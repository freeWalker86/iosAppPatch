//
//  FWHookHelper.h
//  FWStubApp
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>


id getArgWithList(va_list* args, const char *typeDes);
NSInvocation* generateInvocation(id self, SEL _cmd, va_list* args);
id getOriginReturnValue(NSInvocation*invocation , int lenth, const char*type);



#define kHookArray                @"hookArray"
#define kHookClassName            @"hookClassName"
#define kHookClassMethodName      @"hookClassMethodName"
#define kHookClassMethod          @"hookClassMethod"


#define FW_HOOKMETHOD_MAIN                                                  \
NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];            \
[mutArray addObject:self];                                                  \
va_list args;                                                               \
va_start(args, _cmd);                                                       \
va_list args_copy;                                                          \
va_copy(args_copy, args);                                                   \
                                                                            \
NSMethodSignature *signature = [self methodSignatureForSelector:_cmd];      \
const char *returnType = [signature methodReturnType];                      \
NSInteger returnLength = [signature methodReturnLength];                    \
NSInteger argc = [signature numberOfArguments];                             \
                                                                            \
for (int i = 2; i < argc; i++) {                                            \
    const char *type = [signature getArgumentTypeAtIndex:i];                \
    id obj = getArgWithList(&args_copy, type);                              \
    obj ? [mutArray addObject:obj] : [mutArray addObject:[NSNull null]];    \
}                                                                           \
                                                                            \
NSInvocation *invocation =  generateInvocation(self, _cmd, &args);          \
                                                                            \
va_end(args_copy);                                                          \
va_end(args);                                                               \
                                                                            \
NSString *method = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]), NSStringFromSelector(_cmd)];  \
                                                                            \
id result = [shareIntance runMethod:method withArgs:[mutArray copy] callBack:^(BOOL callOriginal){      \
    [invocation invoke];                                                    \
    return getOriginReturnValue(invocation,returnLength,returnType);        \
}];                                                                         \
                                                                            \
if (result) {                                                               \
    NSLog(@">>>%@ resultClass[%@], result=[%@]",method,[result class],result); \
}



#define FW_HOOKMETHOD_NAME(_type_) fm_##_type_##_hookMethod

#define FW_HOOKMETHOD(_type_) \
static _type_ FW_HOOKMETHOD_NAME(_type_)(id self, SEL _cmd, ...)            \
{                                                                           \
    FW_HOOKMETHOD_MAIN                                                      \
                                                                            \
    _type_ returnValue = 0 ;                                                \
    if ([result isKindOfClass:[NSValue class]]) {                           \
        NSValue* value = (NSValue*) result;                                 \
        if (strcmp([value objCType], @encode(_type_)) == 0 || strcmp([value objCType], "i") == 0 ) {   \
            [value getValue:&returnValue];                                  \
        }                                                                   \
        return returnValue;                                                 \
    }                                                                       \
    return (_type_)result;                                                  \
}


#define FW_HOOKMETHOD_EX(_type_) \
static _type_ FW_HOOKMETHOD_NAME(_type_)(id self, SEL _cmd, ...)            \
{                                                                           \
    FW_HOOKMETHOD_MAIN                                                      \
                                                                            \
    _type_ returnValue ;                                                    \
    if ([result isKindOfClass:[NSValue class]]) {                           \
        NSValue* value = (NSValue*) result;                                 \
                                                                            \
        if (strcmp([value objCType], @encode(_type_)) == 0 || strcmp([value objCType], "i") == 0 ) {   \
            [value getValue:&returnValue];                                  \
            return returnValue;                                             \
        }                                                                   \
    }                                                                       \
    return returnValue;                                                     \
}

