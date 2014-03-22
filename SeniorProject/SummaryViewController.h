//
//  SummaryViewController.h
//  One
//
//  Created by Skylar Peterson on 2/24/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface SummaryViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) EKEventStore *store;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *events;

@end
