//
//  FWFixedStubObject.h
//  FWHotPatch
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWHotPatchEntry.h"

@interface FWFixedStubObject : NSObject
@property(nonatomic, copy)FWCallBackBlock callBack;
@property(nonatomic, strong)NSArray *args;
@end
