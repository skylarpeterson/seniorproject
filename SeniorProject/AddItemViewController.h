//
//  AddItemViewController.h
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"
#import "AddView.h"

@interface AddItemViewController : UIViewController

@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) NSArray *calendars;

@end
