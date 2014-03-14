//
//  FWHookStub.m
//  FWStubApp
//
//  Created by lv on 14-3-10.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWHookStub.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+FWSwizzle.h"
#import "FWHookHelper.h"
#import "FWZip.h"
#import "FWConst.h"


static FWHookStub *shareIntance = nil;

@interface FWHookStub()
{
    NSBundle                    *_bundle;
    id<FWHotPatchEntryProtocol> _patchObj;
}
- (id)runMethod:(NSString*)method withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack;
@end


FW_HOOKMETHOD(id);
FW_HOOKMETHOD(int);
FW_HOOKMETHOD(long);
FW_HOOKMETHOD(BOOL);
FW_HOOKMETHOD_EX(float);
FW_HOOKMETHOD_EX(double);
FW_HOOKMETHOD_EX(CGPoint);
FW_HOOKMETHOD_EX(CGSize);
FW_HOOKMETHOD_EX(CGRect);


IMP getHookMethodWithSelReturnType(const char* type){
    IMP imp = NULL;
    if (type!=NULL) {
        switch (type[0]) {
            case _C_VOID:
            case _C_ID:
                imp = (IMP)FW_HOOKMETHOD_NAME(id);
                break;
        
            case _C_CHR:
            case _C_INT:
            case _C_SHT:
            case _C_UCHR:
            case _C_UINT:
            case _C_USHT:
                imp = (IMP)FW_HOOKMETHOD_NAME(int);
                break;
                
            case _C_LNG:
            case _C_LNG_LNG:
            case _C_ULNG:
            case _C_ULNG_LNG:
                imp = (IMP)FW_HOOKMETHOD_NAME(long);
                break;
                
            case _C_FLT:
                imp = (IMP)FW_HOOKMETHOD_NAME(float);
                break;
            case _C_DBL:
                imp = (IMP)FW_HOOKMETHOD_NAME(double);
                break;
            case _C_BOOL:
                imp = (IMP)FW_HOOKMETHOD_NAME(BOOL);
                break;
                
            case _C_STRUCT_B: //struct
                if (strcmp(@encode(CGPoint), type)==0) {
                    imp = (IMP)FW_HOOKMETHOD_NAME(CGPoint);
                }else if (strcmp(@encode(CGSize), type)==0){
                    imp = (IMP)FW_HOOKMETHOD_NAME(CGSize);
                }else if (strcmp(@encode(CGRect), type)==0){
                    imp = (IMP)FW_HOOKMETHOD_NAME(CGRect);
                }
                break;
                
            default:
                NSLog(@">>>Can't override method with return type %s", type);
                return NO;
                break;
        }
    }
    return imp;
}


@implementation FWHookStub

- (id)init
{
    self = [super init];
    if (self) {
        shareIntance = self;
    }
    return self;
}

-(void)dealloc{
    shareIntance = nil;
}

#pragma mark - Public  Method
- (void)installHookStub{
    [self downloadBundle];
    [self registerBundleHook];
}

#pragma mark - Logic
- (void)downloadBundle{
    NSString *bundlePath = nil;
#if TARGET_IPHONE_SIMULATOR
    bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FWHotPatch.bundle"];
#else
    
    bundlePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"FWHotPatch-device.bundle"];
    //remove everything
    [[NSFileManager defaultManager] removeItemAtPath:bundlePath  error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://10.68.191.179/FWHotPatch-device.bundle.zip"]];
        if ([data length] >0) {
            NSString *zipPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"FWHotPatch-device.bundle.zip"];
            [data writeToFile:zipPath atomically:YES];
            [FWHookStub unzipFilePath:zipPath toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
        }else{//If can not download from server , then use local bundle
            bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FWHotPatch.bundle"];
        }
    }
#endif
    _bundle = [NSBundle bundleWithPath:bundlePath];
}

- (void)registerBundleHook{
    NSDictionary *infoDict = [_bundle infoDictionary];
    NSArray  *hookArray = [infoDict objectForKey:kHookArray];
    for (NSDictionary *dict in hookArray) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSString *className = [dict objectForKey:kHookClassName];
            NSString *methodName= [dict objectForKey:kHookClassMethodName];
            BOOL isClassMethod  = [[dict objectForKey:kHookClassMethod] boolValue];
            if (className && methodName) {
                Class cls = NSClassFromString(className);
                SEL   sel = NSSelectorFromString(methodName);
                
                char* type = [cls returnTypeWithSelector:sel isClassMethod:isClassMethod];
                IMP stubIMP = getHookMethodWithSelReturnType(type);
            
                if (stubIMP) {
                    [cls swizzleClassMethod:isClassMethod origSel:sel newImp:stubIMP];
                }
            }

        }
    }
}

- (id)runMethod:(NSString*)method withArgs:(NSArray*)args callBack:(FWCallBackBlock)callBack{
    
    if (_patchObj == nil) {
        Class cls = [_bundle classNamed:@"FWHotPatchEntry"];
        if (cls == nil) {
            cls = [_bundle principalClass];
        }
        if (cls && [cls conformsToProtocol:@protocol(FWHotPatchEntryProtocol)]) {
            _patchObj = [[cls alloc] init];
        }
    }

    id result = [_patchObj runMethod:method withArgs:args callBack:callBack];
    return result;
}


#pragma mark - Util
/**
 *  解压zip文件到指定目录
 *
 *  @param zipFilePath zip压缩文件所在路径
 *  @param path        解压后文件位置
 *
 *  @return 是否成功
 */
+ (BOOL)unzipFilePath:(NSString *)zipFilePath toPath:(NSString *)path{
    if (zipFilePath==nil || path ==nil){
		return NO;
	}
	
	BI_UnzFile unzSkinFile = BIUnzOpen((const char*)[zipFilePath UTF8String]);
	if(!unzSkinFile){
        return NO;
	}
    
	int ret = BIUnzGoToFirstFile(unzSkinFile);
	if(kUnzOK != ret){
        return NO;
	}
    
    unsigned char  buffer[kBufferSize] = {0};
    NSFileManager* defautFileManager   = [NSFileManager   defaultManager];
	do {
        ret = BIUnzOpenCurrentFile(unzSkinFile);
		if(kUnzOK != ret){
			break;
		}
        
		BI_UnzFileInfo fileInfo = {0};
		ret = BIUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if(kUnzOK != ret){
			BIUnzCloseCurrentFile(unzSkinFile);
			break;
		}
        
		char* filename = (char*)malloc(fileInfo.size_filename +1);
		BIUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
        NSString* filePath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
        if(NSNotFound != [filePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\\"]].location){
			filePath = [filePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
        
        BOOL isDirectory = [[filePath substringFromIndex:filePath.length - 1] isEqualToString:@"/"];
        filePath = [path stringByAppendingPathComponent:filePath];
        free(filename);
        
        
        if ([defautFileManager fileExistsAtPath:filePath isDirectory:nil]){ //Always overwrite the file
            [defautFileManager removeItemAtPath:filePath error:nil];
        }
        
        if (isDirectory){
            [defautFileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else{
            [defautFileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            
            FILE* fp = fopen((const char*)[filePath UTF8String], "wb");
            while(fp){
                int read = BIUnzReadCurrentFile(unzSkinFile, buffer, kBufferSize);
                if(read > 0){
                    fwrite(buffer, read, 1, fp);
                }
                else{
                    break;
                }
            }
            
            if(fp){
                fclose(fp);
                
                NSCalendar*       gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents* dateComponents    = [[NSDateComponents alloc] init];
                dateComponents.second = fileInfo.tmu_date.tm_sec;
                dateComponents.minute = fileInfo.tmu_date.tm_min;
                dateComponents.hour   = fileInfo.tmu_date.tm_hour;
                dateComponents.day    = fileInfo.tmu_date.tm_mday;
                dateComponents.month  = fileInfo.tmu_date.tm_mon + 1;
                dateComponents.year   = fileInfo.tmu_date.tm_year;
                NSDate* modificationDate = [gregorianCalendar dateFromComponents:dateComponents];
                //                [dateComponents    release];
                //                [gregorianCalendar release];
                
                NSDictionary* attributes = [NSDictionary dictionaryWithObject:modificationDate forKey:NSFileModificationDate];
                [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:filePath error:nil];
            }
        }
        
		BIUnzCloseCurrentFile(unzSkinFile);
		ret = BIUnzGoToNextFile(unzSkinFile);
	} while(ret == kUnzOK && ret != kUnzEndOfListOfFile);
    return kUnzOK == BIUnzClose(unzSkinFile) && kUnzEndOfListOfFile == ret;
}

@end
