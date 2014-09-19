//
//  bodyVC.m
//  DZAKNotes
//
//  Created by Akash Kumar on 9/15/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import "bodyVC.h"
#import "NotesTVC.h"
#import "DZAKNotes.h"
#import "DZAKTextStorage.h"

@interface bodyVC () <UITextViewDelegate>



@end

@implementation bodyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
//setting the save and del buttons
    //self.del = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(didTapDelButton:)];
    self.save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTapSaveButton:)];
    self.navigationItem.rightBarButtonItem = self.save;
 
    [self createTextView];
    self.bodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.bodyTextView.frame = self.view.bounds;
    
    if(self.textBody)
    {
        self.bodyTextView.attributedText = self.textBody;
    }
    
}

-(void)createTextView
{
    //create the text storage that backs the editor
    NSDictionary * attrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
 
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:@"" attributes:attrs];

    self.textStorage = [DZAKTextStorage new];
    [self.textStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = self.view.bounds;
    
    //create layout manager
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    
    //create a text view container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width, CGFLOAT_MAX);
    NSTextContainer * container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [self.textStorage addLayoutManager:layoutManager];
    
    //create a text view
    self.bodyTextView = [[UITextView alloc] initWithFrame:newTextViewRect textContainer:container];
    self.bodyTextView.delegate = self;
    [self.view addSubview:self.bodyTextView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapDelButton:(UIBarButtonItem *)delButton
{
    
}

- (void)didTapSaveButton:(UIBarButtonItem *)saveButton
{
    
    NSLog(@"title:%@ \n body:%@ ", self.textStorage.noteTitle, self.textStorage.noteBody);
    if(!self.textStorage.noteTitle.length || !self.textStorage.noteBody.length)
    {
        [UIAlertView showWithTitle:@"Notes" message:@"Please enter a title and note body" cancelButtonTitle:@"Okay" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    DZAKNotes * myNote = [DZAKNotes instanceFromDictionary:@{@"title":self.textStorage.noteTitle, @"body":self.textStorage.noteBody}];
    
    [myNote saveToDB];
    
    asyncMain(^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
}

@end
