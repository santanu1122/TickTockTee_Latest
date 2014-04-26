//
//  TTTHandleURLConnection.h
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTHandleURLConnection;

@protocol TTTHandleURLConnectionDelegate <NSObject>

@required

- (void)HnadleNsUrlConnection:(TTTHandleURLConnection *)myObj json:(NSDictionary *)json;
- (void)HnadleNsUrlConnectionErr:(TTTHandleURLConnection *)myObj Errdata:(NSError *)Errdata;

@end

@interface TTTHandleURLConnection : NSObject {
    __weak id<TTTHandleURLConnectionDelegate> _delegate;
}
@property (nonatomic, weak) id <TTTHandleURLConnectionDelegate> delegate;

- (void)CallExternalUrl:(NSString *)url;
- (void)getValuFromURLWithPost:(NSString *)ParamDictionary URLFOR:(NSString *)URLFOR;

@end
