//
//  ListCellDisclosure.h
//  One
//
//  Created by Skylar Peterson on 3/6/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"

@protocol ListCellDisclosureDelegate <NSObject>

@required
- (void)listCellDisclosed:(UITableViewCell *)cell;
- (void)listCellClosed:(UITableViewCell *)cell;

@end

@interface ListCellDisclosure : ListCell

@property (nonatomic, strong) id<ListCellDisclosureDelegate>disclosureDelegate;
@property (nonatomic) BOOL disclosed;

@end
