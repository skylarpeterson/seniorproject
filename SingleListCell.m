//
//  SingleListCell.m
//  SquareList
//
//  Created by Skylar Peterson on 11/18/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SingleListCell.h"

#import "ListItemCompletionView.h"

#import "Colors.h"
#import "Fonts.h"

@interface SingleListCell() <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) CALayer *cameraBorder;

@property (nonatomic, strong) ListItemCompletionView *listCompletionView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UILabel *deleteLabel;

@property (nonatomic) CGRect currentTextRect;
@property (nonatomic) CGPoint cellCenter;
@property (nonatomic) CGFloat initialOffset;
@property (nonatomic) BOOL shouldDelete;

@end

@implementation SingleListCell

@synthesize text = _text;

- (CALayer *)topBorder
{
    if (!_topBorder) {
        _topBorder = [CALayer layer];
    }
    return _topBorder;
}

- (CALayer *)cameraBorder
{
    if (!_cameraBorder) {
        _cameraBorder = [CALayer layer];
    }
    return _cameraBorder;
}

- (ListItemCompletionView *)listCompletionView
{
    if (!_listCompletionView) {
        _listCompletionView = [[ListItemCompletionView alloc] init];
    }
    return _listCompletionView;
}

- (UILabel *)deleteLabel
{
    if (!_deleteLabel) _deleteLabel = [[UILabel alloc] init];
    return _deleteLabel;
}

- (NSAttributedString *)text
{
    return self.textView.attributedText;
}

- (void)setListItem:(ListItem *)listItem
{
    _listItem = listItem;
    if (listItem) {
        self.listCompletionView.completed = [listItem.completed boolValue];
    }
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.listCompletionView.color = self.color;
}

- (void)setBackdropColor:(UIColor *)backdropColor
{
    _backdropColor = backdropColor;
    self.textView.textColor = backdropColor;
}

- (void)setText:(NSAttributedString *)text
{
    _text = text;
    self.textView.attributedText = text;
    CGSize textViewSize = [SingleListCell sizeForTextViewWithText:self.textView.attributedText inCellWidth:self.frame.size.width - LIST_COMPLETION_VIEW_SIZE - IMAGE_BUTTON_SIZE];
    self.textView.frame = CGRectMake(LIST_COMPLETION_VIEW_SIZE, self.frame.size.height / 2.0 - textViewSize.height / 2.0, textViewSize.width, textViewSize.height);
    self.currentTextRect = [self.textView caretRectForPosition:[self.textView endOfDocument]];
}

+ (CGSize)sizeForTextViewWithText:(NSAttributedString *)text inCellWidth:(CGFloat)width
{
    CGRect stringBounds = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(width, stringBounds.size.height);
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] init];
    }
    return _cameraButton;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.listCompletionView.color = self.color;
        self.listCompletionView.completed = NO;
        
        self.textView.scrollEnabled = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.font = [Fonts bodyTextFont];
        [self.textView setTextContainerInset:UIEdgeInsetsZero];
        
        self.topBorder.backgroundColor = [[Colors interactiveColor] CGColor];
        [self.layer addSublayer:self.topBorder];
        
        self.cameraBorder.backgroundColor = [[Colors interactiveColor] CGColor];
        [self.layer addSublayer:self.cameraBorder];
        
        [self addSubview:self.listCompletionView];
        [self addSubview:self.textView];
        UIImage *image = [UIImage imageNamed:@"Camera.png"];
        [self.cameraButton addTarget:self action:@selector(showPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [self.cameraButton setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self addSubview:self.cameraButton];
        
        [self.contentView.superview setClipsToBounds:NO];
        self.deleteLabel.text = @"Delete";
        self.deleteLabel.textColor = [Colors interactiveColor];
        self.deleteLabel.textAlignment = NSTextAlignmentCenter;
        self.deleteLabel.font = [Fonts subBodyTextFont];
        [self.contentView addSubview:self.deleteLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeItem)];
        [self.listCompletionView addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        
        UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellPressed:)];
        pressGesture.minimumPressDuration = 0.25;
        [self addGestureRecognizer:pressGesture];
    }
    return self;
}

#define CAMERA_BORDER_INSET 10.0f
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBorder.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width + self.frame.size.width/4.0, 1.0f);
    self.cameraBorder.frame = CGRectMake(self.frame.size.width - IMAGE_BUTTON_SIZE, CAMERA_BORDER_INSET, 1.0f, self.frame.size.height - 2 * CAMERA_BORDER_INSET);
    self.listCompletionView.frame = CGRectMake(0, self.frame.size.height / 2.0 - LIST_COMPLETION_VIEW_SIZE / 2.0, LIST_COMPLETION_VIEW_SIZE, LIST_COMPLETION_VIEW_SIZE);
    self.cameraButton.frame = CGRectMake(self.frame.size.width - IMAGE_BUTTON_SIZE, self.frame.size.height / 2.0 - IMAGE_BUTTON_SIZE / 2.0, IMAGE_BUTTON_SIZE, IMAGE_BUTTON_SIZE);
    self.deleteLabel.frame = CGRectMake(self.frame.size.width, 1.0, self.frame.size.width/4.0, self.frame.size.height - 1.0);
}

- (void)showPhotos:(UIButton *)sender
{
    [self.delegate showPhotosForCell:self];
}

#pragma mark - Gesture Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[self superview]];
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)completeItem
{
    if ([self.delegate shouldChangeItemCompletion]) {
        BOOL completed = [self.listItem.completed boolValue];
        if (!completed) {
            self.alpha = 0.5;
            self.listCompletionView.completed = YES;
            self.listItem.completed = [NSNumber numberWithBool:YES];
            [self.delegate changeItemCompletion:self toBOOL:YES];
        } else {
            self.alpha = 1.0;
            self.listCompletionView.completed = NO;
            self.listItem.completed = [NSNumber numberWithBool:NO];
            [self.delegate changeItemCompletion:self toBOOL:NO];
        }
    }
}

// Taken and adapted from http://www.raywenderlich.com/21842/how-to-make-a-gesture-driven-to-do-list-app-part-13
- (void)deleteItem:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.cellCenter = self.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.shouldDelete = translation.x <= -self.frame.size.width/4.0;
        if (translation.x <= -self.frame.size.width/4.0 || translation.x > 0) return;
        self.center = CGPointMake(self.cellCenter.x + translation.x, self.cellCenter.y);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0.0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:0.35
                         animations:^{
                             self.frame = originalFrame;
                         }];
        if (self.shouldDelete) {
            [self.delegate deleteItemForCell:self];
        }
    }
}

#define GROWTH_OFFSET 5.0

- (void)cellPressed:(UILongPressGestureRecognizer *)sender
{
    SingleListCell *cell = (SingleListCell *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"%f", cell.frame.origin.y);
        self.initialOffset = [sender locationInView:self].y;
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
                         }completion:nil];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [sender locationInView:self];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + (newPoint.y - self.initialOffset), cell.frame.size.width, cell.frame.size.height);
        [self.delegate cellMoved:self];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cell.backgroundColor = [UIColor clearColor];
                         }completion:nil];
    }
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate textViewDidBeginEditingForCell:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate textViewDidEndEditingForCell:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.attributedText.string isEqualToString:@""]) return;
    CGSize newSize = [SingleListCell sizeForTextViewWithText:textView.attributedText inCellWidth:textView.frame.size.width];
    if (newSize.height > self.currentTextRect.size.height || newSize.height < self.currentTextRect.size.height) {
        [self.delegate textViewDidGrowVertically:self toHeight:newSize.height + 40.0f];
        self.textView.frame = CGRectMake(LIST_COMPLETION_VIEW_SIZE, self.frame.size.height / 2.0 - newSize.height / 2.0, newSize.width, newSize.height);
        self.currentTextRect = CGRectMake(self.currentTextRect.origin.x, self.currentTextRect.origin.y, newSize.width, newSize.height);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        if ([textView.text isEqualToString:@""]) [self.delegate editedTextIsBlank:self];
        else [self.delegate editedTextChanged:self];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)cellJustAdded
{
    self.textView.text = @"";
    [self.textView becomeFirstResponder];
}

- (void)shiftCellBorderByOffset:(CGFloat)offset
{
    self.topBorder.frame = CGRectMake(self.topBorder.frame.origin.x, self.topBorder.frame.origin.y + offset, self.topBorder.frame.size.width, self.topBorder.frame.size.height);
}

@end
