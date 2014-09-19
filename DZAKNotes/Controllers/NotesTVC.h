//
//  NotesTVC.h
//  DZAKNotes
//
//  Created by Akash Kumar on 9/15/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBasicDatasource.h"

@interface NotesTVC : UITableViewController

@property (nonatomic, strong) UIBarButtonItem * add;
@property (nonatomic, strong) DZBasicDatasource * dataSource;

@end
