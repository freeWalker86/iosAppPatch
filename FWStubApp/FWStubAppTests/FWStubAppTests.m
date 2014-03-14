//
//  FWStubAppTests.m
//  FWStubAppTests
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FWStubObject.h"
#import "FWHookStub.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "FWHookHelper.h"

@interface FWStubAppTests : XCTestCase
{
    FWHookStub   *_hookStub;
}
@end

@implementation FWStubAppTests

- (void)setUp
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hookStub = [[FWHookStub alloc] init];
        [_hookStub installHookStub];
    });
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCommon
{
    FWStubObject *stubObj  = [[FWStubObject alloc] init];

    [stubObj sayHello];
    XCTAssertTrue([[stubObj getPrivateName] isEqualToString:@"FWStubObject_sayHello"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);

    [stubObj ivarAccess];
    //Bundle IvarAccess set every private intance,You cand assert many more things.
    XCTAssertTrue(CGSizeEqualToSize([stubObj getPrivateSize], CGSizeMake(20, 40)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
}

- (void)testVariableArgs{
    FWStubObject *stubObj  = [[FWStubObject alloc] init];
    
    NSDictionary *rtDic = nil;
    NSArray      *rtArr = nil;
    rtDic = [stubObj testStr:@"string" array:@[@"one",@"two"] dict:@{@"key": @"value"}];
    XCTAssertTrue([[rtDic objectForKey:@"method"] isEqualToString:@"FWStubObject_testStr_array_dict_"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtDic objectForKey:@"originalArgs"] objectAtIndex:0] == stubObj , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtDic objectForKey:@"originalArgs"] objectAtIndex:1] isEqualToString:@"string"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[[rtDic objectForKey:@"originalArgs"] objectAtIndex:2] objectAtIndex:0] isEqualToString:@"one"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[[rtDic objectForKey:@"originalArgs"] objectAtIndex:2] objectAtIndex:1] isEqualToString:@"two"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[[rtDic objectForKey:@"originalArgs"] objectAtIndex:3] objectForKey:@"key"] isEqualToString:@"value"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);


    rtArr = [stubObj testBool:YES intV:2343 longV:8888 floatV:999.11 doubleV:2343.23434];
    XCTAssertTrue([[rtArr objectAtIndex:0] isEqualToString:@"FWStubObject_testBool_intV_longV_floatV_doubleV_"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([rtArr objectAtIndex:1] == stubObj , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:2] boolValue] == YES , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:3] intValue] == 2343 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:4] longValue] == 8888 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([[rtArr objectAtIndex:5] floatValue] - 999.11f)<0.000001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabs([[rtArr objectAtIndex:6] doubleValue] - 2343.23434)<0.000001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    rtArr = [stubObj testPoint:CGPointMake(11.44, 233) size:CGSizeMake(90.08, 202.89) rect:CGRectMake(22, 80, 245, 190)];
    XCTAssertTrue([[rtArr objectAtIndex:0] isEqualToString:@"FWStubObject_testPoint_size_rect_"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([rtArr objectAtIndex:1] == stubObj , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGPointEqualToPoint([[rtArr objectAtIndex:2] CGPointValue] , CGPointMake(11.44, 233)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([[rtArr objectAtIndex:3] CGSizeValue] , CGSizeMake(90.08, 202.89)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGRectEqualToRect([[rtArr objectAtIndex:4] CGRectValue] , CGRectMake(22, 80, 245, 190)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);

    rtArr = [FWStubObject testClassMethod:3434.222 arg2:@"arg222" arg3:@[@"one",@"two"]];
    XCTAssertTrue([[rtArr objectAtIndex:0] isEqualToString:@"FWStubObject_testClassMethod_arg2_arg3_"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([rtArr objectAtIndex:1] == [stubObj class] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([[rtArr objectAtIndex:2] floatValue] - 3434.222f)<0.00001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:3] isEqualToString:@"arg222"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtArr objectAtIndex:4] objectAtIndex:0] isEqualToString:@"one"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtArr objectAtIndex:4] objectAtIndex:1] isEqualToString:@"two"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);

}


- (void)testGetReturnValue{
    FWStubObject *stubObj  = [[FWStubObject alloc] init];
    
    XCTAssertTrue([[stubObj getObject] isEqualToString:@"FWStubObject_getObject"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[stubObj getStr] isEqualToString:@"FWStubObject_getStr"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([stubObj getInt]==11 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([stubObj getLong]==1111 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([stubObj getFloat]-11.223f)<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabs([stubObj getDouble]-11.34434f)<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGPointEqualToPoint([stubObj getPoint], CGPointMake(23.9, 343.09)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([stubObj getSize], CGSizeMake(90.08, 202.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGRectEqualToRect([stubObj getRect], CGRectMake(22, 80, 245, 190)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    XCTAssertTrue([[FWStubObject getClassObject] isEqualToString:@"FWStubObject_getClassObject"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([FWStubObject getClassFloat]-(11.223))<0.00001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([FWStubObject getClassSize], CGSizeMake(90.08, 202.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);

    
}

- (void)testGetOriginalReturnValue{
    FWStubObject *stubObj  = [[FWStubObject alloc] init];

    XCTAssertTrue([[stubObj getOrigObject] isEqualToString:@"1212"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([stubObj getOrigInt]==32767 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([stubObj getOrigLong]==2147483647 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([stubObj getOrigFloat]-(-20))<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabs([stubObj getOrigDouble]-(-200))<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGPointEqualToPoint([stubObj getOrigPoint], CGPointMake(10, 20)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([stubObj getOrigSize], CGSizeMake(100.08, 22.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGRectEqualToRect([stubObj getOrigRect], CGRectMake(0.22, 43.7, 55.89, 90)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    XCTAssertTrue([[FWStubObject getClassOrigObject] isEqualToString:@"globalName xxx"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf([FWStubObject getClassOrigFloat]-(234.124))<0.00001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([FWStubObject getClassOrigSize], CGSizeMake(100.08, 22.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
}


-(void)testCallSuperMethod{
    FWStubObject *stubObj  = [[FWStubObject alloc] init];
    
    //四种方法（都有瑕疵，混合着用吧）
    //1.objc_msgSendSuper
    //2.objc_msgSend + NSClassFromString(@"FWStubBase")
    //3.class_getMethodImplementation( class_getSuperclass(object_getClass(rcv)), sel) +IMP调用
    //4.NSInvocation 封装调用
    struct objc_super super1;
    super1.receiver = stubObj;
    super1.super_class = class_getSuperclass([stubObj class]);
    
    //
    NSDictionary *rtDic = nil;
    NSArray      *rtArr = nil;
    rtDic = objc_msgSendSuper(&super1, @selector(testStr:array:dict:),@"string",@[@"one",@"two"],@{@"key": @"value"});
    XCTAssertTrue([[rtDic objectForKey:@"arg0"] isEqualToString:@"string"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtDic objectForKey:@"arg1"] objectAtIndex:0] isEqualToString:@"one"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtDic objectForKey:@"arg1"] objectAtIndex:1] isEqualToString:@"two"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtDic objectForKey:@"arg2"] objectForKey:@"key"] isEqualToString:@"value"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    
    rtArr = objc_msgSendSuper(&super1, @selector(testBool:intV:longV:floatV:doubleV:),YES,2343,8888,999.11l,2343.23434);
    
    XCTAssertTrue([[rtArr objectAtIndex:0] boolValue] == YES , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:1] intValue] == 2343 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:2] longValue] == 8888 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    //XCTAssertTrue(fabsf([[rtArr objectAtIndex:3] floatValue] - 999.11f)<0.000001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    //XCTAssertTrue(fabs([[rtArr objectAtIndex:4] doubleValue] - 2343.23434)<0.000001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    rtArr = objc_msgSendSuper(&super1, @selector(testPoint:size:rect:),CGPointMake(11.44, 233),CGSizeMake(90.08, 202.89),CGRectMake(22, 80, 245, 190));
    XCTAssertTrue(CGPointEqualToPoint([[rtArr objectAtIndex:0] CGPointValue] , CGPointMake(11.44, 233)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize([[rtArr objectAtIndex:1] CGSizeValue] , CGSizeMake(90.08, 202.89)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGRectEqualToRect([[rtArr objectAtIndex:2] CGRectValue] , CGRectMake(22, 80, 245, 190)), @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    
    
    //========================================================================================================
    XCTAssertTrue([objc_msgSendSuper(&super1, @selector(getObject)) isEqualToString:@"_privateObj"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([objc_msgSendSuper(&super1, @selector(getStr)) isEqualToString:@"string"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue((int)objc_msgSendSuper(&super1, @selector(getInt)) ==32765 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue((long)objc_msgSendSuper(&super1, @selector(getLong))==2147483646 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    XCTAssertTrue(fabsf(((float(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getFloat))-(-2000))<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabs(((double(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getDouble))-(-2001))<0.000001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    //这里返回CGPoint 没有使用objc_msgSendSuper_stret 是因为CGPoint,CGSize 虽然为结构体，但其返回值是放在register，而不是memory,所以可以直接使用objc_msgSendSuper 强转。
    //CGRect
    //https://code.google.com/p/rococoa/wiki/ObjcMsgSend
    /* Struct-returning Messaging Primitives
     *
     * Use these functions to call methods that return structs on the stack.
     ************************************************************************
     *On some architectures, some structures are returned in registers.
     ************************************************************************
     * Consult your local function call ABI documentation for details.
     *
     * These functions must be cast to an appropriate function pointer type
     * before being called.
     */
    
    //#if !OBJC_OLD_DISPATCH_PROTOTYPES
    //    OBJC_EXPORT void objc_msgSend_stret(void /* id self, SEL op, ... */ )
    //    __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0)
    //    OBJC_ARM64_UNAVAILABLE;
    //    OBJC_EXPORT void objc_msgSendSuper_stret(void /* struct objc_super *super, SEL op, ... */ )
    //    __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0)
    //    OBJC_ARM64_UNAVAILABLE;
    //#else
    XCTAssertTrue(CGPointEqualToPoint(((CGPoint(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getPoint)), CGPointMake(10, 20)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize(((CGSize(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getSize)), CGSizeMake(100.08, 22.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    
    XCTAssertTrue(CGRectEqualToRect(((CGRect(*)(id, SEL))objc_msgSendSuper_stret)((__bridge id)(&super1), @selector(getRect)), CGRectMake(0.22, 43.7, 55.89, 90)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    //========================================================================================================
#warning Update objc_super struct super_class before Do class method test
    super1.super_class =  object_getClass(class_getSuperclass([stubObj class]));
    //========================================================================================================
    
    XCTAssertTrue([objc_msgSendSuper(&super1, @selector(getClassObject)) isEqualToString:@"globalName xxx"], @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(fabsf(((float(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getClassFloat)) -(234.124))<0.00001, @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue(CGSizeEqualToSize(((CGSize(*)(id, SEL))objc_msgSendSuper)((__bridge id)(&super1), @selector(getClassSize)) ,CGSizeMake(100.08, 22.89)),@"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    
    
#warning 奇怪了，调用单个参数的类方法ok， 调用多个参数的类方法就有问题，例如testClassMethod:arg2:arg3: 有问题。
#warning 若多个参数为基本类型也没关系，但若为NSObject 类型， 则有问题。似乎是ARC问题，但不用ARC还是有问题。nnd
    /*
     //rtArr = objc_msgSend(NSClassFromString(@"FWStubBase"),  @selector(testClassMethod:arg2:arg3:),3434.222f,@"arg222",@[@"one",@"two"]);
     //rtArr = objc_msgSendSuper(&super1, @selector(testClassMethod:arg2:arg3:),3434.222,@"arg222",@[@"one",@"two"]);
     
     */
    
    NSMethodSignature *signature = [[stubObj class] methodSignatureForSelector:@selector(testClassMethod:arg2:arg3:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget: (class_getSuperclass(object_getClass(stubObj)))];
    [invocation setSelector:@selector(testClassMethod:arg2:arg3:)];
    
    float arg1 = 3434.222;
    NSString* arg2 = @"arg222";
    NSArray * arg3 = @[@"one",@"two"];
    [invocation setArgument:&arg1 atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    [invocation setArgument:&arg3 atIndex:4];
    [invocation invoke];
    const char *returnType = [signature methodReturnType];
    NSInteger returnLength = [signature methodReturnLength];
    
    
    CFTypeRef result = NULL;
    [invocation getReturnValue:&result];
    rtArr = (__bridge NSArray *)result;
    
    //[invocation getReturnValue:&rtArr];
    
    XCTAssertTrue(fabsf([[rtArr objectAtIndex:0] floatValue] - 3434.222f)<0.00001 , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[rtArr objectAtIndex:1] isEqualToString:@"arg222"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtArr objectAtIndex:2] objectAtIndex:0] isEqualToString:@"one"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    XCTAssertTrue([[[rtArr objectAtIndex:2] objectAtIndex:1] isEqualToString:@"two"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
    rtArr = nil;
    
}

- (void)testTriggerHotPatch{
    //Test call original method , super method in FWHotPatch
    FWStubObject *stubObj  = [[FWStubObject alloc] init];
    [stubObj getObject];
    [stubObj getStr];
    [stubObj getInt];
    [stubObj getSize];
    [stubObj getRect];
}


@end
