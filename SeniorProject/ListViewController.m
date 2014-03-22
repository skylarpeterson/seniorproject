//
//  ListViewController.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/2/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "ListCellDisclosure.h"
#import "AddNewCell.h"
#import "ShowCompletedCell.h"
#import "OptionsView.h"
#import "NewTaskView.h"
#import "FXBlurView.h"
#import "AddItemViewController.h"
#import "SummaryViewController.h"

#import <CoreData/CoreData.h>
#import "Availabilities.h"
#import "ListItem.h"
#import "ListItem+Children.h"

#import "Fonts.h"
#import "Colors.h"
#import "CalInfo.h"
#import "Methods.h"

@interface ListViewController () <OptionsViewDelegate, UITableViewDataSource, UITableViewDelegate, ListCellDelegate, ListCellDisclosureDelegate, AddCellDelegate, ShowCellDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet OptionsView *optionsView;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSMutableArray *listItems;
@property (nonatomic, strong) NSMutableArray *disclosedBools;
@property (nonatomic, strong) NSMutableDictionary *listItemsForIndexPaths;

@property (nonatomic) BOOL presenting;

@end

@implementation ListViewController

#define CELL_IDENTIFIER @"ListCell"
#define CELL_IDENTIFIER_DISCLOSURE @"ListCellDisclosure"
#define CELL_IDENTIFIER_ADD @"ListCellAdd"
#define CELL_IDENTIFIER_SHOW @"ListCellShow"
#define ADD_TASK_SEGUE_IDENTIFIER @"AddTask"

#pragma mark - Getters

- (NSMutableArray *)disclosedBools
{
    if (!_disclosedBools) _disclosedBools = [[NSMutableArray alloc] init];
    return _disclosedBools;
}

- (NSMutableDictionary *)listItemsForIndexPaths
{
    if (!_listItemsForIndexPaths) _listItemsForIndexPaths = [[NSMutableDictionary alloc] init];
    return _listItemsForIndexPaths;
}

#pragma mark - Setters

- (void)setDocument:(UIManagedDocument *)document
{
    _document = document;
    [self makeRequestWithOption:1];
    [self.tableView reloadData];
}

#pragma mark - Request Methods

- (NSArray *)makeRequestWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)descriptors
{
    NSManagedObjectContext *moc = [self.document managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    request.predicate = predicate;
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    return [moc executeFetchRequest:request error:&error];
}

- (void)makeRequestWithOption:(NSInteger)option
{
    NSPredicate *predicate;
    if (option == 0) predicate = [NSPredicate predicateWithFormat:@"(completed == NO) AND (parent == nil)"];
    else if (option == 1) predicate = [NSPredicate predicateWithFormat:@"(dateToSee <= %@) AND (completed == NO) AND (parent == nil)", self.date];
    else if (option == 2) predicate = [NSPredicate predicateWithFormat:@"(dateToSee <= %@) AND (completed == NO) AND (parent == nil)", self.date];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateDue" ascending:YES];
    NSArray *array = [self makeRequestWithPredicate:predicate andSortDescriptors:@[sortDescriptor]];
    
    self.listItems = [array mutableCopy];
    [self.listItems addObject:@"Show"];
    for (int i = 0; i < [self.listItems count]; i++) {
        [self.disclosedBools addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)queryForChildrenOfListItem:(ListItem *)listItem
{
    NSPredicate *predicate;
    if (self.optionsView.selectedIndex == 0) predicate = [NSPredicate predicateWithFormat:@"(completed == NO) AND (parent == %@)", listItem];
    else if (self.optionsView.selectedIndex == 1) predicate = [NSPredicate predicateWithFormat:@"(completed == NO) AND (parent == %@) AND (dateToSee <= %@)", listItem, self.date];
    else if (self.optionsView.selectedIndex == 2) predicate = [NSPredicate predicateWithFormat:@"(completed == NO) AND (parent == %@)AND (dateToSee <= %@)", listItem, self.date];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateDue" ascending:YES];
    NSArray *array = [self makeRequestWithPredicate:predicate andSortDescriptors:@[sortDescriptor]];
    
    NSInteger indexOfItem = [self.listItems indexOfObject:listItem];
    [self.disclosedBools replaceObjectAtIndex:indexOfItem withObject:[NSNumber numberWithBool:YES]];
    
    [self.listItems insertObject:@"Add" atIndex:indexOfItem + 1];
    [self.disclosedBools insertObject:[NSNumber numberWithBool:NO] atIndex:indexOfItem + 1];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:[NSIndexPath indexPathForRow:indexOfItem + 1 inSection:0]];
    if ([array count] > 0) {
        [self.listItems insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfItem + 2, [array count])]];
        for (NSInteger i = indexOfItem + 2; i < indexOfItem + 2 + [array count]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            [self.disclosedBools insertObject:[NSNumber numberWithBool:NO] atIndex:i];
        }
    }
    [self.listItems insertObject:([listItem.children count] != listItem.numIncompleteChildren.intValue) ? @"Show" : @"ShowNone" atIndex:indexOfItem + 2 + [array count]];
    [self.disclosedBools insertObject:[NSNumber numberWithBool:NO] atIndex:indexOfItem + 2 + [array count]];
    [indexPaths addObject:[NSIndexPath indexPathForRow:indexOfItem + 2 + [array count] inSection:0]];
    [self.listItemsForIndexPaths setObject:listItem forKey:[indexPaths lastObject]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

- (void)gatherCompletedItemsForListItem:(ListItem *)listItem atIndex:(NSInteger)index
{
    NSPredicate *predicate;
    if (self.optionsView.selectedIndex == 0) predicate = [NSPredicate predicateWithFormat:@"(parent == %@) AND (completed == YES)", listItem];
    else if (self.optionsView.selectedIndex == 1) predicate = [NSPredicate predicateWithFormat:@"(completed == YES) AND (parent == %@) AND (dateToSee <= %@)", listItem, self.date];
    else if (self.optionsView.selectedIndex == 2) predicate = [NSPredicate predicateWithFormat:@"(completed == YES) AND (parent == %@) AND (dateToSee <= %@)", listItem, self.date];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateDue" ascending:YES];
    NSArray *array = [self makeRequestWithPredicate:predicate andSortDescriptors:@[sortDescriptor]];
    
    [self.listItems insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [array count])]];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSInteger i = index; i < index + [array count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.disclosedBools insertObject:[NSNumber numberWithBool:NO] atIndex:i];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - View Loading Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
    self.dateLabel.textColor = [Colors lightestGrayColor];
    self.dateLabel.font = [Fonts titleFont];
    //[self.addButton setBackgroundImage:[[UIImage imageNamed:@"AddIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.options = @[@"All", self.dateLabel.text];
    self.optionsView.delegate = self;
    self.optionsView.options = self.options;
    self.optionsView.textColor = [Colors lightestGrayColor];
    self.optionsView.unselectedColor = [Colors mainGrayColor];
    self.optionsView.backgroundColor = [Colors secondarGrayColor];
    self.optionsView.selectedIndex = 1;
    
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[ListCellDisclosure class] forCellReuseIdentifier:CELL_IDENTIFIER_DISCLOSURE];
    [self.tableView registerClass:[AddNewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_ADD];
    [self.tableView registerClass:[ShowCompletedCell class] forCellReuseIdentifier:CELL_IDENTIFIER_SHOW];
    self.tableView.backgroundColor = [Colors secondarGrayColor];
    self.tableView.separatorColor = [Colors secondarGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.listItems objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        return 60.0;
    } else {
        ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
        CGSize size = [Methods sizeForText:listItem.contents withWidth:self.tableView.frame.size.width andFont:[Fonts listItemFont]];
        return size.height + 50.0;
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.listItems objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        if ([[self.listItems objectAtIndex:indexPath.row] isEqualToString:@"Add"]) {
            ListItem *listItem = [self.listItems objectAtIndex:indexPath.row - 1];
            AddNewCell *addCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ADD forIndexPath:indexPath];
            addCell.selectionStyle = UITableViewCellSelectionStyleNone;
            addCell.delegate = self;
            addCell.listItem = listItem;
            addCell.backgroundColor = [UIColor clearColor];
            return addCell;
        } else if ([[self.listItems objectAtIndex:indexPath.row] isEqualToString:@"Show"] || [[self.listItems objectAtIndex:indexPath.row] isEqualToString:@"ShowNone"]) {
            ListItem *listItem = [self.listItemsForIndexPaths objectForKey:indexPath];
            ShowCompletedCell *showCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_SHOW forIndexPath:indexPath];
            showCell.selectionStyle = UITableViewCellSelectionStyleNone;
            showCell.delegate = self;
            showCell.listItem = listItem;
            if ([[self.listItems objectAtIndex:indexPath.row] isEqualToString:@"ShowNone"]) showCell.showButton = NO;
            else showCell.showButton = YES;
            showCell.backgroundColor = [UIColor clearColor];
            return showCell;
        }
    } else {
        ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
        if (!listItem.isMulti.boolValue) {
            ListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
            cell.backgroundColor = [Colors mainGrayColor];
            cell.delegate = self;
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:listItem.contents
                                                                                 attributes:@{ NSFontAttributeName : [Fonts listItemFont]}];
            cell.text = attributedText;
            if (listItem.completed.boolValue) {
                cell.backgroundColor = [Colors completedGrayColor];
                cell.canComplete = NO;
            } else {
                cell.canComplete = YES;
            }
            return cell;
        } else {
            ListCellDisclosure *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DISCLOSURE forIndexPath:indexPath];
            cell.backgroundColor = [Colors mainGrayColor];
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:listItem.contents
                                                                                 attributes:@{ NSFontAttributeName : [Fonts listItemFont]}];
            cell.delegate = self;
            cell.disclosureDelegate = self;
            cell.text = attributedText;
            cell.disclosed = ((NSNumber *)[self.disclosedBools objectAtIndex:indexPath.row]).boolValue;
            if (listItem.completed.boolValue) {
                cell.backgroundColor = [Colors completedGrayColor];
                cell.canComplete = NO;
            } else {
                cell.canComplete = YES;
            }
            return cell;
        }
    }
    return nil;
}

#pragma mark - Button Actions

#define ADD_VIEW_INSET 5.0
- (IBAction)addItem:(id)sender
{
    [self initiateAddingToListItem:nil];
}

- (void)initiateAddingToListItem:(ListItem *)listItem
{
    [self performSegueWithIdentifier:ADD_TASK_SEGUE_IDENTIFIER sender:listItem];
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:ADD_TASK_SEGUE_IDENTIFIER]) {
        if ([segue.destinationViewController isKindOfClass:[AddItemViewController class]]) {
            AddItemViewController *addController = (AddItemViewController *)segue.destinationViewController;
            addController.addView = [[NewTaskView alloc] init];
            ((NewTaskView *)addController.addView).listItem = (ListItem *)sender;
            addController.calendars = self.calendars;
            addController.transitioningDelegate = self;
            addController.modalPresentationStyle = UIModalPresentationCustom;
        }
    }
}

#pragma mark - Transitioning Delegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

#pragma mark - Animated Transitioning Protocol Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.y += self.view.frame.size.height;
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                             toViewController.view.frame = endFrame;
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame.origin.y += self.view.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                             fromViewController.view.frame = endFrame;
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    }
}

#pragma mark - Unwind Methods

- (IBAction)itemAdded:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[AddItemViewController class]]) {
        AddItemViewController *addController = (AddItemViewController *)segue.sourceViewController;
        if ([addController.addView isKindOfClass:[NewTaskView class]]) {
            NewTaskView *taskView = (NewTaskView *)addController.addView;
            ListItem *listItem = [self addNewItemWithTaskView:taskView];
            NSIndexPath *indexPath;
            if (taskView.listItem) {
                [taskView.listItem addChildrenObject:listItem];
                NSInteger index = [self.listItems indexOfObject:taskView.listItem];
                indexPath = [NSIndexPath indexPathForRow:index + taskView.listItem.numIncompleteChildren.intValue + 1 inSection:0];
                [self.listItems insertObject:listItem atIndex:indexPath.row];
                [self.disclosedBools insertObject:[NSNumber numberWithBool:NO] atIndex:indexPath.row];
            } else {
                [self.listItems addObject:listItem];
                [self.disclosedBools addObject:[NSNumber numberWithBool:NO]];
                indexPath = [NSIndexPath indexPathForItem:[self.listItems count]-1 inSection:0];
            }
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (ListItem *)addNewItemWithTaskView:(NewTaskView *)taskView
{
    if (taskView.listItem.parent) taskView.listItem.parent.numIncompleteChildren = [NSNumber numberWithInt:taskView.listItem.parent.numIncompleteChildren.intValue + 1];
    ListItem *listItem = [NSEntityDescription insertNewObjectForEntityForName:@"ListItem"
                                                       inManagedObjectContext:self.document.managedObjectContext];
    listItem.completed = [NSNumber numberWithBool:NO];
    listItem.contents = taskView.contents;
    listItem.calendar = [NSNumber numberWithInteger:taskView.calendar];
    listItem.isMulti = [NSNumber numberWithBool:taskView.isMulti];
    listItem.dateToSee = taskView.dateToSee;
    listItem.dateDue = taskView.dateDue;
    listItem.numIncompleteChildren = 0;
    listItem.parent = taskView.listItem.parent;
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:nil];
    return listItem;
}

#pragma mark - Add Cell Delegate Methods

- (void)addButtonPressedForCell:(UITableViewCell *)cell;
{
    ListItem *listItem = [self.listItems objectAtIndex:[self.tableView indexPathForCell:cell].row - 1];
    [self initiateAddingToListItem:listItem];
}

#pragma mark - Show Cell Delegate Methods

- (void)showCompletedTapped:(UITableViewCell *)cell
{
    ListItem *listItem = ((ShowCompletedCell *)cell).listItem;
    [self gatherCompletedItemsForListItem:listItem atIndex:[self.tableView indexPathForCell:cell].row];
}

- (void)hideCompletedTapped:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ListItem *listItem = ((ShowCompletedCell *)cell).listItem;
    NSInteger numToRemove = [listItem.children count] - listItem.numIncompleteChildren.integerValue;
    
    [self.listItems removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row - numToRemove, numToRemove)]];
    [self.disclosedBools removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row - numToRemove, numToRemove)]];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSInteger i = indexPath.row - numToRemove; i < indexPath.row; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Options View Delegate Methods

- (void)selectedIndexChangedToIndex:(NSInteger)index
{
    if (index == 1) self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
    else self.dateLabel.text = [self.options objectAtIndex:index];
    [self makeRequestWithOption:index];
    [self.tableView reloadData];
}

#pragma mark - List Cell Delegate Methods

- (NSInteger)numDisclosedChildren:(ListItem *)listItem
{
    NSInteger count = 0;
    NSInteger increaser = 0;
    NSInteger index = [self.listItems indexOfObject:listItem];
    for (NSInteger i = index + 1; i <= index + listItem.numIncompleteChildren.intValue + 2; i++) {
        NSNumber *boolean = [self.disclosedBools objectAtIndex:i + increaser];
        if (boolean.boolValue) {
            NSInteger numDisclosedChildren = [self numDisclosedChildren:[self.listItems objectAtIndex:i + increaser]];
            count += numDisclosedChildren + 1; // added extra one for parent as well as children
            increaser += numDisclosedChildren;
        } else {
            count++;
        }
    }
    return count;
}

- (void)deleteCellAndChildrenForCell:(UITableViewCell *)cell andListItem:(ListItem *)listItem
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([cell isKindOfClass:[ListCellDisclosure class]]) {
        ListCellDisclosure *disclosureCell = (ListCellDisclosure *)cell;
        if (disclosureCell.disclosed) {
            NSInteger numDisclosed = [self numDisclosedChildren:listItem];
            [self.listItems removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, numDisclosed + 1)]];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i = 0; i <= numDisclosed; i++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPath.row + i inSection:0];
                [indexPaths addObject:newPath];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.listItems removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    } else {
        [self.listItems removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)cellCompleted:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
    [self deleteCellAndChildrenForCell:cell andListItem:listItem];
    [listItem completeChildren];
    listItem.completed = [NSNumber numberWithBool:YES];
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:nil];
}

- (void)cellDeleted:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
    [self deleteCellAndChildrenForCell:cell andListItem:listItem];
    [listItem deleteChildren];
    [self.document.managedObjectContext deleteObject:listItem];
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:nil];
}

#pragma mark - Disclosure Cell Delegate Methods

- (void)listCellDisclosed:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ((ListCellDisclosure *)cell).disclosed = YES;
    [self queryForChildrenOfListItem:[self.listItems objectAtIndex:indexPath.row]];
}

- (void)listCellClosed:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ((ListCellDisclosure *)cell).disclosed = NO;
    [self.disclosedBools replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
    NSInteger numChildren = [self numDisclosedChildren:listItem];
    
    [self.listItems removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, numChildren)]];
    [self.disclosedBools removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, numChildren)]];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSInteger i = indexPath.row + 1; i < indexPath.row + 1 + numChildren; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (IBAction)buttonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
