# AGSortedMan 通讯录-拼音排序

#### 使用步骤：
##### 1，导入分类头文件 #import "NSArray+PinyinSorte.h" 。
##### 2，让你要排序的模型类实现 AGPinyinSorteProtocol 协议。
##### 3，模型塞入数组，然后调用数组分类方法。
##### 4，返回你想要的数据使用就是了。

#### 简单使用举例
```

- (void)testWithDataSize:(NSInteger)size {
    
    NSString *chineseStr = @"？？呢吗！@#￥可是%怀孕…撕逼&*（）——+👌😝123"\
    "4嗯不尔瀑布步步JJCKAndy惊魂局考虑到ijlk看到类似飞机数波波维奇罗波斯猫博"\
    "士啵神伯特科比唉味儿麦迪达尔文哼哈量更赵龙好玩二铺聘请按照每年BBQ思思NBA安朵"\
    "拉人人车才妈妈普多隆多川普分克里斯；";
    
    NSMutableArray<id<AGPinyinSorteProtocol>> *students = [@[] mutableCopy];
    
    for (int i = 0; i < size; i++) {
        // AGStudentModel 是遵守了 AGPinyinSorteProtocol 协议的
        AGStudentModel * sm = [AGStudentModel new];
        sm.age = @(arc4random_uniform(100));
        
        NSRange nameRange = NSMakeRange(arc4random_uniform((unsigned)chineseStr.length - 3), 4);
        
        sm.name = [chineseStr substringWithRange:nameRange];
        
        [students addObject:sm];
    }
    
    // 排序
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    NSArray *arr = [students ag_pinYinSortedArrayList];
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"%ld个元素排序用时：%f", students.count, endTime - startTime);
    
    self.students = arr;
    
}

```
