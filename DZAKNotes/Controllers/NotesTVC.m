//
//  NotesTVC.m
//  DZAKNotes
//
//  Created by Akash Kumar on 9/15/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import "NotesTVC.h"
#import "DZAKNotes.h"
#import "bodyVC.h"
#import "DZAKTextStorage.h"

NSString * const cellID = @"NotesTVCCell";

@interface NotesTVC () <DZDatasource>

@end

@implementation NotesTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NOTES";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAdd:)];
    self.navigationItem.rightBarButtonItem = self.add;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
     _dataSource = [DZBasicDatasource datasourceWithView:self.tableView];
    self.dataSource.delegate = self;
    [DZAKNotes getAllNotesWithSuccess:^(NSArray *notes) {
        
        self.dataSource.data = notes.mutableCopy;
        
    }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DZAKNotes * note = [self.dataSource.data objectAtIndex:indexPath.row];
    [note deleteFromDB];
    [self.dataSource.data removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    LogInt([self.dataSource.data count]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [DZAKNotes getAllNotesWithSuccess:^(NSArray *notes) {
           
            self.dataSource.data = [notes mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            LogInt([self.dataSource.data count]);
        }];
        
    });
    
}

#pragma mark - UIEvents

- (void)didTapAdd:(UIBarButtonItem *)addButton
{
    bodyVC * view = [bodyVC new];
    [self.navigationController pushViewController:view animated:YES];
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    DZAKNotes * note = [self.dataSource.data objectAtIndex:indexPath.row];
    
    if (!note) return cell;
    
    cell.textLabel.text = note.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DZAKNotes *note = [self.dataSource.data objectAtIndex:indexPath.row];
    
    if(!note) return;
    
    bodyVC * view = [bodyVC new];
    
    view.note = note;
    
    [self.navigationController pushViewController:view animated:YES];
    
}



@end
