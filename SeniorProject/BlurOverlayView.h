//
//  BlurOverlayView.h
//  One
//
//  Created by Skylar Peterson on 3/18/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "FXBlurView.h"

@interface BlurOverlayView : FXBlurView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIColor *textColor;

- (void)initialize;

@end
