//
//  CustomTestData.h
//  MathMage
//
//  Created by Student on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTestData : NSObject
{
    NSArray *paths;
    NSString *documentsDirectory;
    NSString *path;
    NSFileManager *fileManager;
    NSMutableDictionary *customTestData;
}

+ (CustomTestData *)sharedInstance;

- (NSMutableArray *)getCustomTestQuestionArray: (NSString *)customTestName;
- (NSMutableArray *)getListOfCustomTestsCreated;
- (BOOL)customTestNameAlreadyExists: (NSString *) newTestName;
- (void) saveNewCustomTest: (NSString *)testName questionsArray: (NSMutableArray *) questionsArray;

@end
