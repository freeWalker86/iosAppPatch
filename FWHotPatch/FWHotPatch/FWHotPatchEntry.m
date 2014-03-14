//
//  FWHotPatchEntry.m
//  FWHotPatch
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWHotPatchEntry.h"
#import "NSObject+FWIvarAccess.h"
#import "FWFixedStubObject.h"
#import <objc/runtime.h>
#import <objc/message.h>


#define FWAssertTrue(expression, format...)   FWAssertTrue(expression, ## format)

void FWAssertTrue(BOOL expr, NSString *error){
    if (!expr) {
        NSLog(@"%@",error);
    }
}

@interface FWHotPatchEntry()
@property(nonatomic, copy)FWCallBackBlock callBack;
@property(nonatomic, strong)NSArray *args;
@end

@implementation FWHotPatchEntry



#pragma mark - Public  Method
- (id)runMethod:(NSString*)method withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack{
    if (method) {
        NSLog(@">>>FWHotPatchEntry  args=%@",args);
        NSLog(@">>>FWHotPatchEntry  callBack= %@",callBack);
        NSLog(@">>>FWHotPatchEntry  method=%@",method);
        method = [method stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        self.args     = args;
        self.callBack = callBack;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:method message:@"Display this message in bundle patch" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        if ([self respondsToSelector:NSSelectorFromString(method)]) {
           return [self performSelector:NSSelectorFromString(method) withObject:nil];
        }else{
            NSLog(@">>>unrecognized selector %@",method);
        }
    }
    return nil;
}



#pragma mark - Private Method
#pragma mark >>>>>>FWStubObject Test<<<<<<
- (void)FWStubObject_sayHello{
    if ([self.args count]>0) {
        id tmpSelf = [self.args objectAtIndex:0];
        [tmpSelf setIvar:@"_privateName" withObject:@"FWStubObject_sayHello"];
        if (self.callBack) {
            self.callBack(YES);
        }
    }
    
}

- (void)FWStubObject_ivarAccess{
    if ([self.args count]>0) {
        id tmpSelf = [self.args objectAtIndex:0];
        if ([tmpSelf isKindOfClass:NSClassFromString(@"FWStubObject")]) {
            [self ivarAccessor:tmpSelf];
            if (self.callBack) {
                self.callBack(YES);
            }
        }
    }
}

- (NSArray*)FWStubObject_testClassMethod_arg2_arg3_{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    [mutArray addObject:NSStringFromSelector(_cmd)];
    [mutArray addObjectsFromArray:self.args];
    return [mutArray copy];
}

- (NSDictionary*)FWStubObject_testStr_array_dict_{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutDict setObject:[self.args copy] forKey:@"originalArgs"];
    [mutDict setObject:NSStringFromSelector(_cmd) forKey:@"method"];
    return [mutDict copy];
    //return @{@"method":NSStringFromSelector(_cmd)};
}

- (NSArray*)FWStubObject_testBool_intV_longV_floatV_doubleV_{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    [mutArray addObject:NSStringFromSelector(_cmd)];
    [mutArray addObjectsFromArray:self.args];
    return [mutArray copy];
}

- (NSArray*)FWStubObject_testPoint_size_rect_{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    [mutArray addObject:NSStringFromSelector(_cmd)];
    [mutArray addObjectsFromArray:self.args];
    return [mutArray copy];
}

#pragma mark - FWStubObject Getter & Call super & call original method by objc_msgSend
- (id    )FWStubObject_getObject{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    //call original method
    id tmpSelf = [self.args objectAtIndex:0];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix,@"getObject"];
    SEL sel =  NSSelectorFromString(newSeletor);
    id rt = objc_msgSend(tmpSelf,sel);
    
    FWAssertTrue([objc_msgSend(tmpSelf,sel) isEqualToString:@"1212"], [NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    //call super method
    struct objc_super super1;
    super1.receiver = tmpSelf;
    super1.super_class = class_getSuperclass([tmpSelf class]);
    FWAssertTrue([objc_msgSendSuper(&super1, @selector(getObject)) isEqualToString:@"_privateObj"],[NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    return NSStringFromSelector(_cmd);
}

- (NSString*)FWStubObject_getStr{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    //call original method
    id tmpSelf = [self.args objectAtIndex:0];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix,@"getStr"];
    SEL sel =  NSSelectorFromString(newSeletor);
    FWAssertTrue([objc_msgSend(tmpSelf,sel) isEqualToString:@"string"], [NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    //call super method
    struct objc_super super1;
    super1.receiver = tmpSelf;
    super1.super_class = class_getSuperclass([tmpSelf class]);
    FWAssertTrue([objc_msgSendSuper(&super1, @selector(getStr)) isEqualToString:@"string"],[NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    return  NSStringFromSelector(_cmd);
}
- (id    )FWStubObject_getInt{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    //call original method
    id tmpSelf = [self.args objectAtIndex:0];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix,@"getInt"];
    SEL sel =  NSSelectorFromString(newSeletor);
    FWAssertTrue((int)objc_msgSend(tmpSelf, sel) ==32767 , [NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    //call super method
    struct objc_super super1;
    super1.receiver = tmpSelf;
    super1.super_class = class_getSuperclass([tmpSelf class]);
    FWAssertTrue((int)objc_msgSendSuper(&super1, @selector(getInt)) ==32765,[NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    return [NSNumber numberWithInt:11];
}
- (id   )FWStubObject_getLong{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSNumber numberWithLong:1111L];
}
- (id  )FWStubObject_getFloat{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSNumber numberWithFloat:11.223];
}
- (id )FWStubObject_getDouble{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSNumber numberWithDouble:11.34434];
}
- (id)FWStubObject_getPoint{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSValue valueWithCGPoint:CGPointMake(23.9, 343.09)];
}
- (id )FWStubObject_getSize{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    
    //call original method
    id tmpSelf = [self.args objectAtIndex:0];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix,@"getSize"];
    SEL sel =  NSSelectorFromString(newSeletor);
    FWAssertTrue(CGSizeEqualToSize(((CGSize(*)(id, SEL))objc_msgSend)(tmpSelf, sel), CGSizeMake(100.08, 22.89)), [NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    //call super method
    struct objc_super super1;
    super1.receiver = tmpSelf;
    super1.super_class = class_getSuperclass([tmpSelf class]);
    FWAssertTrue(CGSizeEqualToSize(((CGSize(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getSize)), CGSizeMake(100.08, 22.89)),[NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    return [NSValue valueWithCGSize: CGSizeMake(90.08, 202.89)];
}
- (id )FWStubObject_getRect{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    
    //call original method
    id tmpSelf = [self.args objectAtIndex:0];
    NSString *newSeletor = [NSString stringWithFormat:@"%@%@",kFWSwizzlePrefix,@"getRect"];
    SEL sel =  NSSelectorFromString(newSeletor);
    FWAssertTrue(CGRectEqualToRect(((CGRect(*)(id, SEL))objc_msgSend_stret)(tmpSelf, sel), CGRectMake(0.22, 43.7, 55.89, 90)), [NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    //call super method
    struct objc_super super1;
    super1.receiver = tmpSelf;
    super1.super_class = class_getSuperclass([tmpSelf class]);
    FWAssertTrue(CGRectEqualToRect(((CGRect(*)(id, SEL))objc_msgSendSuper_stret)((__bridge id)(&super1), @selector(getRect)), CGRectMake(0.22, 43.7, 55.89, 90)),[NSString stringWithFormat:@"Assert Failed At Function:%s Line: %d",__func__, __LINE__]);
    
    return [NSValue valueWithCGRect:CGRectMake(22, 80, 245, 190)];
}

- (id )FWStubObject_getClassObject{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return  NSStringFromSelector(_cmd);
}

- (id )FWStubObject_getClassFloat{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSNumber numberWithFloat:11.223];
}

- (id )FWStubObject_getClassSize{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return [NSValue valueWithCGSize: CGSizeMake(90.08, 202.89)];
}

- (void)ivarAccessor:(id)obj{
    
    [obj setIvar:@"_privateChar" withChar:'d'];
    
    FWAssertTrue([obj getIvarChar:@"_privateChar"]=='d',[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateShort" withShort:32767];
    FWAssertTrue([obj getIvarShort:@"_privateShort"]==32767,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateInt" withInt:32767];
    FWAssertTrue([obj getIvarInt:@"_privateInt"]==32767,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateLong" withLong:2147483647];
    FWAssertTrue([obj getIvarLong:@"_privateLong"]==2147483647,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateLongLong" withLongLong:9223372036854775807];
    FWAssertTrue([obj getIvarLongLong:@"_privateLongLong"]==9223372036854775807,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateFloat" withFloat:-20];
    FWAssertTrue([obj getIvarFloat:@"_privateFloat"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateDouble" withDouble:-20];
    FWAssertTrue([obj getIvarDouble:@"_privateDouble"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedChar" withUnsignedChar:'d'];
    FWAssertTrue([obj getIvarUnsignedChar:@"_privateUnsignedChar"]=='d',[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedShort" withUnsignedShort:65535];
    FWAssertTrue([obj getIvarUnsignedShort:@"_privateUnsignedShort"]==65535,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedInt" withUnsignedInt:65535];
    FWAssertTrue([obj getIvarUnsignedInt:@"_privateUnsignedInt"]==65535,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedLong" withUnsignedLong:4294967295];
    FWAssertTrue([obj getIvarUnsignedLong:@"_privateUnsignedLong"]==4294967295,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    
    unsigned long long value = 1844674407370955161;//18446744073709551615
    [obj setIvar:@"_privateLongLong" withUnsignedLongLong:value];
    FWAssertTrue([obj getIvarUnsignedLongLong:@"_privateLongLong"]==value,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateBool" withBool:YES];
    FWAssertTrue([obj getIvarBool:@"_privateBool"]==YES,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    void *pt = (__bridge void*)self;
    [obj setIvar:@"_privatePointer" withPointer:(void*)self];
    FWAssertTrue([obj getIvarPointer:@"_privatePointer"]==pt,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    NSString *name = @"name";
    [obj setIvar:@"_privateObject" withObject:name];
    FWAssertTrue([obj getIvarObject:@"_privateObject"]==name,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateCGFloat" withFloat:-20];
    FWAssertTrue([obj getIvarFloat:@"_privateCGFloat"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    
    
    [obj setIvar:@"_privatePoint" withCGPoint:CGPointMake(10, 10)];
    FWAssertTrue( CGPointEqualToPoint(CGPointMake(10, 10), [obj getIvarCGPoint:@"_privatePoint"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateSize" withCGSize:CGSizeMake(20, 40)];
    FWAssertTrue( CGSizeEqualToSize(CGSizeMake(20, 40), [obj getIvarCGSize:@"_privateSize"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateRect" withCGRect:CGRectMake(10, 10, 20, 20)];
    FWAssertTrue( CGRectEqualToRect(CGRectMake(10, 10, 20, 20),  [obj getIvarCGRect:@"_privateRect"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
}


#pragma mark - Return Original Value
- (id    )FWStubObject_getOrigObject{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}


- (id    )FWStubObject_getOrigInt{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}
- (id   )FWStubObject_getOrigLong{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}
- (id  )FWStubObject_getOrigFloat{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getOrigDouble{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id)FWStubObject_getOrigPoint{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getOrigSize{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getOrigRect{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getClassOrigObject{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getClassOrigFloat{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

- (id )FWStubObject_getClassOrigSize{
    if (self.callBack) {
        id result = self.callBack(YES);
        NSLog(@">>>%@ %@ %@",NSStringFromSelector(_cmd),NSStringFromClass([result class]), result);
        return result;
    }
    return nil;
}

@end
