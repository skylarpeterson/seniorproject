//
//  ListViewController.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/2/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *calendars;

@end
