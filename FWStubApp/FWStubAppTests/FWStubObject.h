//
//  FWStubObject.h
//  FWStubApp
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    kEnum1 = 10,
    kEnum2,
    kEnum3,
    kEnum4,
} TestEnum;

NSInteger enumVar;
static NSString *globalName = nil;

@interface FWStubBase : NSObject{
    NSString *_privateObj;
}

- (NSDictionary*)testStr:(NSString*)name array:(NSArray*)array dict:(NSDictionary*)dict;
- (NSArray*)testBool:(BOOL)b intV:(int)i longV:(long)l floatV:(float)f doubleV:(double)d;
- (NSArray*)testPoint:(CGPoint)point size:(CGSize)size rect:(CGRect)rect;
+ (NSArray*)testClassMethod:(CGFloat)arg1 arg2:(NSString*)arg2 arg3:(NSArray*)arg3;
+ (NSArray*)testClassMethod11:(float)arg1 arg2:(long)ar2;
+ (NSArray*)testClassMethod11:(float)arg1 argTwo:(NSArray*)arg2;
- (id     )getObject;
- (NSString*)getStr;
- (int    )getInt;
- (long   )getLong;
- (float  )getFloat;
- (double )getDouble;
- (CGPoint)getPoint;
- (CGSize )getSize;
- (CGRect )getRect;
+ (id     )getClassObject;
+ (float  )getClassFloat;
+ (CGSize )getClassSize;

@end

@interface FWStubObject : FWStubBase{
    @private
    
    char        _privateChar;
    short       _privateShort;
    int         _privateInt;
    long        _privateLong;
    long long   _privateLongLong;
    float       _privateFloat;
    double      _privateDouble;
    
    unsigned char   _privateUnsignedChar;
    unsigned short  _privateUnsignedShort;
    unsigned int    _privateUnsignedInt;
    unsigned long   _privateUnsignedLong;
    unsigned long long _privateUnsignedLongLong;
    
    BOOL            _privateBool;
    void            *_privatePointer;
    id              _privateObject;
    
    CGFloat         _privateCGFloat;
    
    CGPoint     _privatePoint;
    CGSize      _privateSize;
    CGRect      _privateRect;
    
    //others
    NSString    *_privateName;
    NSString    *_privateAge;
    
}
@property(nonatomic, strong)NSString* name;
@property(nonatomic, assign)CGFloat   age;
@property(nonatomic, assign)CGPoint  point;
@property(nonatomic, assign)CGSize   size;
@property(nonatomic, assign)CGRect   rect;

- (NSString*)getPrivateName;
- (CGSize)getPrivateSize;

- (void)sayHello;
- (void)ivarAccess;

#pragma mark - variable args
- (NSDictionary*)testStr:(NSString*)name array:(NSArray*)array dict:(NSDictionary*)dict;
- (NSArray*)testBool:(BOOL)b intV:(int)i longV:(long)l floatV:(float)f doubleV:(double)d;
- (NSArray*)testPoint:(CGPoint)point size:(CGSize)size rect:(CGRect)rect;
+ (NSArray*)testClassMethod:(CGFloat)arg1 arg2:(NSString*)arg2 arg3:(NSArray*)arg3;

#pragma mark - Return Value
- (id     )getObject;
- (NSString*)getStr;
- (int    )getInt;
- (long   )getLong;
- (float  )getFloat;
- (double )getDouble;
- (CGPoint)getPoint;
- (CGSize )getSize;
- (CGRect )getRect;
+ (id     )getClassObject;
+ (float  )getClassFloat;
+ (CGSize )getClassSize;

#pragma mark - For Test Return Original Value
- (id     )getOrigObject;
- (int    )getOrigInt;
- (long   )getOrigLong;
- (float  )getOrigFloat;
- (double )getOrigDouble;
- (CGPoint)getOrigPoint;
- (CGSize )getOrigSize;
- (CGRect )getOrigRect;

+ (id     )getClassOrigObject;
+ (float  )getClassOrigFloat;
+ (CGSize )getClassOrigSize;

@end
