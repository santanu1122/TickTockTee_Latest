//
//  ImageProcessor.m
//  Crusher2
//
//  Created by Iphone_2 on 18/06/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageProcessor ()

@end

@implementation ImageProcessor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    OperationQueueForImageDownloading = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)LoadImage:(NSArray *)Param
{
    NSInvocationOperation *LocalOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(DownloadImage:) object:Param];
    [OperationQueueForImageDownloading addOperation:LocalOperation];    
}

-(void)LoadPoster:(NSArray *)Param
{
    NSInvocationOperation *LocalOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector( :) object:Param];
    [OperationQueueForImageDownloading addOperation:LocalOperation];
}

//Thread Segment

-(void)downloadImageWithSavingimagedata:(NSArray *)param
{
    NSInvocationOperation *LocalOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(DownloadimageAndstoreitindictionary:) object:param];
    [OperationQueueForImageDownloading addOperation:LocalOperation];
}

-(void)DownloadimageAndstoreitindictionary:(NSArray *)Array
{
    @try
    {
        UIImage *friendImage;
        NSData *data=[NSData dataWithContentsOfURL:[Array objectAtIndex:1]];
        
        friendImage=[UIImage imageWithData:data];
        [[Array objectAtIndex:4] setObject:data forKey:[Array objectAtIndex:5]];
        UIActivityIndicatorView *SpinnerView=(UIActivityIndicatorView *)[[[Array objectAtIndex:0] superview] viewWithTag:[[Array objectAtIndex:2] integerValue]];
        [SpinnerView startAnimating];
        [SpinnerView setHidden:NO];
        
        NSArray *ObjectCarrier=[[NSArray alloc] initWithObjects:[Array objectAtIndex:0] ,friendImage, [Array objectAtIndex:2],[Array objectAtIndex:3], nil];
        [self performSelectorOnMainThread:@selector(ReturnToMainThredDone:) withObject:ObjectCarrier waitUntilDone:YES];
    }
    @catch (NSException *me)
    {
        NSLog(@"The exception is:%@",me);
    }
}

-(void)ReturnToMainThredDone:(NSArray *)Param
{
    @try
    {
        UIImageView *friendImage=(UIImageView *)[Param objectAtIndex:0];
        [friendImage setImage:(UIImage *)[Param objectAtIndex:1]];
        NSString *ContentMode=[Param objectAtIndex:3];
        if([ContentMode isEqualToString:@"Fill"])
            [friendImage setContentMode:UIViewContentModeScaleToFill];
        else if([ContentMode isEqualToString:@"AspectFill"])
            [friendImage setContentMode:UIViewContentModeScaleAspectFill];
        else
            [friendImage setContentMode:UIViewContentModeScaleAspectFit];
        
        UIActivityIndicatorView *SpinnerView=(UIActivityIndicatorView *)[[friendImage superview] viewWithTag:[[Param objectAtIndex:2] integerValue]];
        [SpinnerView stopAnimating];
        [SpinnerView setHidden:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"juju:: %@", juju);
    }
}

-(void)DownloadImage:(NSArray *)Param  //0.ImageView 1.Url 2.SpinnerTag 3.Ratio
{
    @try
    {
        UIImage *friendImage;
        NSLog(@"This is my image:");
        friendImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[Param objectAtIndex:1]]];
        
        UIActivityIndicatorView *SpinnerView=(UIActivityIndicatorView *)[[[Param objectAtIndex:0] superview] viewWithTag:[[Param objectAtIndex:2] integerValue]];
        [SpinnerView startAnimating];
        [SpinnerView setHidden:NO];
        
        NSArray *ObjectCarrier=[[NSArray alloc] initWithObjects:[Param objectAtIndex:0] ,friendImage, [Param objectAtIndex:2],[Param objectAtIndex:[Param count]-1], nil];
        [self performSelectorOnMainThread:@selector(ReturnToMainThredWhenDone:) withObject:ObjectCarrier waitUntilDone:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", Param);
        NSLog(@"Reporting JUJU From ImageDownloader:: %@", juju);
    }
}

-(void)ReturnToMainThredWhenDone:(NSArray *)Param //0.ImageView 1.Url 2.SpinnerTag 3.Ratio
{
    @try
    {
        UIImageView *friendImage=(UIImageView *)[Param objectAtIndex:0];
        [friendImage setImage:(UIImage *)[Param objectAtIndex:1]];
        NSString *ContentMode=[Param objectAtIndex:[Param count]-1];
        NSLog(@"Set image to the image view:");
        if([ContentMode isEqualToString:@"Fill"])
            [friendImage setContentMode:UIViewContentModeScaleToFill];
        else if([ContentMode isEqualToString:@"AspectFill"])
            [friendImage setContentMode:UIViewContentModeScaleAspectFill];
        else
            [friendImage setContentMode:UIViewContentModeScaleAspectFit];
        
        UIActivityIndicatorView *SpinnerView=(UIActivityIndicatorView *)[[friendImage superview] viewWithTag:[[Param objectAtIndex:2] integerValue]];
        [SpinnerView stopAnimating];
        [SpinnerView setHidden:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"juju:: %@", juju);
    }
}

-(void)CancelImageDownloading
{
    [OperationQueueForImageDownloading cancelAllOperations];
}

@end

