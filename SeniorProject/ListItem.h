//
//  ListItem.h
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * calendar;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSDate * dateDue;
@property (nonatomic, retain) NSDate * dateToSee;
@property (nonatomic, retain) NSNumber * isMulti;
@property (nonatomic, retain) NSNumber * numIncompleteChildren;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) ListItem *parent;
@end

@interface ListItem (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(ListItem *)value;
- (void)removeChildrenObject:(ListItem *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
