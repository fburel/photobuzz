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


- (void) test_ptr_error
{

    NSError * error = nil;
    
    double result = divide(3, 0, &error);

    XCTAssert(result == 0);
    
    XCTAssert(error != nil && error.code == 1);
    
}

double divide(double a , double b, NSError **error)
{
    if(b == 0)
    {
    
        *error  = [NSError errorWithDomain:@"toto"
                                      code:1
                                  userInfo:nil];
        return 0;
    }
    else {
        *error = nil;
        return a / b;
    }
}

- (void) testIOS8
{
    XCTAssert(NSClassFromString(@"NSAsynchronousFetchResult") != nil);
}
@end
