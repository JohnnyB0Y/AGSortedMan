//
//  AGSortedMan.h
//  
//
//  Created by JohnnyB0Y on 2017/10/10.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  排序者

#import <Foundation/Foundation.h>
#import "AGVMKit.h"

/** 首字母 默认大写 */
UIKIT_EXTERN NSString * const kAGSortedManFirstLetter;
/** 拼音字母 */
UIKIT_EXTERN NSString * const kAGSortedManPinyin;

@interface AGSortedMan : NSObject

/** 按拼音首字母分割的VMM */
- (AGVMManager *)ag_sortedPinyinList:(NSArray<NSDictionary *> *)list
                         bySortedKey:(NSString *)sortedkey
                             inBlock:(AGVMPackageDatasBlock)block;

/** 按拼音排序的VMS */
- (AGVMSection *)ag_sortedPinyinList:(NSArray<NSDictionary *> *)list
                         bySortedKey:(NSString *)sortedkey
                             options:(NSSortOptions)opts
                             inBlock:(AGVMPackageDatasBlock)block;

@end
