//
//  BSViewController.m
//  BScrollController
//
//  Created by Piotr Bernad on 09.10.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBGSViewController.h"
#import "PBGSCollectionViewController.h"
#import "PBGSCollectionLayout.h"
#import <QuartzCore/QuartzCore.h>

#define minTranslateYToSkip 0.35
#define animationTime 0.25f
#define translationAccelerate 1.3f

#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PBGSViewController () <UIGestureRecognizerDelegate>

@end

typedef enum {
    BSScrollDirectionUnknown,
    BSScrollDirectionFromBottomToTop,
    BSScrollDirectionFromTopToBottom
} BSScrollDirection;

@implementation PBGSViewController {
    UIPanGestureRecognizer *_panGesture;
    NSMutableArray *_snapshotsArray;
    
    BOOL _collectionHasItemsToShow;
    BOOL _isOnTop;
    
    BSScrollDirection _scrollDirection;
    UIImageView *_snapshotView;
    UIImageView *_currentlyVisibleScreenSnapshot;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_panGesture setDelegate:self];
    [self.view addGestureRecognizer:_panGesture];
    
    _snapshotsArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    PBGSCollectionLayout *layout = [[PBGSCollectionLayout alloc] init];
    PBGSCollectionViewController *collectionViewController = [[PBGSCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self setCollectionViewController:collectionViewController];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_collectionViewController.view setFrame:self.view.frame];
}

#pragma mark - Setters

- (void)setCollectionViewController:(PBGSCollectionViewController *)controller {
    if (_collectionViewController != controller) {
        _collectionViewController = controller;
        
        [self addChildViewController:_collectionViewController];
        [self.view addSubview:_collectionViewController.collectionView];
        [_collectionViewController didMoveToParentViewController:self];
        
        [_collectionViewController.collectionView setDelegate:self];
        [_collectionViewController.collectionView setDataSource:self];
        [_collectionViewController.collectionView setScrollEnabled:NO];
        [_collectionViewController setScollDataSource:self];
    }
}

#pragma mark - UICollectionViewDelegate and Data Source

/* These methods must not be overridden in Controller that inherits from this class */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/[collectionView numberOfItemsInSection:0]);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionViewController visibleItems].count;
}

#pragma mark - Gesture Holder methods

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (abs(translation.y) + 5.0f > abs(translation.x)) {
        _currentlyVisibleScreenSnapshot = [[UIImageView alloc] initWithImage:[self makeImageFromCurrentView]];
        [_currentlyVisibleScreenSnapshot setFrame:self.view.bounds];
        [_currentlyVisibleScreenSnapshot setHidden:YES];
        [self.view addSubview:_currentlyVisibleScreenSnapshot];
        return YES;
    }
    return NO;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    
    CGPoint translate = [sender translationInView:self.view];
    translate.y = translate.y * translationAccelerate;
    CGFloat boundsW = CGRectGetWidth(self.view.bounds);
    CGFloat boundsH = CGRectGetHeight(self.view.bounds);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            // reset all values
            _scrollDirection = BSScrollDirectionUnknown;
            _isOnTop = NO;
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            // Determinate Scroll Direction
            if (_scrollDirection == BSScrollDirectionUnknown) {
                _scrollDirection = translate.y < 0 ? BSScrollDirectionFromBottomToTop : BSScrollDirectionFromTopToBottom;
                // add snapshot on top
                [self addSnapshotViewOnTopWithDirection:_scrollDirection];
                _collectionHasItemsToShow = [_collectionViewController parentViewControllerWantsItemsForward:_scrollDirection == BSScrollDirectionFromTopToBottom ? NO : YES];
            }
            
            // If snapshot doesnt exist -> set isOnTop
            if (!_snapshotView) {
                _isOnTop = YES;
            }
            
            // Is on top and pulling to from top to bottom, gesture is driven by handlePanGestureToPullToRefresh
            if (_isOnTop && _scrollDirection == BSScrollDirectionFromTopToBottom) {
                return;
            }
            
            // pulling snapshotview
            else if (_collectionHasItemsToShow || abs(translate.y) < 50.0f) {
                
                if (_scrollDirection == BSScrollDirectionFromTopToBottom) {
                    CGRect newRect = CGRectMake(0, -boundsH + translate.y, boundsW, boundsH);
                    [_snapshotView setFrame:newRect];
                } else {
                    CGRect newRect = CGRectMake(0, translate.y, boundsW, boundsH);
                    [_snapshotView setFrame:newRect];
                }
                
            }
            if (!_collectionHasItemsToShow) {
                if (!self.collectionViewController.collectionView.isHidden) {
                    [self.collectionViewController.collectionView setHidden:YES];
                }
                
            }
            break;
            
        }
        case UIGestureRecognizerStateCancelled : {
            
            // gesture was canceled - snapshot view backs to start position
            // collection view has no more items to show, pangesture is available only for 50px
            if (!_collectionHasItemsToShow) {
                [UIView animateWithDuration:animationTime animations:^{
                    if (_scrollDirection == BSScrollDirectionFromBottomToTop) {
                        CGRect endRect = CGRectMake(0, 0, boundsW, boundsH);
                        [_snapshotView setFrame:endRect];
                    } else {
                        CGRect endRect = CGRectMake(0, -boundsH, boundsW, boundsH);
                        [_snapshotView setFrame:endRect];
                    }
                } completion:^(BOOL finished) {
                    if (self.collectionViewController.collectionView.isHidden) {
                        [self.collectionViewController.collectionView setHidden:NO];
                    }
                   [self removeSnapshotViewFromSuperView];
                }];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            // pull to refresh dragging, handled by handlePanGestureToPullToRefresh
            if (_isOnTop && _scrollDirection == BSScrollDirectionFromTopToBottom) {
                return;
            }
            
            // gesture is canceled and snapshot view backs to start frame
            if (!_collectionHasItemsToShow && !_isOnTop) {
                // prevents skip to next items
                translate.y = _scrollDirection == BSScrollDirectionFromBottomToTop ? -50.0f : 50.0f;
                sender.enabled = NO;
                sender.enabled = YES;
            }
            
            // finish animation when pulling from bottom to top and asbolute translation is bigger than minimum value to change page
            if (_scrollDirection == BSScrollDirectionFromBottomToTop && translate.y < - minTranslateYToSkip * boundsH) {
                
                [UIView animateWithDuration:animationTime animations:^{
                    CGRect endRect = CGRectMake(0, -boundsH, boundsW, boundsH);
                    [_snapshotView setFrame:endRect];
                } completion:^(BOOL finished) {
                    [_collectionViewController parentViewControllerDidFinishAnimatingForward:YES];
                    [_snapshotsArray addObject:_snapshotView.image];
                    [self removeSnapshotViewFromSuperView];
                }];
                
            }
            
            // finish animation when pulling from top to bottom and asbolute translation is bigger than minimum value to change page
            else if(_scrollDirection == BSScrollDirectionFromTopToBottom && translate.y > minTranslateYToSkip * boundsH) {
                
                [UIView animateWithDuration:animationTime animations:^{
                    CGRect endRect = CGRectMake(0, 0, boundsW, boundsH);
                    [_snapshotView setFrame:endRect];
                } completion:^(BOOL finished) {
                    [_collectionViewController parentViewControllerDidFinishAnimatingForward:NO];
                    [_snapshotsArray removeLastObject];
                    [self removeSnapshotViewFromSuperView];
                }];
                
            }
            // finish animation when absolute translation is smaller than minimum value, snapshotview backs to start frame
            else {
                [UIView animateWithDuration:animationTime animations:^{
                    if (_scrollDirection == BSScrollDirectionFromBottomToTop) {
                        CGRect endRect = CGRectMake(0, 0, boundsW, boundsH);
                        [_snapshotView setFrame:endRect];
                    } else {
                        CGRect endRect = CGRectMake(0, -boundsH, boundsW, boundsH);
                        [_snapshotView setFrame:endRect];
                    }
                } completion:^(BOOL finished) {
                    if (self.collectionViewController.collectionView.isHidden) {
                        [self.collectionViewController.collectionView setHidden:NO];
                    }
                    [_collectionViewController parentViewControllerWantsRollBack];
                    [self removeSnapshotViewFromSuperView];
                }];
                
            }
            break;
        }
        default:
            break;
    }
}


- (void)removeSnapshotViewFromSuperView {
    [_snapshotView removeFromSuperview];
    _snapshotView = nil;
}


- (void)addSnapshotViewOnTopWithDirection:(BSScrollDirection)direction {
    
    [self removeSnapshotViewFromSuperView];
    
    switch (direction) {
        case BSScrollDirectionFromBottomToTop:
            if (_currentlyVisibleScreenSnapshot) {
                _snapshotView = _currentlyVisibleScreenSnapshot;
                [_snapshotView setHidden:NO];
                break;
            }
            _snapshotView = [[UIImageView alloc] initWithImage:[self makeImageFromCurrentView]];
            [_snapshotView setFrame:self.view.bounds];
            break;
        case BSScrollDirectionFromTopToBottom:
            if ([_snapshotsArray lastObject]) {
                _snapshotView = [[UIImageView alloc] initWithImage:[_snapshotsArray lastObject]];
                [_snapshotView setFrame:CGRectMake(0, -CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
                [self.view addSubview:_snapshotView];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Screen Snapshot

- (UIImage *)makeImageFromCurrentView {
    CGSize imageSize = self.view.frame.size;

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.view.center.x, self.view.center.y);
    CGContextConcatCTM(context, self.view.transform);
    CGContextTranslateCTM(context, -self.view.bounds.size.width * self.view.layer.anchorPoint.x, -self.view.bounds.size.height * self.view.layer.anchorPoint.y);
    if ([self.view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    } else {
        [self.view.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
