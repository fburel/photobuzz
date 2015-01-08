//
//  FBImageCaroussel.m
//  One Piece 772
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "FBImageCaroussel.h"

@interface FBImageCaroussel ()

@property (nonatomic) BOOL isConfigured;
@property (nonatomic) int currentPageIndex;

@end

@implementation FBImageCaroussel

- (void)layoutSubviews
{

    if(!_isConfigured)
    {
        // Add the gesture recognizers
        UISwipeGestureRecognizer * right = [UISwipeGestureRecognizer new];
        [right addTarget:self action:@selector(handleSwipe:)];
        right.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:right];
        
        UISwipeGestureRecognizer * left = [UISwipeGestureRecognizer new];
        [left addTarget:self action:@selector(handleSwipe:)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:left];
        
        // Affiche la 1ere page
        if([self.dataSource numberOfPages] > 0)
        {
            [self displayPageAtIndex:0];
        }
        
        _isConfigured = YES;
    }
    
}

- (void)displayPageAtIndex:(int)index
{
    // Recuperer la page
    UIView * page = [self.dataSource viewForPageIndex:index];
    UIView * previous = [self.subviews lastObject];
    
    // Ajuster la taille
    page.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    page.contentMode = UIViewContentModeScaleAspectFit;
    
    // Afficher
    [self addSubview:page];
    
    
    // animation - decalage de la page a afficher
    float offset = self.frame.size.width * 1.33;
    if(index < self.currentPageIndex)
    {
        offset *= -1;
    }
    page.center = CGPointMake(page.center.x + offset, page.center.y);
    
    
    
    [UIView animateWithDuration:.33
                     animations:^{
                         page.center = CGPointMake(page.center.x - offset, page.center.y);
                         previous.center = CGPointMake(previous.center.x - offset, previous.center.y);
                     }
                     completion:^(BOOL finished) {
                         [previous removeFromSuperview];
                     }];
    
    self.currentPageIndex = index;
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)sender
{
    BOOL isFirstPage = self.currentPageIndex == 0;
    BOOL isLastPage = self.currentPageIndex == [self.dataSource numberOfPages] -1;
    BOOL wantsNextPage = sender.direction == UISwipeGestureRecognizerDirectionLeft;
    BOOL wantsPreviousPage = sender.direction == UISwipeGestureRecognizerDirectionRight;
    
    if(wantsPreviousPage && !isFirstPage)
    {
        [self displayPageAtIndex:self.currentPageIndex - 1];
    }
    else if(wantsNextPage && !isLastPage)
    {
        [self displayPageAtIndex:self.currentPageIndex + 1];
    }
    else
    {
        [self bounce:sender.direction];
    }
}

- (void) bounce:(UISwipeGestureRecognizerDirection)direction
{
    UIView * page = [self.subviews lastObject];
    NSTimeInterval animationDuration = .33;
    float offset = 30;
    
    if(direction == UISwipeGestureRecognizerDirectionLeft)
    {
        offset *= -1;
    }
    // first part of the bounce
    [UIView animateWithDuration:animationDuration / 2.
                          delay:0
                        options:0
                     animations:^{
                         page.center = CGPointMake(
                                                   page.center.x + offset,
                                                   page.center.y);
                     }
                     completion:nil];

    [UIView animateWithDuration:animationDuration / 2.
                          delay:animationDuration / 2.
                        options:0
                     animations:^{
                         page.center = CGPointMake(
                                                   page.center.x - offset,
                                                   page.center.y);
                     } completion:nil];
    
}
@end
