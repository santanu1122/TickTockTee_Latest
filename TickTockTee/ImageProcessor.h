//
//  ImageProcessor.h
//  Crusher2
//
//  Created by Iphone_2 on 18/06/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

@interface ImageProcessor : UIViewController
{
    @private NSOperationQueue *OperationQueueForImageDownloading;
}

-(void)LoadImage :(NSArray *)Param;
-(void)downloadImageWithSavingimagedata:(NSArray *)param;//0.ImageView 1.Url 2.SpinnerTag 3.Ratio

-(void)CancelImageDownloading;

@end

