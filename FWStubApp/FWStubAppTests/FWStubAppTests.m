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


    rtArr = [stubObj testBool:YES int:2343 long:8888 float:999.11 double:2343.23434];
    XCTAssertTrue([[rtArr objectAtIndex:0] isEqualToString:@"FWStubObject_testBool_int_long_float_double_"] , @"Assert Failed At Function:%s Line: %d",__func__, __LINE__);
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

@end
