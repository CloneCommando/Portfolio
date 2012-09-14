//
//  CustomTestData.m
//  MathMage
//
//  Created by Student on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTestData.h"

static CustomTestData *sharedInstance = nil;

@implementation CustomTestData

+ (CustomTestData*)sharedInstance
{
    if(!sharedInstance)
    {
        // Create the singleton
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id) init
{
    if (sharedInstance)
    {
        return sharedInstance;
    }
    
    self = [super init];
    
    if (self)
    {
        // Initalize data
        // Find the path to the plist
        NSError *error;
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:@"CustomTestData.plist"];
        
        fileManager = [NSFileManager defaultManager];
        
        // If it has not been copied to the documents directory, then copy it over so it can be edited
        if(![fileManager fileExistsAtPath:path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"CustomTestData" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath:path error:&error];
            NSLog(@"Copying Over CustomTestData.plist to Documents Directory");
            
            if (error)
            {
                NSLog(@"Error: %@", error);
            }
            
            customTestData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
        }
    }
    
    return self;
}

- (NSMutableArray *)getCustomTestQuestionArray: (NSString *)customTestName
{
    // Make sure we have up to date data before we do anything
    customTestData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *customTestsDict = [customTestData objectForKey:@"CustomTests"];
    
    NSMutableArray *questionsArray = [customTestsDict objectForKey:customTestName];
    customTestData = nil;
    
    return questionsArray;
}

- (NSMutableArray *)getListOfCustomTestsCreated
{
    customTestData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *customTestsDict = [customTestData objectForKey:@"CustomTests"];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    // Get all the keys from the data, which are the names of custom tests that have been created
    for(NSString *key in customTestsDict)
    {
        [tempArray addObject:key];
    }
    
    customTestData = nil;
    return tempArray;
}

- (BOOL)customTestNameAlreadyExists: (NSString *) newTestName
{
    customTestData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *customTestsDict = [customTestData objectForKey:@"CustomTests"];
    
    // Get all the keys from the data, which are the names of custom tests that have been created
    for(NSString *key in customTestsDict)
    {
        if ([key isEqualToString:newTestName])
        {
            customTestData = nil;
            return YES;
        }
    }
    
    customTestData = nil;
    return NO;
}

- (void) saveNewCustomTest: (NSString *)testName questionsArray: (NSMutableArray *) questionsArray
{
    // Make sure we have up to date data before we do anything
    customTestData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Grab the entire dictionary filled will all the custom tests
    NSMutableDictionary *customTestsDict = [customTestData objectForKey:@"CustomTests"];
    
    // Put the array of questions inside that dictionary, using the name of the test as a key
    [customTestsDict setObject:questionsArray forKey:testName];
    [customTestData setObject:customTestsDict forKey:@"CustomTests"];
    [customTestData writeToFile:path atomically:YES];
    
    customTestData = nil;
}

@end
