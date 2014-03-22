//
//  ListItem+Children.m
//  One
//
//  Created by Skylar Peterson on 3/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ListItem+Children.h"

@implementation ListItem (Children)

- (void)completeChildren
{
    for (ListItem *child in self.children) {
        if (child.children) [child completeChildren];
        child.completed = [NSNumber numberWithBool:YES];
    }
    if (self.parent) self.parent.numIncompleteChildren = [NSNumber numberWithInt:self.parent.numIncompleteChildren.intValue - 1];
    self.numIncompleteChildren = 0;
}

- (void)deleteChildren
{
    for (ListItem *child in self.children) {
        if (child.children) [child deleteChildren];
        [child.managedObjectContext deleteObject:child];
    }
}

@end
