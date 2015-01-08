//
//  FBImageCaroussel.h
//  One Piece 772
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBImageCarousselDataSource <NSObject>

- (UIView *) viewForPageIndex:(int)pageIdx;
- (int) numberOfPages;

@end


@interface FBImageCaroussel : UIView

@property (nonatomic, readwrite, weak) id<FBImageCarousselDataSource> dataSource;
- (void)displayPageAtIndex:(int)index;
@end
