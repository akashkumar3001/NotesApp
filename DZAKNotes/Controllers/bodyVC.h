//
//  bodyVC.h
//  DZAKNotes
//
//  Created by Akash Kumar on 9/15/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZAKTextStorage.h"

@interface bodyVC : UIViewController

@property (nonatomic, strong) NSAttributedString * textBody;
@property (nonatomic, strong) UIBarButtonItem * save;
@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic,strong) DZAKTextStorage * textStorage;

-(void)createTextView;

@end
