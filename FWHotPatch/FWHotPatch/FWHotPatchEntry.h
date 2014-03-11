//
//  FWHotPatchEntry.h
//  FWHotPatch
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^FWCallBackBlock)(BOOL callOriginal);
@protocol FWHotPatchEntryProtocol <NSObject>
- (id)runMethod:(NSString*)methodKey withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack;
@end

@interface FWHotPatchEntry : NSObject<FWHotPatchEntryProtocol>
- (id)runMethod:(NSString*)methodKey withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack;
@end
