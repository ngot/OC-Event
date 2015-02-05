//
//  Event.m
//  OC_Event
//
//  Created by ngot on 2/3/15.
//  Copyright (c) 2015 ngot. All rights reserved.
//

#import "Event.h"

static NSMutableDictionary* events;
static Event* e = nil;

@implementation Event

+(Event*)instance{
    if(e == nil){
        e = [[Event alloc] init];
        events = [[NSMutableDictionary alloc] init];
    }
    return e;
};

-(void) on:(NSString*) name : (callbackFunction) callback{
    _callbackFunction _callback = ^(NSNotification* obj){
        callback([obj userInfo]);
    };
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    NSMutableArray* callbacks = [events valueForKey:name];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:callback];
    [arr addObject:_callback];
    
    id oberver = [center addObserverForName:name object:nil
                                      queue:mainQueue usingBlock:_callback];
    [arr addObject:oberver];
    
    if(callbacks == nil){
        [events setObject:[[NSMutableArray alloc] initWithObjects:arr, nil] forKey:name];
    }else{
        [callbacks addObject:arr];
    }
}

-(void) once:(NSString*) name : (callbackFunction) callback{
    NSMutableArray* callbacks = [events valueForKey:name];
    if(callbacks != nil){
        [self off:name :callback];
    }
    
    callbackFunction _callback = ^(id obj){
        callback([obj userInfo]);
        [self off:name :callback];
    };
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:callback];
    [arr addObject:_callback];
    
    id oberver = [center addObserverForName:name object:nil
                                      queue:mainQueue usingBlock:_callback];
    [arr addObject:oberver];
    
    if(callbacks == nil){
        [events setObject:[[NSMutableArray alloc] initWithObjects:arr, nil] forKey:name];
    }else{
        [callbacks addObject:arr];
    }
}

-(void)trigger:(NSString*) name{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self];
}
-(void)trigger:(NSString*) name : (id) obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:obj];
}

-(void) off:(NSString*) name : (callbackFunction) callback{
    
    NSMutableArray* callbacks = [events valueForKey:name];
    if(callbacks != nil){
        NSMutableArray* arrs = [[NSMutableArray alloc] init];
        
        for(NSMutableArray* arr in callbacks){
            if((callbackFunction)[arr objectAtIndex:0] == callback){
                [[NSNotificationCenter defaultCenter] removeObserver:[arr objectAtIndex:2]];
                [arrs addObject:arr];
            }
        }
        
        for(NSMutableArray* arr in arrs){
            [callbacks removeObject:arr];
        }
        
        if([callbacks count] == 0){
            [events removeObjectForKey:name];
        }
    }
}

-(void) off:(NSString*) name{
    NSMutableArray* callbacks = [events valueForKey:name];
    if(callbacks != nil){
        NSMutableArray* arrs = [[NSMutableArray alloc] init];
        for(NSMutableArray* arr in callbacks){
            [[NSNotificationCenter defaultCenter] removeObserver:[arr objectAtIndex:2]];
            [arrs addObject:arr];
        }
        for(NSMutableArray* arr in arrs){
            [callbacks removeObject:arr];
        }
        
        [events removeObjectForKey:name];
    }
}

-(void) off{
    for(NSString* name in events){
        [self off:name];
    }
    [events removeAllObjects];
}

@end
