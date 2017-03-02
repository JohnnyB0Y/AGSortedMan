//
//  NSArray+PinyinSorte.h
//  test22
//
//  Created by JohnnyB0Y on 2017/3/1.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

/** 
 
 要排序的数组内部模型对象，需实现 AGPinyinSorteProtocol 协议。
 
 */

#import <Foundation/Foundation.h>

@protocol AGPinyinSorteProtocol;


@interface NSArray (PinyinSorte)

/** 按拼音分割的数组 */
- (NSArray<id<AGPinyinSorteProtocol>> *)ag_pinYinSortedArray;
- (NSArray<id<AGPinyinSorteProtocol>> *)ag_pinYinSortedArrayWithOptions:(NSSortOptions)opts;

/** 按拼音首字母分割的数组列表 */
- (NSArray<NSArray<id<AGPinyinSorteProtocol>> *> *)ag_pinYinSortedArrays;

@end

@protocol AGPinyinSorteProtocol <NSObject>

@required // 必须实现

/** 首字母 默认大写 */
@property (nonatomic, copy) NSString *firstLetter;

/** 拼音字母 */
@property (nonatomic, copy) NSString *pinyin;

/** 取出要排序的文字或数字 */
- (NSString *) sortedStr;

@end
