//
//  CustomTableView.m
//  SquareList
//
//  Created by Skylar Peterson on 12/3/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "CustomTableView.h"

@interface CustomTableView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation CustomTableView

- (UIScrollView *)scrollView
{
    if (!_scrollView) _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    return _scrollView;
}

- (NSMutableArray *)cells
{
    if (!_cells) _cells = [[NSMutableArray alloc] init];
    return _cells;
}

- (void)setDataSource:(id<CustomTableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadView];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    self.scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

- (void)reloadView
{
    if (CGRectIsNull(self.scrollView.frame)) return;
    
    CGFloat height = 0.0;
    for (NSInteger row = 0; row < [self.dataSource numRowsForTableView]; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        height += [self.dataSource heightForRowAtIndexPath:indexPath];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, height);

    Class class = [self.dataSource classForCellType];
    CGFloat currentHeight = 0.0;
    for (NSInteger row = 0; row < [self.dataSource numRowsForTableView]; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [[class alloc] init];
        cell.frame = [self frameForCellAtIndexPath:indexPath withCurrentHeight:currentHeight];
        cell = [self.dataSource infoForCell:cell AtIndexPath:indexPath includingTitle:YES];
        [self.scrollView addSubview:cell];
        [self.cells insertObject:cell atIndex:indexPath.row];
        currentHeight += [self.dataSource heightForRowAtIndexPath:indexPath];
    }
}

- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath withCurrentHeight:(CGFloat)currentHeight
{
    return CGRectMake(0.0, currentHeight, self.bounds.size.width, [self.dataSource heightForRowAtIndexPath:indexPath]);
}

- (NSInteger)rowForCell:(UITableViewCell *)cell
{
    return [self.cells indexOfObject:cell];
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
{
    return [self.cells objectAtIndex:indexPath.row];
}

- (void)shiftCellsStartingAtRow:(NSInteger)startRow toEndRow:(NSInteger)endRow byOffset:(CGFloat)offset
{
    for (NSInteger row = startRow; row < endRow; row++) {
        UITableViewCell *cell = [self.cells objectAtIndex:row];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + offset, cell.frame.size.width, cell.frame.size.height);
    }
}

- (void)growCellAtRow:(NSInteger)startRow toHeight:(NSInteger)height
{
    UITableViewCell *expandingCell = [self.cells objectAtIndex:startRow];
    CGFloat offset = height - expandingCell.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + offset);
    [UIView transitionWithView:self
                      duration:0.35
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self shiftCellsStartingAtRow:startRow + 1 toEndRow:[self.cells count] byOffset:offset];
                        expandingCell.frame = CGRectMake(expandingCell.frame.origin.x, expandingCell.frame.origin.y, expandingCell.frame.size.width, height);
                    }
                    completion:nil];
}

- (CGFloat)heightForNewCell
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Test"
                                                                           attributes:@{ NSFontAttributeName : [self.dataSource fontForTableView] }];
    CGRect stringBounds = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width, 10000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return stringBounds.size.height + 40.0;
}

- (void)addCellAtTop
{
    Class class = [self.dataSource classForCellType];
    UITableViewCell *cell = [[class alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat height = [self heightForNewCell];
    cell.frame = CGRectMake(0.0, -height, self.bounds.size.width, height);
    cell = [self.dataSource infoForCell:cell AtIndexPath:indexPath includingTitle:NO];
    [self.scrollView addSubview:cell];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + cell.frame.size.height);
    [self.cells insertObject:cell atIndex:0];
    [UIView transitionWithView:self
                      duration:0.35
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self shiftCellsStartingAtRow:0 toEndRow:[self.cells count] byOffset:height];
                    }
                    completion:^(BOOL finished){
                        if (finished) {
                            [self.dataSource cellAdded:cell];
                        }
                    }];
}

- (void)removeCell:(UITableViewCell *)cell animated:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - cell.frame.size.height);
    if (animated) {
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cell.frame = CGRectMake(cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                         }completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.35
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  [self shiftCellsStartingAtRow:[self rowForCell:cell] toEndRow:[self.cells count] byOffset:-cell.frame.size.height];
                                              }completion:nil];
                             [cell removeFromSuperview];
                         }];
    } else {
        [self shiftCellsStartingAtRow:[self rowForCell:cell] toEndRow:[self.cells count] byOffset:-cell.frame.size.height];
        [cell removeFromSuperview];
    }
}

- (void)moveCell:(UITableViewCell *)cell toIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^)())completionBlock
{
    NSLog(@"Index: %i", index);
    UITableViewCell *cellToMoveTo = [self.cells objectAtIndex:index];
    NSInteger rowForCell = [self rowForCell:cell];
    NSLog(@"Row: %i", rowForCell);
    CGFloat offset = (rowForCell > index) ? cell.frame.size.height : -cell.frame.size.height;
    CGFloat newY = (rowForCell > index) ? cell.frame.origin.y - cellToMoveTo.frame.size.height : cellToMoveTo.frame.origin.y + offset + cellToMoveTo.frame.size.height;
    NSInteger startRowForMovingCells = (rowForCell > index) ? index : rowForCell + 1;
    NSInteger endRowForMovingCells = (rowForCell > index) ? rowForCell: index + 1;
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self shiftCellsStartingAtRow:startRowForMovingCells toEndRow:endRowForMovingCells byOffset:offset];
                             cell.frame = CGRectMake(cell.frame.origin.x, newY, cell.frame.size.width, cell.frame.size.height);
                         }
                         completion:^(BOOL completed){
                             if (completed) {
                                 completionBlock;
                             }
                         }];
    } else {
        cell.frame = CGRectMake(cell.frame.origin.x, newY, cell.frame.size.width, cell.frame.size.height);
        [self shiftCellsStartingAtRow:startRowForMovingCells toEndRow:endRowForMovingCells byOffset:offset];
        completionBlock;
    }
    [self.cells removeObject:cell];
    [self.cells insertObject:cell atIndex:index];
}

- (UITableViewCell *)cellWithMiddleOverlappingAboveCell:(UITableViewCell *)cell {
    NSInteger cellRow = [self rowForCell:cell];
    if (cellRow != 0) {
        UITableViewCell *precedingCell = [self cellForIndexPath:[NSIndexPath indexPathForRow:cellRow - 1 inSection:0]];
        if (cell.frame.origin.y <= precedingCell.frame.origin.y + precedingCell.frame.size.height/2.0) return precedingCell;
    }
    return nil;
}

- (UITableViewCell *)cellWithMiddleOverlappingBelowCell:(UITableViewCell *)cell {
    NSInteger cellRow = [self rowForCell:cell];
    if (cellRow != [self.cells count] - 1) {
        UITableViewCell *nextCell = [self cellForIndexPath:[NSIndexPath indexPathForRow:cellRow + 1 inSection:0]];
        if (cell.frame.origin.y + cell.frame.size.height >= nextCell.frame.origin.y + nextCell.frame.size.height/2.0) return nextCell;
    }
    return nil;
}

//- (UITableViewCell *)cellWithMiddleOverlappingCell:(UITableViewCell *)cell
//{
//    NSInteger cellRow = [self rowForCell:cell];
//    UITableViewCell *precedingCell = [self cellForIndexPath:[NSIndexPath indexPathForRow:cellRow - 1 inSection:0]];
//    if (cell.frame.origin.y == precedingCell.frame.origin.y + precedingCell.frame.size.height/2.0) return precedingCell;
//    UITableViewCell *nextCell = [self cellForIndexPath:[NSIndexPath indexPathForRow:cellRow + 1 inSection:0]];
//    if (cell.frame.origin.y + cell.frame.size.height == nextCell.frame.origin.y + nextCell.frame.size.height/2.0) return nextCell;
//    return nil;
//}

@end
