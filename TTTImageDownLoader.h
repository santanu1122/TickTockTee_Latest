//
//  TTTImageDownLoader.h
//  TickTockTee
//
//  Created by Iphone_2 on 22/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TTTImageDownLoader;

@protocol ImageDownloaderDelegate <NSObject>

@required

-(void)ImageDownLoadComplete:(TTTImageDownLoader *)ImageDownloader ImageData:(NSData *)ParamImageData ImageViewtag:(int)ParamImageViewTag ImageLoaderTag:(int)ParamImageLoaderTag;

@end

@interface TTTImageDownLoader : NSObject {
    __weak id <ImageDownloaderDelegate> _delegate;
}

@property (nonatomic,weak) id <ImageDownloaderDelegate> delegate;

-(void)FetchImageUrl:(NSString *)ImageUrl ImageViewtag:(int)ParamImageViewTag ImageLoaderTag:(int)ParamImageLoaderTag;

@end
