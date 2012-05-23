//
//  JUObjectController.h
//  JUBindings
//
//  Copyright (c) 2012 by Sidney Just
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
//  and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JUObjectController : NSObject

@property (nonatomic, retain) id content;
@property (nonatomic, retain) Class objectClass;
@property (nonatomic, assign) BOOL canAdd;
@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign, getter=isEditable) BOOL editable;

@property (nonatomic, assign) BOOL usesLazyFetching;
@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSPredicate *fetchPredicate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)newObject;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;

- (NSFetchRequest *)defaultFetchRequest;
- (void)fetch:(id)sender;
- (BOOL)fetchWithRequest:(NSFetchRequest *)fetchRequest merge:(BOOL)merge error:(NSError **)error;


- (id)selection;
- (NSArray *)selectedObjects;

- (id)initWithContent:(id)content;

@end
