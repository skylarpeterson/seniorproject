//
//  CustomTableView.h
//  SquareList
//
//  Created by Skylar Peterson on 12/3/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//


/*
 * IMPORTANT:
 * The foundation for this class was gathered from an online tutorial at the following link, then adapted to the needs of my app:
 * http://www.raywenderlich.com/21952/how-to-make-a-gesture-driven-to-do-list-app-part-23
 * The methods for transforming the table view are entirely my own
 */

#import <UIKit/UIKit.h>

@protocol CustomTableViewDataSource <NSObject>

@required
- (Class)classForCellType;
- (UIFont *)fontForTableView;
- (NSInteger)numRowsForTableView;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)infoForCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath includingTitle:(BOOL)titleIncluded;

@optional
- (void)cellAdded:(UITableViewCell *)cell;

@end

@interface CustomTableView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id<CustomTableViewDataSource> dataSource;

- (NSInteger)rowForCell:(UITableViewCell *)cell;
- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath;
- (void)growCellAtRow:(NSInteger)row toHeight:(NSInteger)height;
- (void)addCellAtTop;
- (void)removeCell:(UITableViewCell *)cell animated:(BOOL)animated;
- (void)moveCell:(UITableViewCell *)cell toIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^)())completionBlock;
- (void)shiftCellsStartingAtRow:(NSInteger)startRow toEndRow:(NSInteger)endRow byOffset:(CGFloat)offset;
- (UITableViewCell *)cellWithMiddleOverlappingAboveCell:(UITableViewCell *)cell;
- (UITableViewCell *)cellWithMiddleOverlappingBelowCell:(UITableViewCell *)cell;
//- (UITableViewCell *)cellWithMiddleOverlappingCell:(UITableViewCell *)cell;

@end
