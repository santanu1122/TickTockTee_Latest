//
//  TTTGlobalConnectionStrings.h
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

// These are for the dispatch_async() calls that you use to get around the synchronous-ness

#define GCDBackgroundThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDMainThread dispatch_get_main_queue()

// URL path

static NSString * const API_MAINDOMAIN = @"";

// Parameters for url call

// Task

// url call returned parameter
