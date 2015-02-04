//
//  Event.h
//  OC_Event
//
//  Created by ngot on 2/3/15.
//  Copyright (c) 2015 ngot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^_callbackFunction)(NSNotification*);
typedef void(^callbackFunction)(id);

@interface Event : NSObject{
    
}

+(Event*)instance;

-(void) on:(NSString*) name : (callbackFunction) callback;
-(void) once:(NSString*) name : (callbackFunction) callback;

-(void) trigger:(NSString*)name : (id) obj;
-(void) trigger:(NSString*)name;

-(void) off:(NSString*)name : (callbackFunction) callback;
-(void) off:(NSString*)name;
-(void) off;

@end
