//
//  FWHotPatchEntry.h
//  FWHotPatch
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWConst.h"

@interface FWHotPatchEntry : NSObject<FWHotPatchEntryProtocol>
- (id)runMethod:(NSString*)method withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack;
@end
