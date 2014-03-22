//
//  PageContentViewController.h
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "NextEventView.h"

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet NextEventView *eventView;
@property (nonatomic) NSInteger pageIndex;
@property EKEvent *event;
@property NSString *comingUpText;

@end
