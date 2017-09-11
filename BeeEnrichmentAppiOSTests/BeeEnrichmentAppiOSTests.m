//
//  BeeEnrichmentAppiOSTests.m
//  BeeEnrichmentAppiOSTests
//
//  Created by dll on 15/12/18.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BeeEnrichmentAppiOSTests : XCTestCase

@end

@implementation BeeEnrichmentAppiOSTests
// 每个测试方法调用前执行
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
// 每个测试方法调用后执行
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
// 测试方法
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    NSLog(@"自定义测试testExample");
//    int  a= 3;
//    XCTAssertTrue(a == 0,"a 不能等于 0");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
