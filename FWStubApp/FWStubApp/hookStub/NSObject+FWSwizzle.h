//
//  NSObject+FWSwizzle.h
//  FWStubApp
//
//  Created by lv on 14-3-7.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FWSwizzle)
/**
 *  1.Add a new selector with name(kFWSwizzlePrefix+origSel) and use newImp as its implement.
 *  2.Exchange origSel with new selector.
 *
 *  @param isClass origSel is a class method flag
 *  @param origSel the selector will be to swizzle
 *  @param newImp  the new implement to swizzle
 */
+ (void)swizzleClassMethod:(BOOL)isClass origSel:(SEL)origSel newImp:(IMP)newImp;

/**
 *  1.Add a new selector with name(kFWSwizzlePrefix+origSel) and use newImp as its implement.
 *  2.Exchange origSel with new selector.
 *  3.Store the origSel implement at origImp.
 *
 *  @param isClass origSel is a class method flag
 *  @param origSel the selector will be to swizzle
 *  @param newImp  the new implement to swizzle
 *  @param origImp store the origSel implement
 */
+ (void)swizzleClassMethod:(BOOL)isClass origSel:(SEL)origSel newImp:(IMP)newImp origImp:(IMP*)origImp;

/**
 *  Get the method sel return type.
 *
 *  @param sel     selector
 *  @param isClass sel is a class method flag
 *
 *  @return the method return type.
 */
+ (char*)returnTypeWithSelector:(SEL)sel  isClassMethod:(BOOL)isClass;
@end
