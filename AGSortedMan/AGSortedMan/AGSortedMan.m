//
//  AGSortedMan.m
//  
//
//  Created by JohnnyB0Y on 2017/10/10.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  排序者

#import "AGSortedMan.h"

@interface AGSortedMan ()

/** en_US */
@property (nonatomic, strong) NSLocale *en_locale;

/** zh_CN */
@property (nonatomic, strong) NSLocale *zh_locale;

@end


@implementation AGSortedMan

#pragma mark - ---------- Public Methods ----------
/** 按拼音首字母分割的VMM */
- (AGVMManager *)ag_sortedPinyinList:(NSArray<NSDictionary *> *)list
                         bySortedKey:(NSString *)sortedkey
                             inBlock:(AGVMPackageDatasBlock)block
{
    // 0. 无元素直接返回
    if (list.count < 1) return nil;
    
    // 1. 排好序的数据
    AGVMSection *vms = [self ag_sortedPinyinList:list bySortedKey:sortedkey options:NSSortStable inBlock:block];
    
    // 2. 字母分段
    AGVMManager *vmm = ag_VMManager(32);
    __block AGVMSection *subVms;
    __block NSString *firsterLetter = nil;
    [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [vm[kAGSortedManFirstLetter] isEqualToString:firsterLetter] ) {
            // 相同字母
            [subVms ag_addItem:vm];
            
        }
        else {
            // 不同字母
            firsterLetter = vm[kAGSortedManFirstLetter];
            subVms = ag_VMSection(6);
            [subVms ag_addItem:vm];
            [vmm ag_addSection:subVms];
            
        }
    }];
    
    // 把#分类放到最后，如果有
    if ( vmm.count > 0 && [vmm.firstSection.firstViewModel[kAGSortedManFirstLetter] isEqualToString:@"#"] ) {
        [vmm ag_addSection:vmm.firstSection];
        [vmm ag_removeSectionAtIndex:0];
    }
    
    return vmm;
}

/** 按拼音排序的VMS */
- (AGVMSection *)ag_sortedPinyinList:(NSArray<NSDictionary *> *)list
                         bySortedKey:(NSString *)sortedkey
                             options:(NSSortOptions)opts
                             inBlock:(AGVMPackageDatasBlock)block
{
    AGVMSection *vms = ag_VMSection(list.count);
    
    // 1. 初始化数据
    NSMutableArray<AGViewModel *> *arrM = ag_mutableArray(list.count);
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AGViewModel *vm =
        [AGViewModel ag_viewModelWithModel:nil
                                  capacity:obj.count];
        block ? block(vm.bindingModel, obj, idx) : nil;
        
        // 转化 - 拼音
        [self _setupPinyinVM:vm fromSortedStr:obj[sortedkey]];
        
        [arrM addObject:vm];
    }];
    
    // 2. 排序
    if (arrM.count < 1) {
        // 无元素直接返回
        return nil;
    } else if ( arrM.count == 1 ) {
        // 只有一个元素
        return [vms ag_addItemsFromArray:arrM];
    }
    
    // 多元素排序
    NSArray<AGViewModel *> *newArr = [arrM sortedArrayWithOptions:opts usingComparator:^NSComparisonResult(AGViewModel *obj1, AGViewModel *obj2) {
        
        static NSStringCompareOptions comparisonOptions =  NSForcedOrderingSearch;
        NSString *str1 = obj1[kAGSortedManPinyin];
        NSString *str2 = obj2[kAGSortedManPinyin];
        NSRange string1Range = NSMakeRange(0, [str1 length]);
        return [str1 compare:str2
                     options:comparisonOptions
                       range:string1Range
                      locale:self.en_locale];
        
    }];
    
    return [vms ag_addItemsFromArray:newArr];
}

#pragma mark - ---------- Private Methods ----------
- (void) _setupPinyinVM:(AGViewModel *)vm fromSortedStr:(NSString *)str
{
    // 转拼音
    NSString *pinyinStr = [self _transformToPinyin:str];
    vm[kAGSortedManPinyin] = pinyinStr;
    
    // 首字母
    unichar fC = [pinyinStr characterAtIndex:0];
    if ( ( fC >= 65 && fC <= 90 ) || ( fC >= 97 && fC <= 122 ) ) {
        vm[kAGSortedManFirstLetter] = [[NSString stringWithFormat:@"%c", fC] uppercaseString];
        
    }
    else {
        static NSString *wellStr = @"#";
        vm[kAGSortedManFirstLetter] = wellStr;
    }
}

- (NSString *) _transformToPinyin:(NSString *)str {
    // 特殊文字替换
    static NSString *spacingStr = @" ";
    static NSString *quotationStr = @"'";
    static NSString *emptyStr = @"";
    static NSString *replacingStr1 = @"嗯";
    static NSString *replacingToStr1 = @"en";
    str = [str stringByReplacingOccurrencesOfString:replacingStr1 withString:replacingToStr1];
    
    NSMutableString *strM = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)strM, NULL, kCFStringTransformToLatin, NO);
    NSString *pinyinStr = (NSMutableString *)[strM stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:self.zh_locale];
    
    // 去掉空格和 @“‘”
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:spacingStr withString:emptyStr];
    return [pinyinStr stringByReplacingOccurrencesOfString:quotationStr withString:emptyStr];
}

#pragma mark - ----------- Getter Methods ----------
- (NSLocale *)en_locale
{
    if (_en_locale == nil) {
        _en_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    return _en_locale;
}

- (NSLocale *)zh_locale
{
    if (_zh_locale == nil) {
        _zh_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _zh_locale;
}

@end



/** 首字母 默认大写 */
NSString * const kAGSortedManFirstLetter = @"kAGSortedManFirstLetter";
/** 拼音字母 */
NSString * const kAGSortedManPinyin = @"kAGSortedManPinyin";


