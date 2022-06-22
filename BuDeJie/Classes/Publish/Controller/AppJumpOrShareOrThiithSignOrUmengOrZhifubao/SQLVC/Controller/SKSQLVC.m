//
//  SKSQLVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/5/26.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSQLVC.h"
#import "SKSQLiteTool.h"
#import "SKStudent.h"
@interface SKSQLVC ()

@end

@implementation SKSQLVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[SKSQLiteTool shareSKSQLiteTool] dropTable];
    SKStudent *stu = [[SKStudent alloc]init:@"test" age:SKRandomNum(100) score:SKRandomNum(100.0)];
    [stu insertStudent];
    [SKStudent deleteStudent:@"test"];
    stu.name = @"test2";
    [stu insertStudent];
    SKStudent *stu2 = [[SKStudent alloc]init:@"test3" age:SKRandomNum(100) score:SKRandomNum(100.0)];
    [stu updateStudent:stu2];
    [stu bindInsert:@[@[@"test4",[NSNumber numberWithInt:SKRandomNum(100)],[NSNumber numberWithFloat:SKRandomNum(100)]],@[@"test5",[NSNumber numberWithInt:SKRandomNum(100)],[NSNumber numberWithFloat:SKRandomNum(100)]],@[@"test6",[NSNumber numberWithInt:SKRandomNum(100)],[NSNumber numberWithFloat:SKRandomNum(100)]]]];
}

@end
