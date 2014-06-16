//
//  DCCommutator.m
//  Declarations
//
//  Created by tanlan on 5/20/14.
//  Copyright (c) 2014 Chesno. All rights reserved.
//

#import "DCDataLoader.h"
#import "DCPerson.h"

@interface DCDataLoader ()

@property (strong) NSURLSession *session;
@property (strong) NSURL *chesnoLink;

@end

static NSString *const DCChesnoLink = @"http://chesno.org/persons/json";

@implementation DCDataLoader

- (instancetype)init
{
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<DCDataLoaderDelegate>)delegate
{
    self = [super init];
    
    if (self != nil)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:configuration];
        _chesnoLink = [NSURL URLWithString:DCChesnoLink];
        
        _delegate = delegate;
    }
    
    return self;
}

#pragma mark -

- (NSArray *)loadPersons
{
    NSMutableArray *loadedPersons = [NSMutableArray array];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.chesnoLink];
    // setup request for all persons here
    
    __block id jsonResponse = nil;
    
    NSURLSessionDataTask *allPersonsTask = [self.session dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error == nil && data != nil)
        {
            NSError *parsingJSONError;
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&parsingJSONError];
            if (parsingJSONError != nil)
            {
                NSLog(@"Error parsing json server responce %@", parsingJSONError);
            }
        }
        else
        {
            NSLog(@"Error performing request %@", error);
        }
    }];
    
    [allPersonsTask resume];
    
    while (allPersonsTask != nil &&
           allPersonsTask.state == NSURLSessionTaskStateRunning)
    {
        [NSThread sleepForTimeInterval:0.2];
    }
    
    if ([jsonResponse isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *personJSONObject in jsonResponse)
        {
            DCPerson *newPerson = [[DCPerson alloc] initWithJSONObject:personJSONObject];
            if (newPerson != nil)
            {
                [loadedPersons addObject:newPerson];
            }
        }
    }
    
    return loadedPersons;
}

- (void)loadDataForPerson:(DCPerson *)person completionHandler:(void (^)(BOOL success))block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chesno.org/person/json/declarations_for/1870/"]];
                             //[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"declaration_example" ofType:@"dat"]]];
    
    // setup request for defined person
    NSURLSessionDataTask *personInfoTask = [self.session dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error == nil && data != nil)
        {
            NSError *parsingJSONError;
            NSArray *jsonResponce = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&parsingJSONError];
            
            if (jsonResponce != nil && jsonResponce.count)
            {
                // just demo depends on future json structure
                NSDictionary *declarationInfo = jsonResponce[0];
                DCDeclaration *newDeclaration = [[DCDeclaration alloc] initWithJSONObject:declarationInfo];
                [person addDeclaration:newDeclaration];
                
                [self.delegate dataLoader:self didFinishLoadingPerson:person];
                block(YES);
            }
            else
            {
                [self.delegate dataLoader:self didFailedLoadingPerson:person];
                block(NO);
            }
        }
        else
        {
            [self.delegate dataLoader:self didFailedLoadingPerson:person];
            block(NO);
        }
    }];
    
    [personInfoTask resume];
}

@end
