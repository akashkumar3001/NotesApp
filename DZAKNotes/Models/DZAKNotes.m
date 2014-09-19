//
//  DZAKNotes.m
//  
//
//  Created by Akash Kumar on 9/16/14.
//  Copyright (c) 2014 Dezine Zync. All rights reserved.
//

NSString * const notesCollection = @"com.dz.notesCollection";

#import "DZAKNotes.h"

#import "DZYAPDatabase.h"

@implementation DZAKNotes

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.body forKey:@"body"];
    [encoder encodeObject:self.noteID forKey:@"noteID"];
    [encoder encodeObject:self.sortID forKey:@"sortID"];
    [encoder encodeObject:self.title forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.body = [decoder decodeObjectForKey:@"body"];
        self.noteID = [decoder decodeObjectForKey:@"noteID"];
        self.sortID = [decoder decodeObjectForKey:@"sortID"];
        self.title = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}

+ (DZAKNotes *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    DZAKNotes *instance = [[DZAKNotes alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    instance.noteID = @([[DZAKNotes UUID] integerValue]);
    
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.body) {
        [dictionary setObject:self.body forKey:@"body"];
    }

    if (self.noteID) {
        [dictionary setObject:self.noteID forKey:@"noteID"];
    }

    if (self.sortID) {
        [dictionary setObject:self.sortID forKey:@"sortID"];
    }

    if (self.title) {
        [dictionary setObject:self.title forKey:@"title"];
    }

    return dictionary;

}

#pragma marks - DB
+ (void)getAllNotesWithSuccess:(DZAKNotesCompleted)success
{
    
    if (!success) return;
    
    [DZYAPDatabase getAllFromCollection:notesCollection complete:^(BOOL finished, NSArray *batch) {
        
        if(!finished)
        {
            success(@[]);
            return;
        }
        
        success(batch);
        
    }];
    
}

+ (void)getNoteWithID:(NSNumber *)key success:(DZAKNoteCompleted)success
{
    if (!key) return;
    
    if (!success) return;
    
    [DZYAPDatabase get:[DZAKNotes keyFromNoteID:key] fromCollection:notesCollection completion:^(BOOL finished, id obj) {
    
        if(!finished)
        {
            success(nil);
            return ;
        }
        
        success(obj);
        
    }];
    
}

- (void)saveToDB
{
    
    [DZYAPDatabase set:self key:[DZAKNotes keyFromNoteID:self.noteID] collection:notesCollection];
    
}

- (void)deleteFromDB
{
    [DZYAPDatabase del:[DZAKNotes keyFromNoteID:self.noteID] fromCollection:notesCollection];
}

#pragma mark - getters

+ (NSString *)keyFromNoteID:(NSNumber *)ID
{
    
    return [NSString stringWithFormat:@"note:%@", [ID stringValue]];
    
}

+ (NSString *)UUID
{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
