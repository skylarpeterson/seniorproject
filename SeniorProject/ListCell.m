//
//  ListCell.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/3/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ListCell.h"
#import "Colors.h"
#import "Fonts.h"

@interface ListCell() <UIGestureRecognizerDelegate, UITextViewDelegate>

@property (nonatomic) CGPoint cellCenter;
@property (nonatomic) BOOL shouldComplete;
@property (nonatomic) BOOL shouldDelete;

@property (nonatomic, strong) UIImageView *completeIconView;
@property (nonatomic, strong) UIView *completeView;
@property (nonatomic, strong) UIView *completeCircleView;
@property (nonatomic, strong) UIImageView *deleteIconView;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UIView *deleteCircleView;

@end

@implementation ListCell

#define COMPLETE_VIEW_SIZE 60.0
#define TEXT_VIEW_INSET 10.0

@synthesize text = _text;

#pragma mark - Lazy Instantiations

- (UIView *)completeView
{
    if (!_completeView) _completeView = [[UIView alloc] init];
    return _completeView;
}

- (UIView *)deleteView
{
    if (!_deleteView) _deleteView = [[UIView alloc] init];
    return _deleteView;
}

- (UITextView *)textView
{
    if (!_textView) _textView = [[UITextView alloc] init];
    return _textView;
}

- (NSAttributedString *)text
{
    return self.textView.attributedText;
}

#pragma mark - Setters

- (void)setText:(NSAttributedString *)text
{
    self.textView.attributedText = text;
    self.textView.textColor = [Colors lightestGrayColor];
}

+ (CGSize)sizeForTextViewWithText:(NSAttributedString *)text inCellWidth:(CGFloat)width
{
    CGRect stringBounds = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(width, stringBounds.size.height);
}

#pragma mark - Initializing Methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView.superview setClipsToBounds:NO];
        
        UIView *selectionView = [[UIView alloc] init];
        selectionView.backgroundColor = [Colors secondarGrayColor];
        self.selectedBackgroundView = selectionView;
        
        self.textView.userInteractionEnabled = NO;
        self.textView.tintColor = [Colors lightestGrayColor];
        self.textView.scrollEnabled = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.font = [Fonts listItemFont];
        [self.textView setTextContainerInset:UIEdgeInsetsZero];
        [self addSubview:self.textView];
        
        self.completeView.backgroundColor = [UIColor clearColor];
        self.completeIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckLight.png"]];
        [self.completeView addSubview:self.completeIconView];
        [self.contentView addSubview:self.completeView];
        
        self.deleteView.backgroundColor = [UIColor clearColor];
        self.deleteIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XLight.png"]];
        [self.deleteView addSubview:self.deleteIconView];
        [self.contentView addSubview:self.deleteView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanned:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.completeView.frame = CGRectMake(-self.frame.size.width, 0.0, self.frame.size.width, self.frame.size.height);
    self.completeIconView.frame = CGRectMake(self.completeView.frame.size.width - COMPLETE_VIEW_SIZE - TEXT_VIEW_INSET, self.frame.size.height / 2.0 - COMPLETE_VIEW_SIZE/2.0, COMPLETE_VIEW_SIZE, COMPLETE_VIEW_SIZE);
    self.deleteView.frame = CGRectMake(self.frame.size.width, 0.0, self.frame.size.width, self.frame.size.height);
    self.deleteIconView.frame = CGRectMake(TEXT_VIEW_INSET, self.frame.size.height / 2.0 - COMPLETE_VIEW_SIZE/2.0, COMPLETE_VIEW_SIZE, COMPLETE_VIEW_SIZE);
    CGSize textViewSize = [ListCell sizeForTextViewWithText:self.textView.attributedText inCellWidth:self.frame.size.width - TEXT_VIEW_INSET];
    self.textView.frame = CGRectMake(TEXT_VIEW_INSET, self.frame.size.height / 2.0 - textViewSize.height / 2.0, textViewSize.width, textViewSize.height);
}

#pragma mark - Gesture Recognizer Methods

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

- (void)cellPanned:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.cellCenter = self.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.shouldDelete = translation.x <= -self.frame.size.width/3.0;
        if (translation.x > 0) {
            if (self.canComplete) {
                self.shouldComplete = translation.x >= self.frame.size.width/3.0;
                self.center = CGPointMake(self.cellCenter.x + translation.x, self.cellCenter.y);
            }
        } else {
            self.center = CGPointMake(self.cellCenter.x + translation.x, self.cellCenter.y);
        }
        
        if (self.shouldComplete) {
            self.completeView.backgroundColor = [Colors completeColor];
            self.completeIconView.image = [UIImage imageNamed:@"CheckDark.png"];
        } else {
            self.completeView.backgroundColor = [Colors secondarGrayColor];
            self.completeIconView.image = [UIImage imageNamed:@"CheckLight.png"];
        }
        
        if (self.shouldDelete) {
            self.deleteView.backgroundColor = [Colors deleteColor];
            self.deleteIconView.image = [UIImage imageNamed:@"XDark.png"];
        } else {
            self.deleteView.backgroundColor = [Colors secondarGrayColor];
            self.deleteIconView.image = [UIImage imageNamed:@"XLight.png"];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.shouldComplete) {
            [self.delegate cellCompleted:self];
        } else if (self.shouldDelete) {
            [self.delegate cellDeleted:self];
        } else {
            [UIView animateWithDuration:0.35
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.center = self.cellCenter;
                             }
                             completion:^(BOOL finished){
                                 self.shouldComplete = NO;
                                 self.shouldDelete = NO;
                             }];
        }
    }
}

@end
