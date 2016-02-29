//
//  ViewController.m
//  testFMDB
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 PaPaTV. All rights reserved.
//

#import "ViewController.h"

#import <FMDB.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *find;
@property (weak, nonatomic) IBOutlet UILabel *character;
@property (weak, nonatomic) IBOutlet UILabel *meaning;
@property (weak, nonatomic) IBOutlet UILabel *statement;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ViewController



- (IBAction)readTXTFile:(id)sender {
    
    [self readTxt];
    
}

- (IBAction)SaveBt:(id)sender {
    
    [self creatDB];
    
}

- (IBAction)clear:(id)sender {
    
//    [self.db executeUpdate:@"DROP TABLE IF EXISTS CHARACTERS;"];
//    [self.db executeUpdate:@"DELETE FROM CHARACTERS;"];
    
    [self.db executeUpdate:@"DROP TABLE IF EXISTS CHARACTERS;"];
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS CHARACTERS (NUM INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , WORD TEXT NOT NULL, MEANING TEXT NOT NULL ,STATEMENT TEXT NOT NULL , TRANSLATE TEXT NOT NULL , TIME TEXT NOT NULL)"];
    
    
    
    NSLog(@"----%@",_dbPath);
}

- (IBAction)insert:(id)sender {
    
    [self readTxt];
    
}

- (IBAction)queryBt:(id)sender {
    
    // 1.执行查询语句
         FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM CHARACTERS"];
    
         // 2.遍历结果
         while ([resultSet next]) {
       
             NSInteger ID = [resultSet intForColumn:@"NUM"];
             
             NSString *word = [resultSet stringForColumn:@"WORD"];
             
             NSString *meaning = [resultSet stringForColumn:@"MEANING"];
             
             NSString *statement = [resultSet stringForColumn:@"STATEMENT"];

             
                 NSLog(@"%ld %@ %@ %@", ID, word, meaning,statement);
             }
    
}

- (IBAction)showrandom:(id)sender {
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"word.sqlite"];
    
    NSLog(@"%@",_dbPath);
    
}


- (void)creatDB{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        
        if ([db open]) {
            NSString * sql = @"CREATE TABLE IF NOT EXISTS CHARACTERS (NUM INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , WORD TEXT NOT NULL, MEANING TEXT NOT NULL ,STATEMENT TEXT NOT NULL , TRANSLATE TEXT NOT NULL , TIME TEXT NOT NULL)";
            
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            
            self.db = db;
            
//            [db close];
            
        } else {
            
            NSLog(@"error when open db");
            
        }
        
    }
    
}


- (void) insertDBWithIndex:(NSInteger)index
                      Word:(NSString *)word
                   Meaning:(NSString *)meaning
                 Statement:(NSString *)statement
                 Translate:(NSString *)translate
                     Timer:(NSString *)timer{
    
    
//    [self.db executeUpdate:@"INSERT INTO CHARACTERS (NUM,WORD,MEANING,STATEMENT,TRANSLATE,TIME) VALUES (?,?,?,?,?,?);", index, word,meaning,statement,translate,timer];
    
    
    [self.db executeUpdateWithFormat:@"INSERT INTO CHARACTERS (NUM, WORD,MEANING,STATEMENT,TRANSLATE,TIME) VALUES (%ld, %@ ,%@ ,%@ ,%@, %@);", index,word,meaning,statement,translate,timer];
}


- (void)readTxt{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"m1" ofType:@".txt"];
    
    NSString *str = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",str);
    
    [self spliteStringWithString:str];
    
}

- (void)spliteStringWithString:(NSString *)string{

    NSArray *strs = [string componentsSeparatedByString:@"\n"];
    
    NSLog(@"%@",strs);
    
    NSInteger Num = 0;
    
    for (int i = 0; i < strs.count; i ++) {
        
        Num = [self readNumWithStrings:strs Ofindex:i];
        NSLog(@"%ld",Num);
        
        
        NSString *string =[self readStrWithStrings:strs ofIndex:i inPosition:1];
        NSLog(@"%@",string);
        
        
        NSString *meaning = [self readStrWithStrings:strs ofIndex:i inPosition:2];
        NSLog(@"%@",meaning);
        
        
        NSString *statement = [self readStrWithStrings:strs ofIndex:i inPosition:3];
        NSLog(@"%@",statement);
        
        
        NSString *translate = [self readStrWithStrings:strs ofIndex:i inPosition:4];
        NSLog(@"%@",translate);
        
        
        NSString *timeStr = [self readStrWithStrings:strs ofIndex:i inPosition:5];
        NSLog(@"%@",timeStr);
        
        
        [self insertDBWithIndex:Num Word:string Meaning:meaning Statement:statement Translate:translate Timer:timeStr];
        
        NSLog(@"++++++++++++\n");
        
    }
    
}

- (NSInteger)readNumWithStrings:(NSArray *)strings Ofindex:(NSInteger)index{

    NSArray *stringArr = [strings[index] componentsSeparatedByString:@"|"];
    
    NSString *stringNum = stringArr[0];
    
    return [stringNum integerValue];
    
}

- (NSString *)readStrWithStrings:(NSArray *)strings ofIndex:(NSInteger)index inPosition:(NSInteger)position{

    NSArray *stringArr = [strings[index] componentsSeparatedByString:@"|"];
    
    NSString *stringCharacter = stringArr[position];

    return stringCharacter;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
