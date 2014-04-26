//
//  TTTImageDownLoader.m
//  TickTockTee
//
//  Created by Iphone_2 on 22/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTImageDownLoader.h"
#import "AFImageRequestOperation.h"


@implementation TTTImageDownLoader

@synthesize delegate        = _delegate;

-(void)FetchImageUrl:(NSString *)ImageUrl ImageViewtag:(int)ParamImageViewTag ImageLoaderTag:(int)ParamImageLoaderTag {
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Downloading Image Data", NULL);
    
    dispatch_async(fetchQ, ^{
        
        NSData *dataURL =  [NSData dataWithContentsOfURL: [NSURL URLWithString: ImageUrl]];
       
        [self ImageDownloadComplete:dataURL ImageViewtag:ParamImageViewTag ImageLoaderTag:ParamImageLoaderTag];
        
    });
    
}

-(void)ImageDownloadComplete:(NSData *)ImageRawData ImageViewtag:(int)ParamImageViewTag ImageLoaderTag:(int)ParamImageLoaderTag {
    
    [_delegate ImageDownLoadComplete:self ImageData:ImageRawData ImageViewtag:ParamImageViewTag ImageLoaderTag:ParamImageLoaderTag];
 
}
@end
