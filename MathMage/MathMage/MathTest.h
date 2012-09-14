//
//  MathTest.h
//  MathMage
//
//  Created by Student on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathTest : NSObject

@property(nonatomic,strong)NSString *testType;
@property(nonatomic,strong)NSMutableArray *mathQuestions;

- (id)initWithPlist:(NSString *)plistName;
- (id)initWithArray:(NSMutableArray *)questionsArray;
- (double)getAnswerToQuestion:(NSString *)questionString;
- (NSMutableArray *)generateAnswersToQuestion:(NSString *)questionString;
- (NSString *)getNextMathQuestion;

@end
