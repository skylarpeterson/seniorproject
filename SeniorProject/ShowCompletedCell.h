//
//  ShowCompletedCell.h
//  One
//
//  Created by Skylar Peterson on 3/12/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol ShowCellDelegate <NSObject>

@required
- (void)showCompletedTapped:(UITableViewCell *)cell;
- (void)hideCompletedTapped:(UITableViewCell *)cell;

@end

@interface ShowCompletedCell : UITableViewCell

@property (nonatomic, strong) ListItem *listItem;
@property (nonatomic, strong) id<ShowCellDelegate> delegate;
@property (nonatomic) BOOL showButton;

@end
