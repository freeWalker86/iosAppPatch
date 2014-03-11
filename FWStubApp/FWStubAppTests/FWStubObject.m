//
//  FWStubObject.m
//  FWStubApp
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWStubObject.h"

@implementation FWStubObject

#pragma mark - Life Circle

- (id)init
{
    self = [super init];
    if (self) {
        globalName = @"globalName xxx";
        enumVar = kEnum1;
        _privateAge = @"1212";
    }
    return self;
}
-(NSString *)description{
    NSMutableString *mutDes = [NSMutableString stringWithCapacity:100];

    return mutDes;
}

#pragma mark - Public  Method


- (void)sayHelloWithOneArg:(NSDictionary*)arg1{
    NSLog(@">>>sayHelloWithOneArg %@",arg1);
}

- (void)sayHelloWithArg1:(NSDictionary*)arg1 arg2:(NSString*)arg2 arg3:(NSString*)arg3{
    NSLog(@">>>sayHelloWithArg1 %@ %@ %@ ",arg1, arg2, arg3);
}

- (void)test:(CGFloat)aFloat doubleValue:(double)aDouble string:(NSString*)str{
    NSLog(@">>>test %f %lf %@ ",aFloat, aDouble, str);
}


- (NSString*)getPrivateName{
    return _privateName;
}

- (CGSize)getPrivateSize{
    return _privateSize;
}


- (void)sayHello{
    //NSLog(@">>>sayHello xxxx globalName=[%@] ,enumVar=[%d]",globalName,enumVar);
    NSLog(@">>>sayHello _privateName=[%@]",_privateName);
}

- (void)ivarAccess{
    NSLog(@">>>ivarAccess");
}

#pragma mark - variable args
- (NSDictionary*)testStr:(NSString*)name array:(NSArray*)array dict:(NSDictionary*)dict{
    NSLog(@">>>testStr name=[%@] array=[%@] dict=[%@]",name, array, dict);
    return nil;
}

- (NSArray*)testBool:(BOOL)b int:(int)i long:(long)l float:(float)f double:(double)d{
    NSLog(@">>>testBool bool=[%d] int=[%d] long=[%ld] float=[%f] double=[%lf]",b,i,l,f,d);
    return nil;
}
- (NSArray*)testPoint:(CGPoint)point size:(CGSize)size rect:(CGRect)rect{
    NSLog(@">>>testPoint point=[%@] size=[%@] rect=[%@]",NSStringFromCGPoint(point),NSStringFromCGSize(size),NSStringFromCGRect(rect));
    return nil;
}

+ (NSArray*)testClassMethod:(CGFloat)arg1 arg2:(NSString*)arg2 arg3:(NSArray*)arg3{
    NSLog(@">>>testClassMethod arg1=[%f] arg2=[%@] arg3=[%@]",arg1, arg2, arg3);
    return nil;
}


#pragma mark - Return Value
- (id     )getObject{
    return _privateAge;
}

- (NSString*)getStr{
    return @"string";
}
- (int    )getInt{
    return 32767;
}
- (long   )getLong{
    return 2147483647;
}
- (float  )getFloat{
    return -20;
}
- (double )getDouble{
    return -200;
}
- (CGPoint)getPoint{
    return CGPointMake(10, 20);
}
- (CGSize )getSize{
    return CGSizeMake(100.08, 22.89);
}
- (CGRect )getRect{
    return CGRectMake(0.22, 43.7, 55.89, 90);
}

+ (id     )getClassObject{
    return globalName;
}

+ (float  )getClassFloat{
    return 234.124;
}

+ (CGSize )getClassSize{
    return CGSizeMake(100.08, 22.89);
}
#pragma mark - For Test Return Original Value

- (id     )getOrigObject{
    return _privateAge;
}

- (int    )getOrigInt{
    return 32767;
}

- (long   )getOrigLong{
    return 2147483647;
}

- (float  )getOrigFloat{
    return -20;
}

- (double )getOrigDouble{
    return -200;
}

- (CGPoint)getOrigPoint{
    return CGPointMake(10, 20);
}

- (CGSize )getOrigSize{
    return CGSizeMake(100.08, 22.89);
}

- (CGRect )getOrigRect{
    return CGRectMake(0.22, 43.7, 55.89, 90);
}

+ (id     )getClassOrigObject{
    return globalName;
}

+ (float  )getClassOrigFloat{
    return 234.124;
}

+ (CGSize )getClassOrigSize{
    return CGSizeMake(100.08, 22.89);
}
@end


