//
//  AddNewCell.h
//  One
//
//  Created by Skylar Peterson on 3/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol AddCellDelegate <NSObject>

@required
- (void)addButtonPressedForCell:(UITableViewCell *)cell;

@end

@interface AddNewCell : UITableViewCell

@property (nonatomic, strong) id<AddCellDelegate>delegate;
@property (nonatomic, strong) ListItem *listItem;

@end
