//
//  SKStudent.m
//  BuDeJie
//
//  Created by hongchen li on 2022/6/17.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKStudent.h"
#import "SKSQLiteTool.h"
#import "sqlite3.h"
@implementation SKStudent
- (instancetype)init:(NSString*)name age:(int)age score:(float)score{
    self = [super init];
    if(self != nil){
        self.name = name;
        self.age = age;
        self.score = score;
    }
    return self;
}

-(void)insertStudent{
    NSString * sql = [NSString stringWithFormat:@"insert into t_stu(name,age,score) values('%@',%d,%f)",self.name,self.age,self.score];
    if([[SKSQLiteTool shareSKSQLiteTool] exrcSql:sql])
        SKLog(@"插入stu成功");
}

+(void)deleteStudent:(NSString *)name{
    NSString * sql = [NSString stringWithFormat:@"delete from t_stu where name = '%@'",name];
    if([[SKSQLiteTool shareSKSQLiteTool] exrcSql:sql])
        SKLog(@"删除stu成功");
}

-(void)updateStudent:(SKStudent*)newStu{
    NSString * sql = [NSString stringWithFormat:@"update t_stu set name = '%@',age = %d,score = %f where name = '%@'",newStu.name,newStu.age,newStu.score,self.name];
    if([[SKSQLiteTool shareSKSQLiteTool] exrcSql:sql])
        SKLog(@"修改stu成功");
}

//另一种sql语句写法，绑定语句(？)占位
-(void)bindInsert:(NSArray<NSArray*>*)line{
    NSString * sql = @"insert into t_stu(name,age,score) values(?,?,?)";
    [[SKSQLiteTool shareSKSQLiteTool] bindSql:sql line:line];
}
@end
