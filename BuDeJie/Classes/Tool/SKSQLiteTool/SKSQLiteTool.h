//
//  SKSQLiteTool.h
//  BuDeJie
//
//  Created by hongchen li on 2022/6/17.
//  Copyright © 2022 shacokent. All rights reserved.
//
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
    修改当满足条件（某字段名 > 某值 and 某字段名 != 某值 or 某字段名 < 某值）时修改制定字段名的值：update 表名 set 字段名 = 给字段赋的值 where 某字段名 > 某值 and 某字段名 != 某值 or 某字段名 < 某值;
 
 查询相关：统计、排序、limit分页
 统计：
 个数count:
 查询所有的：select count(*) from 表名;
 查询某字段不为NULL的个数：select count(字段名) from 表名;
 平均值avg，求和sum，最大值max，最小值min，用法同上
 
 排序:
 ordet by
 按着某字段 升 / 降序排序：select *from 表名 order by 字段名 ASC/DESC;
 
 混合排序：
 select *from 表名 order by 字段名1 ASC, 字段名2 DESC;（在字段1升序排序过程中，发现字段1有相同的值，相同的部分再按字段2降序排序）
 
 分页：
 select *from 表名 limit 跳过跳条数, 取出条数;
 公式：select *from 表名 limit (n-1)*count, count;(n代表第n页)
 特例取前n条 select *from 表名 limit n;
 
 多表查询
 select * from 表1, 表2 where 表2的某个ID名=表1.id;
 例如select *from t_person, t_weibo where persion_id = t_person.id;    t_weibo的persion_id与 t_person的id相关联，查询到t_person和t_weibo表persion_id等于t_person.id的数据组合返回结果（笛卡尔积）
 
主键:CREATE TABLE IF NOT EXISTS "t_weibo" ("id" INTEGER NOT NULL,"title" TEXT,person_id INTEGER,PRIMARY KEY("id"));
外键:CREATE TABLE IF NOT EXISTS "t_weibo" ("id" INTEGER NOT NULL,"title" TEXT,person_id INTEGER,PRIMARY KEY ("id"),CONSTARAINT "xxx" FPREIGN KEY ("person_id") REFERENCES "t_person" ("id"));
 
 
 给表起别名：例如select * from t_person as tp, t_weibo as tw where persion_id = tp.id;
 给字段起别名：例如select count(*) as num from t_person, t_weibo where persion_id = t_person.id;
 例如select tp.id as tpid, tw.id as twid,name,age from t_person as tp, t_weibo as tw where persion_id = tp.id;
 
 
 /url/lib/libsqlite3.dylib动态库位置
 
 
 
 */
#import <Foundation/Foundation.h>
#import "Single.h"
NS_ASSUME_NONNULL_BEGIN

@interface SKSQLiteTool : NSObject
SingleH(SKSQLiteTool)
/// 创建表
-(BOOL)createTable;
/// 删除表
-(BOOL)dropTable;
/// 执行sql语句
/// @param sql sql语句
-(BOOL)exrcSql:(NSString*)sql;
/// 绑定语句(可插入多条SQL语句)
/// @param sql sql sql语句
/// @param line 插入条目参数数组
-(void)bindSql:(NSString*)sql line:(NSArray<NSArray*>*)line;
@end

NS_ASSUME_NONNULL_END
