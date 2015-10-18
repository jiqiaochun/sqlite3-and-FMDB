//
//  ViewController.m
//  FMDB的使用
//
//  Created by ji on 15/8/11.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()
@property (nonatomic,strong)FMDatabase *dataBase;
@end

@implementation ViewController
- (IBAction)insertData:(id)sender {
    
    //3.增加 数据 (100条 数据随机)
    for (int i = 0; i <100; i++) {
        
        NSString *strName = [NSString stringWithFormat:@"8mingyeuxin-%d",i];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_student (name ,score)VALUES('%@',%.02f)",strName,arc4random_uniform(1000)/10.0];
        
        //执行 //非查询语句  执行的方法
        BOOL success =  [self.dataBase executeUpdate:sqlStr];
        if (success) {
            NSLog(@"添加成功!");
        }else{
            NSLog(@"添加失败!");
        }
        
    }
    
    
}
- (IBAction)selectData:(id)sender {
    
    NSString *strSql =  @"SELECT * FROM t_student WHERE score > 60.0 ORDER BY score DESC;";
    //查询语句  执行的方法
    FMResultSet *set =  [self.dataBase executeQuery:strSql];
    
    while ([set next]) {
        //name
        //NSString *name = [set stringForColumnIndex:1];
        NSString *name = [set stringForColumn:@"name"];
        //score
        CGFloat score = [set doubleForColumn:@"score"];
        
        NSLog(@"name = %@  score = %f",name,score);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    self.dataBase = dataBase;
    
    BOOL success = [dataBase open];
    if (success) {
        NSLog(@"数据库创建成功!");
        //2.创建表
        NSString *str = @"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, score REAL NOT NULL)";
        if ([self.dataBase executeUpdate:str]) {
            NSLog(@"表创建成功!");
        }else{
            NSLog(@"创建表失败!");
        }
    }else{
        NSLog(@"数据库创建失败!");
    }
    
}


@end
