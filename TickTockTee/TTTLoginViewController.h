//
//  TTTLoginViewController.h
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"


@interface TTTLoginViewController :TTTGlobalViewController<UITextFieldDelegate>
@property(nonatomic, retain) NSString *FBAccessToken;

@end
