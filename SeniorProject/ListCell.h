//
//  ListCell.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/3/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListCellDelegate <NSObject>

@required
- (void)cellCompleted:(UITableViewCell *)cell;
- (void)cellDeleted:(UITableViewCell *)cell;

@end

@interface ListCell : UITableViewCell

#define CELL_SPACING_SIZE 1.5
@property (nonatomic, strong) id<ListCellDelegate> delegate;
@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic) BOOL canComplete;

+ (CGSize)sizeForTextViewWithText:(NSAttributedString *)text inCellWidth:(CGFloat)width;

@end
