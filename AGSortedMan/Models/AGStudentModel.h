//
//  AGStudentModel.h
//  AGSortedMan
//
//  Created by JohnnyB0Y on 2017/2/28.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  学生模型

#import <Foundation/Foundation.h>
#import "NSArray+PinyinSorte.h"


@interface AGStudentModel : NSObject<AGPinyinSorteProtocol>

/** firstLetter */
@property (nonatomic, copy) NSString *firstLetter;

/** 拼音字母 */
@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;

@end
