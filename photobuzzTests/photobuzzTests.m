//
//  photobuzzTests.m
//  photobuzzTests
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PictureRepository.h"
#import "Picture.h"

@interface photobuzzTests : XCTestCase

@end

@implementation photobuzzTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPictureFetcher
{
    FlickRArea area;
    area.latitude = 55.7525;
    area.longitude = 37.623086;
    area.radius = 10;

    PictureRepository * repo = [PictureRepository new];

    NSArray * dl = [repo picturesFromArea:area];

    XCTAssert(dl.count == 300);

    for(id element in dl)
    {
        Class PictureClass = NSClassFromString(@"Picture");
        BOOL classOk = [element isKindOfClass:PictureClass];
        XCTAssert(classOk);
    }
}

//Test cache
- (void) testCache
{
    Picture * p = [Picture new];
    p.url = @"test";
    
    PictureRepository * repo = [PictureRepository new];

    NSData * data = [repo cachedDataForPicture:p];
    
    XCTAssert(data == nil);
    
    data = [NSData data];
    
    [repo registerCacheData:data forPicture:p];
    
    XCTAssert([repo cachedDataForPicture:p] == data);
    
}

@end
