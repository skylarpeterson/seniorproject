//
//  NoEventsView.h
//  One
//
//  Created by Skylar Peterson on 3/16/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoEventsDelegate <NSObject>

@required
- (void)noEventButtonPressed;

@end

@interface NoEventsView : UIView

#define IMAGE_VIEW_SIZE 150.0
@property (nonatomic, strong) id<NoEventsDelegate> delegate;

@end
