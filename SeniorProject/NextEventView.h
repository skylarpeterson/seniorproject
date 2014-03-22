//
//  NextEventView.h
//  One
//
//  Created by Skylar Peterson on 2/24/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface NextEventView : UIView

@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) NSString *comingUpText;

@end
