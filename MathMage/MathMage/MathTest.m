//
//  MathTest.m
//  MathMage
//
//  Created by Student on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathTest.h"

@implementation MathTest

@synthesize mathQuestions, testType;

- (id)initWithPlist:(NSString *)plistName
{
    self = [super init];
    
    self.mathQuestions = [NSMutableArray array];
    self.testType = plistName;
    
    // Load the plist file
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.mathQuestions = [NSMutableArray arrayWithArray:[tempDictionary objectForKey:@"Questions"]];
    
    // loop through array
    /*for (id question in self.mathQuestions) 
    {
        int answer = [self getAnswerToQuestion:question];
        NSLog(@"%@ = %d", question, answer);
    }*/
    
    return self;
}

- (id)initWithArray:(NSMutableArray *)questionsArray
{
    self = [super init];
    
    self.mathQuestions = [NSMutableArray array];
    self.testType = @"Custom";
    
    // Save the array of questions
    self.mathQuestions = questionsArray;
    
    // loop through array
    /*for (id question in self.mathQuestions) 
     {
     int answer = [self getAnswerToQuestion:question];
     NSLog(@"%@ = %d", question, answer);
     }*/
    
    return self;
}

- (double)getAnswerToQuestion:(NSString *)questionString
{
    NSArray *questionParts = [questionString componentsSeparatedByString:@" "];
    
    double p1 = [[questionParts objectAtIndex:0] doubleValue];
    NSString *operationType = [questionParts objectAtIndex:1];
    double p2 = [[questionParts objectAtIndex:2] doubleValue];
    
    if ([operationType isEqualToString:@"+"])
         return p1 + p2;
    else if ([operationType isEqualToString:@"-"])
        return p1 - p2;
    else if ([operationType isEqualToString:@"/"])
        return p1 / p2;
    
    return p1 * p2;
}

- (NSMutableArray *)generateAnswersToQuestion:(NSString *)questionString
{
    // Get the actual answer to the question
    double answer = [self getAnswerToQuestion:questionString];
    
    // Generate a random num between (Answer+1) and (Answer+9)
    double rNumber = (arc4random()%9)+(answer+1);
    
    NSMutableArray *answersArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:answer],[NSNumber numberWithDouble:answer+1],[NSNumber numberWithDouble:answer+10], [NSNumber numberWithDouble:rNumber], nil];
    
    return answersArray;
}

- (NSString *)getNextMathQuestion
{
    if([self.mathQuestions count] > 0)
    {
        // Get a random question from the math test
        int rNumber = (arc4random()%[self.mathQuestions count]);
                       
        NSString *mathQuestion = [self.mathQuestions objectAtIndex:rNumber];
        [self.mathQuestions removeObjectAtIndex:rNumber];
        return mathQuestion;
    }
    
    return nil;
}

@end
