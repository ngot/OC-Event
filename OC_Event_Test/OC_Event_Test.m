//
//  OC_Event_Test.m
//  OC_Event_Test
//
//  Created by ngot on 2/3/15.
//  Copyright (c) 2015 ngot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Event.h"

@interface OC_Event_Test : XCTestCase

@end

@implementation OC_Event_Test

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[Event instance] off];
}

- (void)testInstance {
    
    Event* e1 = [Event instance];
    Event* e2 = [Event instance];
    
    XCTAssertEqualObjects(e1, e2);
}


- (void)testOn {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    __block NSString* name1;
    
    [event on:name :^(id obj){
        name1 = name;
    }];
    
    [event trigger:name];
    
    XCTAssertEqualObjects(name, name1);
    
}

- (void)testTrigger {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    NSString* str = @"string";
    
    __block NSString* str1;
    
    [event on:name :^(id obj){
        str1 = (NSString*) obj;
    }];
    
    [event trigger:name :str];
    
    XCTAssertEqualObjects(str, str1);
    
}

- (void)testOnTwice {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    __block int i = 0;;
    
    [event on:name :^(id obj){
        i++;
    }];
    
    [event on:name :^(id obj){
        i+=2;
    }];
    
    [event trigger:name];
    
    XCTAssertEqual(3, i);
}

- (void)testOff {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    __block int i = 0;
    
    callbackFunction callback1 =^(id obj){
        i++;
    };
    
    [event on:name :callback1];
    
    [event trigger:name];
    
    XCTAssertEqual(1, i);
    
    [event off:name :callback1];
    
    [event trigger:name];
    XCTAssertEqual(1, i);
    
}

- (void)testOnce {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    __block int i = 0;
    
    callbackFunction callback1 =^(id obj){
        i++;
    };
    
    callbackFunction callback2 =^(id obj){
        i+=2;
    };
    
    [event on:name :callback1];
    [event once:name :callback2];
    
    [event trigger:name];
    
    XCTAssertEqual(3, i);
    
    [event trigger:name];
    
    XCTAssertEqual(4, i);
    
}

- (void)testOffAll {
    Event* event = [Event instance];
    
    NSString* name = @"test";
    __block int i = 0;
    
    callbackFunction callback1 =^(id obj){
        i++;
    };
    
    callbackFunction callback2 =^(id obj){
        i+=2;
    };
    
    [event on:name :callback1];
    [event on:name :callback2];
    
    [event trigger:name];
    
    XCTAssertEqual(3, i);
    
    [event off:name];
    
    [event trigger:name];
    
    XCTAssertEqual(3, i);
    
    [event on:name :callback1];
    [event on:name :callback2];
    
    [event trigger:name];
    
    XCTAssertEqual(6, i);
    
    [event off];
    
    [event trigger:name];
    
    XCTAssertEqual(6, i);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
