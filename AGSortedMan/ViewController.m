//
//  ViewController.m
//  AGSortedMan
//
//  Created by JohnnyB0Y on 2017/3/2.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ViewController.h"
#import "AGStudentModel.h"
#import "NSArray+PinyinSorte.h"

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据 */
@property (nonatomic, copy) NSArray *students;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 测试数据
    [self testWithDataSize:1000];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self students] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self students] objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CCTV";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    
    NSArray *arr = self.students[indexPath.section];
    cell.textLabel.text = [arr[indexPath.row] name];
    cell.detailTextLabel.text = [arr[indexPath.row] pinyin];
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *arr = self.students[section];
    
    return [[arr firstObject] firstLetter];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.;
}

- (void)testWithDataSize:(NSInteger)size {
    
    // 生成数据
    NSString *chineseStr = @"？？呢吗！@#￥可是%怀孕…撕逼&*（）——+👌😝123"\
    "4嗯不尔瀑布步步JJCKAndy惊魂局考虑到ijlk看到类似飞机数波波维奇罗波斯猫博"\
    "士啵神伯特科比唉味儿麦迪达尔文哼哈量更赵龙好玩二铺聘请按照每年BBQ思思NBA安朵"\
    "拉人人车才妈妈普多隆多川普分克里斯；";
    
    NSMutableArray<id<AGPinyinSorteProtocol>> *students = [@[] mutableCopy];
    
    for (int i = 0; i < size; i++) {
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


@end
