//
//  TTTWebVideoViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 15/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTWebVideoViewController.h"

@interface TTTWebVideoViewController ()<UIWebViewDelegate>{
UIWebView *webView;
UIActivityIndicatorView  *activityIndicator;
}
@end

@implementation TTTWebVideoViewController
@synthesize videoURL;

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
    // Do any additional setup after loading the view from its nib.
    [self viewMyVideos];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewMyVideos{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]]];
    webView.delegate=self;
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    CGPoint Center=webView.center;
   
    activityIndicator.center=CGPointMake( Center.x,Center.y-80);;
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [webView addSubview:activityIndicator];
    [self.view addSubview:webView];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    // myLabel.hidden = FALSE;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidesWhenStopped=TRUE;
    //myLabel.hidden = TRUE;
}
- (IBAction)backClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
