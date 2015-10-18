//
//  ViewController.m
//  FMDB线程安全
//
//  Created by ji on 15/8/11.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()
@property (nonatomic,strong)FMDatabaseQueue *dataBaseQ;
@end

@implementation ViewController
//线程安全 公共资源 A使用 的时候 B不能使用

//int a = 110;
//
//100 - 90;
//A  a = 10;
//
//排队等待:
//10 + 100
//
//B  a = 110;

- (IBAction)insertData:(id)sender {
    
    [self.dataBaseQ inDatabase:^(FMDatabase *db) {
        //3.增加 数据 (100条 数据随机)
        for (int i = 0; i <100; i++) {
            
            NSString *strName = [NSString stringWithFormat:@"8mingyeuxin-%d",i];
            
            NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_student (name ,score)VALUES('%@',%.02f)",strName,arc4random_uniform(1000)/10.0];
            
            //执行 //非查询语句  执行的方法
            BOOL success =  [db executeUpdate:sqlStr];
            if (success) {
                NSLog(@"添加成功!");
            }else{
                NSLog(@"添加失败!");
            }
            
        }
        
    }];
    
}
- (IBAction)selectData:(id)sender {
    [self.dataBaseQ inDatabase:^(FMDatabase *db) {
        
        NSString *strSql =  @"SELECT * FROM t_student WHERE score > 60.0 ORDER BY score DESC;";
        //查询语句  执行的方法
        FMResultSet *set =  [db executeQuery:strSql];
        
        while ([set next]) {
            //name
            //NSString *name = [set stringForColumnIndex:1];
            NSString *name = [set stringForColumn:@"name"];
            //score
            CGFloat score = [set doubleForColumn:@"score"];
            
            NSLog(@"name = %@  score = %f",name,score);
        }
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打开数据库 如果没有就创建
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"data.sqlite"];
    //创建数据库的队列
    FMDatabaseQueue *dataBaseQ = [FMDatabaseQueue databaseQueueWithPath:path];
    self.dataBaseQ = dataBaseQ;
    [dataBaseQ inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db open];
        if (success) {
            NSLog(@"数据库创建成功!");
            //2.创建表
            NSString *str = @"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, score REAL NOT NULL)";
            if ([db executeUpdate:str]) {
                NSLog(@"表创建成功!");
            }else{
                NSLog(@"创建表失败!");
            }
        }else{
            NSLog(@"数据库创建失败!");
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
