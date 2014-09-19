//
//  DZAKTextStorage.m
//  DZAKNotes
//
//  Created by Akash Kumar on 9/18/14.
//  Copyright (c) 2014 Akash Kumar. All rights reserved.
//

#import "DZAKTextStorage.h"

@interface DZAKTextStorage ()
{
    BOOL _processEditing;
}

@property (nonatomic, assign) BOOL hasAssignedTitle;

@end

@implementation DZAKTextStorage


- (id)init
{
    if (self = [super init])
    {
        self.backingStore = [NSMutableAttributedString new];
        _processEditing = YES;
    }
    return self;
}


- (NSString *)string
{
    return [self.backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [self.backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
//    NSLog(@"replaceCharacterInRange:%@ withString %@",NSStringFromRange(range),str);
    
    [self.backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];

    _processEditing = YES;
    
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self.backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    _processEditing = YES;
}

-(void)processEditing
{
    if(_processEditing)
    {
        _processEditing = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    
    [super processEditing];
}

-(void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyTokenAttributesToRange: extendedRange];
    
}

- (void)applyTokenAttributesToRange:(NSRange)extendedRange
{
    
//    NSLog(@"%@", NSStringFromRange(extendedRange));
   
    NSString *text = [[self string] substringWithRange:extendedRange];
    
//    Has gone to next line and hasn't set Title. So set the title.
    if ([text isEqualToString:@"\n"] && !self.hasAssignedTitle)
    {
        if (![self string].length)
        {
            self.noteTitle = @"";
            self.hasAssignedTitle = YES;
        }
        else
        {
            
            NSString * strX = [self string];
            strX = [strX stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            self.noteTitle = strX;
            
            NSRange titleRange = [[self string] rangeOfString:self.noteTitle];
            
            if(titleRange.location == NSNotFound || titleRange.length > [self string].length) return;
            
           [self setAttributes:@{NSFontAttributeName:[self boldFont]} range:titleRange];
            
            self.hasAssignedTitle = YES;
            
        }
        
    }
//    Still editing title. Hasn't gone to the next line.
    else if(!self.hasAssignedTitle || extendedRange.location == 0)
    {
        [self setAttributes:@{NSFontAttributeName:[self boldFont]} range:extendedRange];
        
        if(self.noteBody.length)
        {
            
            NSRange r = [[self string] rangeOfString:self.noteBody];
            r.location -= 1;
            
            NSRange titleRange = NSMakeRange(0, r.location);
            
            self.noteTitle = [[self string] substringWithRange:titleRange];
            
        }
        else
        {
            self.noteTitle = [self string];
        }
   
    }
//    Has set the title. And Is editing the body.
    else
    {
       
//        Editing body
        if(extendedRange.location > self.noteTitle.length)
        {
            
            [self setAttributes:@{NSFontAttributeName: [self normalFont]} range:extendedRange];
            
            self.noteBody = [self bodyText];
            
        }
        else
        {
//            Editing Title
            self.hasAssignedTitle = NO;
            [self applyTokenAttributesToRange:extendedRange];
        }
        
    }
    
//    NSLog(@"Title: %@\nBody: %@", self.noteTitle, self.noteBody);
    
}

#pragma mark - Getters

- (NSString *)bodyText
{
    if(!self.noteTitle || !self.noteTitle.length) return @"";
    
    NSString * strX = [self string];
    strX = [strX substringFromIndex:self.noteTitle.length+1];
    
    return strX;
}

- (UIFont *)normalFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (UIFont *)boldFont
{
    
    UIFont * font = [self normalFont];
    NSString * fontName = font.fontName;
    fontName = [fontName stringByReplacingOccurrencesOfString:@"-Regular" withString:@"-Bold"];
    
    return [UIFont fontWithName:fontName size:font.pointSize];
    
}

@end
