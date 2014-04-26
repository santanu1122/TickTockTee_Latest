//
//  TTTHandleURLConnection.m
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTHandleURLConnection.h"
#import "AFNetworking.h"

@implementation TTTHandleURLConnection

@synthesize delegate = _delegate;

- (void)jobCompleted:(id)json {
    
    IMFAPPPRINTMETHOD();
    
    NSError *error;
    NSDictionary* jsonData  = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
    [_delegate HnadleNsUrlConnection:self json:(NSDictionary *)jsonData];
    
}

-(void)getErrorToaccesssData:(NSError *)Errdata {
    
    IMFAPPPRINTMETHOD();
    
    [_delegate HnadleNsUrlConnectionErr:self Errdata:(NSError *)Errdata];
}
- (void)getValuFromURLWithPost:(NSString *)ParamDictionary URLFOR:(NSString *)URLFOR {
    
    IMFAPPPRINTMETHOD();
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Pulling", NULL);
    
    dispatch_async(fetchQ, ^{
        
        NSArray *myParametersone = [ParamDictionary componentsSeparatedByString:[NSString stringWithFormat:@"%@?",URLFOR]];
        NSString *myParameters = [myParametersone objectAtIndex:1];
        NSURL *url = [NSURL URLWithString:URLFOR];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [myParameters dataUsingEncoding: NSASCIIStringEncoding];
        [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse *r, NSData *data, NSError *error) {
             if (error) {
                 [self getErrorToaccesssData:error];
             } else {
                 [self jobCompleted:data];
             }
         }];
    });
    
}
- (void)CallExternalUrl:(NSString *)url {
    
    IMFAPPPRINTMETHOD();
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Pulling", NULL);
    
    dispatch_async(fetchQ, ^{
        
        NSURLRequest *RequestedURL = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        AFHTTPRequestOperation *operation_login = [[AFHTTPRequestOperation alloc]initWithRequest:RequestedURL];
        
        [operation_login setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self jobCompleted:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self getErrorToaccesssData:error];
            
        }];
        [operation_login start];
        
    });
    
}

@end
