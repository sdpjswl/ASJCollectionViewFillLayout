//
//  ASJCollectionViewFillLayout.h
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol ASJCollectionViewFillLayoutDelegate <NSObject>

@optional
- (NSInteger)numberOfItemsInRow;
- (CGFloat)itemHeight;
- (CGFloat)itemSpacing;

@end

@interface ASJCollectionViewFillLayout : UICollectionViewLayout

/**
 *  Sets the number of items in one row. The width for
 *  each item will be calculated accordingly.
 */
@property (assign, nonatomic) NSInteger numberOfItemsInRow;

/**
 *  Sets the height for a collection view item. By default, the height is set the same as the width that is calculated.
 */
@property (assign, nonatomic) CGFloat itemHeight;

/**
 *  Sets the "inter-item spacing" between two collection
 *  view items. This will also set the padding between an
 *  item and the collection view boundary.
 */
@property (assign, nonatomic) CGFloat itemSpacing;

/**
 *  The delegate for the fill layout. You must set this
 *  in order to use the methods defined in the protocol.
 */
@property (nullable, weak, nonatomic) id<ASJCollectionViewFillLayoutDelegate> delegate;

/**
 *  Set the stretching behavior for the items in the last "row"
 *  If set to NO all items will have the same size, YES stretches them 
 *  across the colleciton view width (default behavior)
 */
@property (assign, nonatomic) BOOL stretchesLastItems;

@end

NS_ASSUME_NONNULL_END
