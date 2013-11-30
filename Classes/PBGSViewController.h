//
//  BSViewController.h
//  BScrollController
//
//  Created by Piotr Bernad on 09.10.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBGSCollectionViewController.h"

@interface PBGSViewController : UIViewController <PBGSDataSource,UICollectionViewDataSource, UICollectionViewDelegate>

- (void)setCollectionViewController:(PBGSCollectionViewController *)controller;

@property (strong, nonatomic) PBGSCollectionViewController *collectionViewController;
@property (assign, nonatomic) NSInteger numberOfItemsPerPage;
@end
