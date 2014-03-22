//
//  CircleView.m
//  MinList
//
//  Created by Skylar Peterson on 8/27/13.
//  Copyright (c) 2013 Skylar Peterson. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

-(id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = color;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextSetFillColorWithColor(contextRef, [self.color CGColor]);
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 1.0);
    CGRect circlePoint = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGContextFillEllipseInRect(contextRef, circlePoint);
}

@end
