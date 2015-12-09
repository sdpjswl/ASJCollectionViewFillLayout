//
//  ASJCollectionViewFillLayout.h
//  ASJCollectionViewFillLayout
//
//  Created by sudeep on 11/25/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import UIKit;

@protocol ASJCollectionViewFillLayoutDelegate <NSObject>

- (NSInteger)numberOfItemsInRow;
- (CGFloat)itemHeight;
- (CGFloat)itemSpacing;

@end

@interface ASJCollectionViewFillLayout : UICollectionViewLayout

@property (nonatomic) NSInteger numberOfItemsInRow;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemSpacing;
@property (weak, nonatomic) id<ASJCollectionViewFillLayoutDelegate> delegate;

@end
