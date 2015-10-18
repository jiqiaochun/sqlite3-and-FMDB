//
//  ViewController.m
//  sql数据库使用
//
//  Created by ji on 15/8/11.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
@interface ViewController ()

//1.创建数据库 (保存路径)
@property (nonatomic,assign)sqlite3 *db;
@end

@implementation ViewController
- (IBAction)insertData:(UIButton *)sender {
    
    //3.增加 数据 (100条 数据随机)
    for (int i = 0; i <2; i++) {
        
        NSString *strName = [NSString stringWithFormat:@"8mingyeuxin-%d",i];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_student (name ,score)VALUES('%@',%.02f)",strName,arc4random_uniform(1000)/10.0];
        
        //执行
        int success =   sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
        if (success == SQLITE_OK) {
            NSLog(@"添加成功!");
        }else{
            NSLog(@"添加失败!");
        }
        
    }
    
    
    
}
- (IBAction)deleteData:(UIButton *)sender {
    
    //4.删除 数据 (70 - 80 分数)
    NSString *sqlStr = @"DELETE FROM t_student WHERE score > 80.0";
    
    //执行
    int success =   sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (success == SQLITE_OK) {
        NSLog(@"删除成功!");
    }else{
        NSLog(@"删除失败!");
    }
}
- (IBAction)updateData:(UIButton *)sender {
    //5.修改 数据 (修改分数小于60.0为60.0)
    NSString *sqlStr = @"UPDATE t_student SET score = 60.0 WHERE score < 60.0";
    
    //执行
    int success = sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (success == SQLITE_OK) {
        NSLog(@"修改成功!");
    }else{
        NSLog(@"修改失败!");
    }
    
}
- (IBAction)selectData:(UIButton *)sender {
    
    //6.查询数据 ( score >= 60)
    //NSString *sqlStr = @"SELECT * FROM t_student WHERE score > 60.0 ORDER BY score DESC;";
    //查询数据 ( name  中带 8 数字)
    NSString *sqlStr = @"SELECT * FROM t_student WHERE name LIKE '%ming%'";
    //查询之后  把结果放在 stmt对象
    // 保存所有的结果集
    sqlite3_stmt *stmt = nil;
    
    sqlite3_prepare_v2(_db, sqlStr.UTF8String, -1, &stmt, NULL);
    
    //获取到所有结果  每一步  查询到一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        //取出一条记录
        // name TEXT    column
        const unsigned char * name =  sqlite3_column_text(stmt, 1);
        NSString *strName = [NSString stringWithCString:(const char *)name encoding:NSUTF8StringEncoding];
        //score  REAL
        double score =  sqlite3_column_double(stmt, 2);
        
        NSLog(@"name = %@  score = %f",strName,score);
        
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //打开数据库 如果没有就创建
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"data.sqlite"];
    
    
    NSLog(@"%@",path);
    
    int success =  sqlite3_open(path.UTF8String, &_db);
    
    if (success == SQLITE_OK) {
        NSLog(@"创建数据库成功!");
        //2.创建表 (指定字段  -> 需求: 保存 学生信息 id  name score)
        //用sql语句 来创建
        //编写sql语句
        NSString *str = @"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, score REAL NOT NULL)";
        
        //执行sql语句
        int success_t =  sqlite3_exec(_db, str.UTF8String, NULL, NULL, NULL);
        if (success_t == SQLITE_OK) {
            NSLog(@"创建表成功!");
        }else{
            NSLog(@"创建表失败!");
        }
        
        
    }else{
        NSLog(@"创建数据库失败!");
    }
    
    //关闭数据库
    //sqlite3_close(_db);
}



@end
