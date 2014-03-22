//
//  SingleListCell.h
//  SquareList
//
//  Created by Skylar Peterson on 11/18/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol SingleListCellDelegate <NSObject>

@optional
- (void)textViewDidBeginEditingForCell:(UITableViewCell *)cell;
- (void)textViewDidEndEditingForCell:(UITableViewCell *)cell;
- (void)textViewDidGrowVertically:(UITableViewCell *)cell toHeight:(CGFloat)height;
- (void)editedTextChanged:(UITableViewCell *)cell;
- (void)editedTextIsBlank:(UITableViewCell *)cell;
- (BOOL)shouldChangeItemCompletion;
- (void)changeItemCompletion:(UITableViewCell *)cell toBOOL:(BOOL)completed;
- (void)showPhotosForCell:(UITableViewCell *)cell;
- (void)deleteItemForCell:(UITableViewCell *)cell;
- (void)cellMoved:(UITableViewCell *)cell;

@end

@interface SingleListCell : UITableViewCell

#define LIST_COMPLETION_VIEW_SIZE 55.0
#define IMAGE_BUTTON_SIZE 55.0

@property (nonatomic, strong) ListItem *listItem;
@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backdropColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) id<SingleListCellDelegate> delegate;

+ (CGSize)sizeForTextViewWithText:(NSAttributedString *)text inCellWidth:(CGFloat)width;
- (void)cellJustAdded;
- (void)shiftCellBorderByOffset:(CGFloat)offset;

@end
