//
//  DZAKNotes.h
//  
//
//  Created by Akash Kumar on 9/16/14.
//  Copyright (c) 2014 Dezine Zync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZAKNotes : NSObject <NSCoding>

typedef void(^DZAKNoteCompleted)(DZAKNotes *note);
typedef void(^DZAKNotesCompleted)(NSArray *notes);

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSNumber *noteID;
@property (nonatomic, copy) NSNumber *sortID;
@property (nonatomic, copy) NSString *title;


+ (DZAKNotes *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

#pragma mark - DB

+ (void)getAllNotesWithSuccess:(DZAKNotesCompleted)success;

+ (void)getNoteWithID:(NSNumber *)key success:(DZAKNoteCompleted)success;

- (void)saveToDB; //first check if note exists in DB if it exists modify it if not create a new one

- (void)deleteFromDB;

@end
