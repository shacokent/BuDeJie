//
//  SKStudent.h
//  BuDeJie
//
//  Created by hongchen li on 2022/6/17.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKStudent : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) float score;
- (instancetype)init:(NSString*)name age:(int)age score:(float)score;
-(void)insertStudent;
+(void)deleteStudent:(NSString *)name;
-(void)updateStudent:(SKStudent*)newStu;
-(void)bindInsert:(NSArray<NSArray*>*)line;
@end

NS_ASSUME_NONNULL_END
