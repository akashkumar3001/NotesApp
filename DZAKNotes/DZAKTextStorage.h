//
//  DZAKTextStorage.h
//  DZAKNotes
//
//  Created by Akash Kumar on 9/18/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZAKTextStorage : NSTextStorage

@property (nonatomic, strong) NSMutableAttributedString *backingStore;
@property (nonatomic,strong) NSString * noteTitle ,*noteBody;
@property (nonatomic, assign) BOOL isSettingUp, hasAssignedTitle;

- (UIFont *)boldFont;

@end
