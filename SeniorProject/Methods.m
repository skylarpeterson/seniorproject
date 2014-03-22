//
//  Methods.m
//  One
//
//  Created by Skylar Peterson on 2/24/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "Methods.h"

@implementation Methods

+ (CGSize)sizeForText:(NSString *)text withWidth:(CGFloat)width andFont:(UIFont *)font
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                                           attributes:@{ NSFontAttributeName : font }];
    CGRect stringBounds = [attributedString boundingRectWithSize:CGSizeMake(width, 10000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return stringBounds.size;
}



@end
