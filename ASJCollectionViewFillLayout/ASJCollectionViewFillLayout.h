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

typedef NS_ENUM(NSInteger, ASJCollectionViewFillLayoutDirection)
{
    ASJCollectionViewFillLayoutVertical,
    ASJCollectionViewFillLayoutHorizontal
};

@protocol ASJCollectionViewFillLayoutDelegate <NSObject>

@optional

/**
 *  Sets the number of items in one row or column. For `ASJCollectionViewFillLayoutVertical`, the collection view will scroll vertically so this property refers to the item count in one row.
 *  Similarly, for `ASJCollectionViewFillLayoutHorizontal`, the collection view scrolls horizontally and this property refers to the item count in one column.
 *  In each case, the width or height for each item will be calculated accordingly.
 */
- (NSInteger)numberOfItemsInSide;

/**
 *  Sets the width or height for a collection view item, depending on the direction of the layout.
 *  By default, the direction is `ASJCollectionViewFillLayoutVertical` for which the item width will be calculated and the item height may vary.
 *  For `ASJCollectionViewFillLayoutVertical`, the item height will be calculated and the item width may vary.
 *  If `itemLength` is not set, it defaults to the calculated item width or height.
 */
- (CGFloat)itemLength;

/**
 *  Sets the 'inter-item spacing' between two collection
 *  view items. This will also set the padding between an
 *  item and the collection view boundary.
 */
- (CGFloat)itemSpacing;

@end

@interface ASJCollectionViewFillLayout : UICollectionViewLayout

/**
 *  Sets the number of items in one row or column. For `ASJCollectionViewFillLayoutVertical`, the collection view will scroll vertically so this property refers to the item count in one row.
 *  Similarly, for `ASJCollectionViewFillLayoutHorizontal`, the collection view scrolls horizontally and this property refers to the item count in one column.
 *  In each case, the width or height for each item will be calculated accordingly.
 */
@property (assign, nonatomic) NSInteger numberOfItemsInSide;

/**
 *  Sets the width or height for a collection view item, depending on the direction of the layout.
 *  By default, the direction is `ASJCollectionViewFillLayoutVertical` for which the item width will be calculated and the item height may vary.
 *  For `ASJCollectionViewFillLayoutVertical`, the item height will be calculated and the item width may vary.
 *  If `itemLength` is not set, it defaults to the calculated item width or height.
 */
@property (assign, nonatomic) CGFloat itemLength;

/**
 *  Sets the 'inter-item spacing' between two collection
 *  view items. This will also set the padding between an
 *  item and the collection view boundary.
 */
@property (assign, nonatomic) CGFloat itemSpacing;

/**
 *  Sets the height for the header. Defaults to 44.
 */
@property (assign, nonatomic) CGFloat headerHeight;

/**
 *  Sets the height for the footer. Defaults to 44.
 */
@property (assign, nonatomic) CGFloat footerHeight;

/**
 *  Arranges the collection view items vertically or horizontally. Defaults to `ASJCollectionViewFillLayoutVertical`.
 */
@property (assign, nonatomic) ASJCollectionViewFillLayoutDirection direction;

/**
 *  Sets the stretching behavior for the items in the last 'row' or 'column'.
 *  If set to NO all items will have the same size, YES stretches them
 *  across the collection view width or height (default behavior).
 */
@property (assign, nonatomic) BOOL stretchesLastItems;

/**
 *  The delegate for the fill layout. You must set this
 *  in order to use the methods defined in the protocol.
 */
@property (nullable, weak, nonatomic) id<ASJCollectionViewFillLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
