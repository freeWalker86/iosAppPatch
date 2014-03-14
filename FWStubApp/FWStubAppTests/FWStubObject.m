//
//  FWStubObject.m
//  FWStubApp
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWStubObject.h"


@implementation FWStubBase
- (id)init
{
    self = [super init];
    if (self) {
        _privateObj = @"_privateObj";
    }
    return self;
}
- (NSDictionary*)testStr:(NSString*)name array:(NSArray*)array dict:(NSDictionary*)dict{
    NSLog(@">>>[FWStubBase] testStr name=[%@] array=[%@] dict=[%@]",name, array, dict);
    return @{@"arg0": name,@"arg1":array,@"arg2":dict};
}

- (NSArray*)testBool:(BOOL)b intV:(int)i longV:(long)l floatV:(float)f doubleV:(double)d{
    NSLog(@">>>[FWStubBase] testBool bool=[%d] int=[%d] long=[%ld] float=[%f] double=[%lf]",b,i,l,f,d);
    return @[[NSNumber numberWithBool:b],[NSNumber numberWithInt:i],[NSNumber numberWithLong:l],[NSNumber numberWithFloat:f],[NSNumber numberWithDouble:d]];
}

- (NSArray*)testPoint:(CGPoint)point size:(CGSize)size rect:(CGRect)rect{
    NSLog(@">>>[FWStubBase] testPoint point=[%@] size=[%@] rect=[%@]",NSStringFromCGPoint(point),NSStringFromCGSize(size),NSStringFromCGRect(rect));
    return @[[NSValue valueWithCGPoint:point],[NSValue valueWithCGSize:size],[NSValue valueWithCGRect:rect]];
}

+ (NSArray*)testClassMethod:(CGFloat)arg1 arg2:(NSString*)arg2 arg3:(NSArray*)arg3{
    NSLog(@">>>[FWStubBase] testClassMethod arg1=[%f] arg2=[%@] arg3=[%@]",arg1, arg2, arg3);
    return @[[NSNumber numberWithFloat:arg1],arg2,arg3];
}

+ (NSArray*)testClassMethod11:(float)arg1{
    return [NSArray arrayWithObjects:@"xxx", nil];
}

+ (NSArray*)testClassMethod11:(float)arg1 arg2:(long)ar2{
    NSLog(@">>>testClassMethod11");
    return @[[NSNumber numberWithFloat:arg1], [NSNumber numberWithLong:ar2]];
}

+ (NSArray*)testClassMethod11:(float)arg1 argTwo:(NSArray*)arg2{
    return [NSArray arrayWithObjects:@"xxx", nil];
}


- (id     )getObject{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return _privateObj;
}

- (NSString*)getStr{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return @"string";
}
- (int    )getInt{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return 32765;
}
- (long   )getLong{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return 2147483646;
}
- (float  )getFloat{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return -2000;
}
- (double )getDouble{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return -2001;
}
- (CGPoint)getPoint{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return CGPointMake(10, 20);
}
- (CGSize )getSize{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return CGSizeMake(100.08, 22.89);
}
- (CGRect )getRect{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return CGRectMake(0.22, 43.7, 55.89, 90);
}

+ (id     )getClassObject{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return globalName;
}

+ (float  )getClassFloat{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return 234.124;
}

+ (CGSize )getClassSize{
    NSLog(@">>>[FWStubBase] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    return CGSizeMake(100.08, 22.89);
}

@end


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

- (NSArray*)testBool:(BOOL)b intV:(int)i longV:(long)l floatV:(float)f doubleV:(double)d{
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


