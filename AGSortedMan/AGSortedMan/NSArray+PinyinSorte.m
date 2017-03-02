//
//  NSArray+PinyinSorte.m
//  test22
//
//  Created by JohnnyB0Y on 2017/3/1.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "NSArray+PinyinSorte.h"

@implementation NSArray (PinyinSorte)

- (NSArray<id<AGPinyinSorteProtocol>> *)ag_pinYinSortedArray
{
    return [self ag_pinYinSortedArrayWithOptions:NSSortStable];
}

- (NSArray<id<AGPinyinSorteProtocol>> *)ag_pinYinSortedArrayWithOptions:(NSSortOptions)opts
{
    // 无元素直接返回
    if (self.count < 1) return nil;
    
    // 排序
    return [self sortedArrayWithOptions:opts usingComparator:^NSComparisonResult(id<AGPinyinSorteProtocol>  _Nonnull obj1, id<AGPinyinSorteProtocol>  _Nonnull obj2) {
        
        //@"en_US"\@"zh_CN"];
        static NSLocale *locale;
        if ( ! locale ) {
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        }
        static NSStringCompareOptions comparisonOptions =  NSForcedOrderingSearch;
        NSString *str1 = [self _pinyinStrFromModel:obj1];
        NSString *str2 = [self _pinyinStrFromModel:obj2];
        NSRange string1Range = NSMakeRange(0, [str1 length]);
        return [str1 compare:str2 options:comparisonOptions range:string1Range
                      locale:locale];
    }];
    
}

/** 按拼音首字母分割的数组列表 */
- (NSArray<NSArray<id<AGPinyinSorteProtocol>> *> *)ag_pinYinSortedArrayList
{
    // 无元素直接返回
    if (self.count < 1) return nil;
    
    // 排序
    NSArray<id<AGPinyinSorteProtocol>> *arr = [self ag_pinYinSortedArray];
    
    // 分割成数组
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:10];
    __block NSMutableArray *subArrM = nil;
    __block NSString *firsterLetter = nil;
    [arr enumerateObjectsUsingBlock:^(id<AGPinyinSorteProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ( [[obj firstLetter] isEqualToString:firsterLetter] ) {
            // 相同字母
            [subArrM addObject:obj];
            
        } else {
            // 不同字母
            firsterLetter = [obj firstLetter];
            subArrM = [NSMutableArray arrayWithCapacity:5];
            [subArrM addObject:obj];
            [arrM addObject:subArrM];
            
        }
        
    }];
    
    // 把#分类放到最后，如果有
    if ( [arrM count] > 1 && [[[[arrM firstObject] firstObject] firstLetter] isEqualToString:@"#"] ) {
        [arrM addObject:[arrM firstObject]];
        [arrM removeObjectAtIndex:0];
    }
    
    return [arrM copy];
}

- (NSString *) _pinyinStrFromModel:(id<AGPinyinSorteProtocol>)model
{
    NSString *pinyinStr = nil;
    
    if ( [model respondsToSelector:@selector(setPinyin:)] &&
         [model respondsToSelector:@selector(pinyin)] &&
         [model respondsToSelector:@selector(sortedStr)] ) {
        
        pinyinStr = [model pinyin];
        if ( ! pinyinStr ) {
            pinyinStr = [self _transformToPinyin:[model sortedStr]];
            [model setPinyin:pinyinStr];
            
            // 首字母
            if ( [model respondsToSelector:@selector(setFirstLetter:)] ) {
                
                unichar fC = [pinyinStr characterAtIndex:0];
                
                if ( ( fC >= 65 && fC <= 90 ) || ( fC >= 97 && fC <= 122 ) ) {
                    
                    [model setFirstLetter:[[NSString stringWithFormat:@"%c", fC] uppercaseString]];
                } else {
                    static NSString *wellStr = @"#";
                    [model setFirstLetter:wellStr];
                }
                
            }
            
        }
    }
    
    return pinyinStr;
}

- (NSString *) _transformToPinyin:(NSString *)str {
    // 特殊文字替换
    static NSString *spacingStr = @" ";
    static NSString *quotationStr = @"'";
    static NSString *emptyStr = @"";
    static NSString *replacingStr1 = @"嗯";
    static NSString *replacingToStr1 = @"en";
    str = [str stringByReplacingOccurrencesOfString:replacingStr1 withString:replacingToStr1];
    
    static NSLocale *locale;
    if ( ! locale ) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    
    NSMutableString *strM = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)strM, NULL, kCFStringTransformToLatin, NO);
    NSString *pinyinStr = (NSMutableString *)[strM stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    
    // 去掉空格和 @“‘”
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:spacingStr withString:emptyStr];
    return [pinyinStr stringByReplacingOccurrencesOfString:quotationStr withString:emptyStr];
}

@end
