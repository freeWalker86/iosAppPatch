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


#define LVAssertTrue(expression, format...)   FWAssertTrue(expression, ## format)

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
- (id)runMethod:(NSString*)methodKey withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack{
    
    if (methodKey) {
        NSLog(@">>>FWHotPatchEntry  args=%@",args);
        NSLog(@">>>FWHotPatchEntry  callBack= %@",callBack);
        NSLog(@">>>FWHotPatchEntry  methodKey=%@",methodKey);
        methodKey = [methodKey stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        self.args     = args;
        self.callBack = callBack;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:methodKey message:@"Display this message in bundle patch" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        if ([self respondsToSelector:NSSelectorFromString(methodKey)]) {
           return [self performSelector:NSSelectorFromString(methodKey) withObject:nil];
        }else{
            NSLog(@">>>unrecognized selector %@",methodKey);
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

- (NSArray*)FWStubObject_testBool_int_long_float_double_{
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

#pragma mark - FWStubObject Getter
- (id    )FWStubObject_getObject{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return NSStringFromSelector(_cmd);
}
- (NSString*)FWStubObject_getStr{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
    return  NSStringFromSelector(_cmd);
}
- (id    )FWStubObject_getInt{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
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
    return [NSValue valueWithCGSize: CGSizeMake(90.08, 202.89)];
}
- (id )FWStubObject_getRect{
    NSLog(@">>>%@",NSStringFromSelector(_cmd));
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
    
    LVAssertTrue([obj getIvarChar:@"_privateChar"]=='d',[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateShort" withShort:32767];
    LVAssertTrue([obj getIvarShort:@"_privateShort"]==32767,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateInt" withInt:32767];
    LVAssertTrue([obj getIvarInt:@"_privateInt"]==32767,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateLong" withLong:2147483647];
    LVAssertTrue([obj getIvarLong:@"_privateLong"]==2147483647,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateLongLong" withLongLong:9223372036854775807];
    LVAssertTrue([obj getIvarLongLong:@"_privateLongLong"]==9223372036854775807,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateFloat" withFloat:-20];
    LVAssertTrue([obj getIvarFloat:@"_privateFloat"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateDouble" withDouble:-20];
    LVAssertTrue([obj getIvarDouble:@"_privateDouble"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedChar" withUnsignedChar:'d'];
    LVAssertTrue([obj getIvarUnsignedChar:@"_privateUnsignedChar"]=='d',[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedShort" withUnsignedShort:65535];
    LVAssertTrue([obj getIvarUnsignedShort:@"_privateUnsignedShort"]==65535,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedInt" withUnsignedInt:65535];
    LVAssertTrue([obj getIvarUnsignedInt:@"_privateUnsignedInt"]==65535,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateUnsignedLong" withUnsignedLong:4294967295];
    LVAssertTrue([obj getIvarUnsignedLong:@"_privateUnsignedLong"]==4294967295,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    
    unsigned long long value = 1844674407370955161;//18446744073709551615
    [obj setIvar:@"_privateLongLong" withUnsignedLongLong:value];
    LVAssertTrue([obj getIvarUnsignedLongLong:@"_privateLongLong"]==value,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateBool" withBool:YES];
    LVAssertTrue([obj getIvarBool:@"_privateBool"]==YES,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    void *pt = (__bridge void*)self;
    [obj setIvar:@"_privatePointer" withPointer:(void*)self];
    LVAssertTrue([obj getIvarPointer:@"_privatePointer"]==pt,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    NSString *name = @"name";
    [obj setIvar:@"_privateObject" withObject:name];
    LVAssertTrue([obj getIvarObject:@"_privateObject"]==name,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateCGFloat" withFloat:-20];
    LVAssertTrue([obj getIvarFloat:@"_privateCGFloat"]==-20,[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    
    
    [obj setIvar:@"_privatePoint" withCGPoint:CGPointMake(10, 10)];
    LVAssertTrue( CGPointEqualToPoint(CGPointMake(10, 10), [obj getIvarCGPoint:@"_privatePoint"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateSize" withCGSize:CGSizeMake(20, 40)];
    LVAssertTrue( CGSizeEqualToSize(CGSizeMake(20, 40), [obj getIvarCGSize:@"_privateSize"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
    [obj setIvar:@"_privateRect" withCGRect:CGRectMake(10, 10, 20, 20)];
    LVAssertTrue( CGRectEqualToRect(CGRectMake(10, 10, 20, 20),  [obj getIvarCGRect:@"_privateRect"]),[NSString stringWithFormat:@"Assert Failed At Line: %d",__LINE__]);
    
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
