//
//  SKSQLVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/5/26.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSQLVC.h"
//数据化数据库软件navicat
/**
DDL语句:
    创建表：CREATE TABLE IF NOT EXISTS 表名(字段名1 字段类型1，2，3...);
    加上IF NOT EXISTS关键字，如果表已存在就不创建，不加关键字，创建重复表会报错
    删除表：DROP TABLE IF EXISTS 表名
    加上IF EXISTS关键字，如果表不存在就不删除，不加关键字，删除不存在的表会报错
    修改表：（注意sqlite只能修改表名和新增属性，不能删除列或修改的已存在的列名）
    修改表名：ALTER TABLE 旧表名 RENAME TO 新表名
    新增属性 ：ALTER TABLE 表名 ADD COLUMN 列名 数据类型 限定符（可不写）
约束：
    简单约束：不能为空，不能重复，默认值
    主键约束：
    创建表加约束,设置主键并且自动增长,字段1不能为空,字段2设置默认值等于60：CREATE TABLE IF NOT EXISTS 表名(主键 主键类型 primary key AUTOINCREMENT，字段名1 字段类型1 not NULL，字段名2 字段类型2 DEFAULT 60);
DML语句：增删改查
    插入：insert into 表名(字段名1,字段名2,字段名3) values(给字段1赋的值,给字段2赋的值,给字段3赋的值);
    修改：update 表名 set 字段名 = 给字段赋的值;
        注意：更改所有行
    删除：delete from 表名;
        注意：删除所有行
条件语句：
    注意：!= 等于 is not ，=等于is
    删除字段名等于指定值的行：delete from 表名 where 字段名 is 指定值;
    修改当满足条件（某字段名 > 某值 and 某字段名 != 某值 or 某字段名 < 某值）时修改制定字段名的值：update 表名 set 字段名 = 给字段赋的值 where 某字段名 > 某值 and 某字段名 != 某值 or 某字段名 < 某值
 */
@interface SKSQLVC ()

@end

@implementation SKSQLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



@end
