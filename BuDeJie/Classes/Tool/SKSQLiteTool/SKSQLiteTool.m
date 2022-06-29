//
//  SKSQLiteTool.m
//  BuDeJie
//
//  Created by hongchen li on 2022/6/17.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSQLiteTool.h"
#import "sqlite3.h"

@implementation SKSQLiteTool

SingleM(SKSQLiteTool)

static sqlite3 * _db = nil;

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if([_instance openDB]){
            [_instance createTable];
        }
    });
    return _instance;
}

#pragma mark - 创建打开数据库
-(BOOL)openDB{
    NSString *sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"test.sqlite"];
    SKLog(@"sqlPath---%@",sqlPath);
//    打开指定数据库，不存在就创建，存在直接打开，并且赋值参数给参数2
//    参数一：数据库路径
//    参数二：已经打开的数据库（如果后期要执行sql语句，都需要借助这个对象）
    if(sqlite3_open(sqlPath.UTF8String, &_db) == SQLITE_OK){
        SKLog(@"数据库创建成功");
        return YES;
    }
    SKLog(@"数据库创建失败");
    return NO;
}

#pragma mark - 执行SQL语句
-(BOOL)exrcSql:(NSString*)sql{
    //    参数一：已经打开的数据库
    //    参数二：修奥执行的字符串
    //    参数三：执行回调
    //    参数四：参数三的参数一
    //    参数五：错误信息
    if(sqlite3_exec(_db, sql.UTF8String, nil, nil, nil) == SQLITE_OK){
        SKLog(@"%@执行成功",sql);
        return YES;
    }
    SKLog(@"%@执行失败",sql);
    return NO;
}

#pragma mark - 创建表
-(BOOL)createTable{
    NSString * sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real default 60)";
    return [_instance exrcSql:sql];
}

#pragma mark - 删除表
-(BOOL)dropTable{
    NSString * sql = @"drop table if exists t_stu";
    return [_instance exrcSql:sql];
}

#pragma mark - 绑定语句(可插入多条SQL语句)
//另一种sql语句写法，绑定语句(sql参数用？占位）
-(void)bindSql:(NSString*)sql line:(NSArray<NSArray*>*)line{
    NSInteger successNum = 0;
    //1.根据sql字符串创建准备语句,2.绑定参数，3执行语句，4重置释放语句
    sqlite3_stmt *ppStmt = nil;
    if([self bindPrepareSql:&ppStmt sql:sql]){
        //    优化，手动开启事务
        [self beginTransaction];
        for(int i=0;i<[line count];i++){
            if([self bindParameters:ppStmt parameters:line[i]]&&[self stepBindSql:ppStmt])
                successNum += 1;
            //重置语句（可以省略）
            sqlite3_reset(ppStmt);
        }
        //    优化，手动提交事务
        [self commitTransaction];
    }
    //释放语句
    sqlite3_finalize(ppStmt);
    SKLog(@"成功--%ld条，失败---%ld条",successNum,[line count]-successNum);
    
}

// 创建预处理语句
-(BOOL)bindPrepareSql:(sqlite3_stmt **)ppStmt sql:(NSString*)sql{
    //    参数一：一个已经打开的数据库
    //    参数二：SQL字符串
    //    参数三：取出字符串长度 “2” ；-1：代表自动计算
    //    参数四：预处理语句
    //    参数五：根据参数三的长度，取出参数二的值后，剩余的参数
    if(sqlite3_prepare_v2(_db, sql.UTF8String, -1, ppStmt, nil) == SQLITE_OK){
        SKLog(@"%@预处理成功",sql);
        return YES;
    }
    SKLog(@"%@预处理失败",sql);
    return NO;
}

//绑定参数（可以省略）
-(BOOL)bindParameters:(sqlite3_stmt *)ppStmt parameters:(NSArray*)parameters{
    BOOL isBindParameterSuccess=YES;
    for(int i=0;i<[parameters count];i++){
        if([parameters[i] isKindOfClass:[NSString class]]){
            //参数一：预处理语句
            //参数二：绑定语句索引：索引从1开始
            //参数三：需要绑定的值
            //参数四:值取出多少长度,-1取出所有
            //参数五：值的处理方式:
            //SQLITE_STATIC:认为参数是一个常量，不会被释放，处理方案不做任何的引用
            //SQLITE_TRANSIENT:会对参数进行引用
            sqlite3_bind_text(ppStmt, i+1, ((NSString*)parameters[i]).UTF8String, -1, SQLITE_TRANSIENT);
            SKLog(@"string-%d-%@",i+1,parameters[i]);
        }
        else if(strcmp([parameters[i] objCType], @encode(int)) == 0){
            //参数一：预处理语句
            //参数二：绑定语句索引：索引从1开始
            //参数三：需要绑定的值
            sqlite3_bind_int(ppStmt, i+1, [parameters[i] intValue]);
            SKLog(@"int-%d-%@",i+1,parameters[i]);
        }
        else if(strcmp([parameters[i] objCType], @encode(float)) == 0){
            sqlite3_bind_double(ppStmt, i+1, [parameters[i] floatValue]);
            SKLog(@"float-%d-%@",i+1,parameters[i]);
        }
        else if(strcmp([parameters[i] objCType], @encode(double)) == 0){
            sqlite3_bind_double(ppStmt, i+1, [parameters[i] doubleValue]);
            SKLog(@"double-%d-%@",i+1,parameters[i]);
        }
        else if(strcmp([parameters[i] objCType], @encode(BOOL)) == 0){
            sqlite3_bind_int(ppStmt, i+1, [parameters[i] intValue]);
            SKLog(@"bool-%d-%@",i+1,parameters[i]);
        }
        else{
            isBindParameterSuccess = NO;
            break;
        }
    }
    isBindParameterSuccess?SKLog(@"绑定参数成功"):SKLog(@"绑定参数失败");
    return isBindParameterSuccess;
}

//执行绑定语句
-(BOOL)stepBindSql:(sqlite3_stmt *)ppStmt{
    if(sqlite3_step(ppStmt) == SQLITE_DONE){
        SKLog(@"执行成功");
        return YES;
    }
    SKLog(@"执行失败");
    return NO;
}
#pragma mark - 优化方案
//如果使用sqlite3_exec或者sqlite3_step来执行sql语句，会自动开启一个”事务“，然后自动提交”事务“，很耗时
//解决：手动开启事务，或手动提交事务，函数内部不会自动开启和提交事务
//开启事务
-(void)beginTransaction{
    NSString * sql = @"begin transaction";
    [self exrcSql:sql];
}
//提交事务
-(void)commitTransaction{
    NSString * sql = @"commit transaction";
    [self exrcSql:sql];
}
//回退事务
-(void)rollbackTransaction{
    NSString * sql = @"rollback transaction";
    [self exrcSql:sql];
}

#pragma mark - 查询方法一
-(NSMutableArray<NSMutableDictionary*>*)queryAll{
    NSString * sql = @"select * from t_stu";
    //    参数一：已经打开的数据库
    //    参数二：执行的字符串
    //    参数三：执行回调
        //      回调参数一：参数四传递过来的值
        //      回调参数二：列的个数
        //      回调参数三：值的数组
        //      回调参数四：列名数组
        //      返回值：0，继续查询（可以全部查完）；1，终止查询(查询一条就终止了),(补充返回0查询成功判断SQLITE_OK,返回1查询成功判断SQLITE_ABORT)
    //    参数四：参数三的参数一
    //    参数五：错误信息
    NSMutableArray<NSMutableDictionary*>* queryResult = [NSMutableArray array];
    int resultcode = sqlite3_exec(_db, sql.UTF8String, callback, (__bridge void *)(queryResult), nil);
    if(resultcode == SQLITE_OK){
        SKLog(@"查询成功");
        return queryResult;
    }
    else{
        SKLog(@"查询失败");
        return [NSMutableArray array];
    }
}

int callback(void *queryResult, int columnCount, char **values, char **columnName)
{
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    for(int i=0; i<columnCount; i++){
        [queryDict setObject:[NSString stringWithFormat:@"%s",values[i]] forKey:[NSString stringWithFormat:@"%s",columnName[i]]];
        if((i+1)%4 == 0){
            NSMutableDictionary *saveDict = [NSMutableDictionary dictionaryWithDictionary:queryDict];
            [(__bridge NSMutableArray<NSMutableDictionary*>*)queryResult addObject:saveDict] ;
            queryDict = [NSMutableDictionary dictionary];
        }
    }
    return 0;
}

#pragma mark - 查询方法二
-(NSMutableArray<NSMutableDictionary*>*)queryAllStmt{
    sqlite3_stmt *ppStmt = nil;
    NSMutableArray<NSMutableDictionary*>* queryResult = [NSMutableArray array];
    BOOL isBindSuccess = YES;
    if([self bindPrepareSql:&ppStmt sql:@"select * from t_stu"]){
        //绑定参数（可以省略）
        //执行准备语句，sqlite3_step作用执行DQL语句时会把执行得的结果放到预处理语句sqlite3_stmt中
        BOOL isgetValue = YES;
        while (sqlite3_step(ppStmt) == SQLITE_ROW) {
//           读取结果
            int count = sqlite3_column_count(ppStmt);
            NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
            
            for(int i=0; i<count; i++){
//                获取这一列的类型
                 int type = sqlite3_column_type(ppStmt, i);
                //                根据不同类型使用不同函数获取结果
                if(type == SQLITE_TEXT){
                    [queryDict setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(ppStmt, i)] forKey:[NSString stringWithFormat:@"%s",sqlite3_column_name(ppStmt, i)]];
                }
                else if(type == SQLITE_INTEGER){
                    [queryDict setObject:[NSString stringWithFormat:@"%d",sqlite3_column_int(ppStmt, i)] forKey:[NSString stringWithFormat:@"%s",sqlite3_column_name(ppStmt, i)]];
                }
                else if(type == SQLITE_FLOAT){
                    [queryDict setObject:[NSString stringWithFormat:@"%f",sqlite3_column_double(ppStmt, i)] forKey:[NSString stringWithFormat:@"%s",sqlite3_column_name(ppStmt, i)]];
                }
                else{
                    isgetValue = NO;
                    break;
                }
            }
            if(!isgetValue){
                break;
            }
            [queryResult addObject:queryDict] ;
        }
        if(!isgetValue){
            //释放语句
            isBindSuccess = NO;
        }
        //重置语句（可以省略）
    }
    else{
        isBindSuccess = NO;
    }
    //释放语句
    sqlite3_finalize(ppStmt);
    if(!isBindSuccess){
        SKLog(@"查询失败");
        return [NSMutableArray array];
    }
    SKLog(@"查询成功");
    return queryResult;
}

@end
