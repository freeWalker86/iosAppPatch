//
//  FWConst.h
//  FWStubApp
//
//  Created by lv on 14-3-14.
//  Copyright (c) 2014年 FW. All rights reserved.
//

/**
 *  declare var used in FWStubApp and FWHotPatch
 */

#define  kFWSwizzlePrefix                   @"FWHook"


#define kHookArray                          @"hookArray"
#define kHookClassName                      @"hookClassName"
#define kHookClassMethodName                @"hookClassMethodName"
#define kHookClassMethod                    @"hookClassMethod"

typedef id (^FWCallBackBlock)(BOOL callOriginal);
@protocol FWHotPatchEntryProtocol <NSObject>
- (id)runMethod:(NSString*)method withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack;
@end