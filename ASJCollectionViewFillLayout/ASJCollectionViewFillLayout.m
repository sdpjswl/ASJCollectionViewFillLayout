//
//  ASJCollectionViewFillLayout.m
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

#import "ASJCollectionViewFillLayout.h"

// Thanks: http://damir.me/implementing-uicollectionview-layout

@interface ASJCollectionViewFillLayout ()

@property (readonly, nonatomic) NSInteger numberOfItemsInCollectionView;
@property (assign, nonatomic) CGSize contentSize;
@property (copy, nonatomic) NSIndexSet *extraIndexes;
@property (copy, nonatomic) NSArray *itemAttributes;
@property (readonly, weak, nonatomic) NSNotificationCenter *notificationCenter;

- (void)setup;
- (void)setupDefaults;
- (void)prepareVerticalLayout;
- (void)prepareHorizontalLayout;

@end

@implementation ASJCollectionViewFillLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    [self setupDefaults];
    [self listenForOrientationChanges];
}

- (void)setupDefaults
{
    self.numberOfItemsInSide = 1;
    self.itemSpacing = 8.0f;
    self.headerHeight = 44.0f;
    self.footerHeight = 44.0f;
    self.direction = ASJCollectionViewFillLayoutVertical;
    self.stretchesLastItems = YES;
}

#pragma mark - Orientation

- (void)listenForOrientationChanges
{
    [self.notificationCenter addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)note
{
    [self invalidateLayout];
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

- (NSNotificationCenter *)notificationCenter
{
    return [NSNotificationCenter defaultCenter];
}

#pragma mark - Overrides

- (void)prepareLayout
{
    [super prepareLayout];
    
    // read values from delegate if available
    if ([_delegate respondsToSelector:@selector(numberOfItemsInSide)])
    {
        _numberOfItemsInSide = [_delegate numberOfItemsInSide];
    }
    if ([_delegate respondsToSelector:@selector(itemLength)])
        NSAssert(_numberOfItemsInSide > 0, @"Collection view must have at least one item in row. Set 'numberOfItemsInSide'.");
    
    if ([_delegate respondsToSelector:@selector(itemLength)])
    {
        _itemLength = [_delegate itemLength];
    }
    if ([_delegate respondsToSelector:@selector(itemSpacing)])
    {
        _itemSpacing = [_delegate itemSpacing];
    }
    
    _itemAttributes = nil;
    _extraIndexes = nil;
    _contentSize = CGSizeZero;
    
    // store indexes of any extra items, if present
    NSInteger numberOfItems = self.numberOfItemsInCollectionView;
    NSInteger extraItems = numberOfItems % _numberOfItemsInSide;
    
    if (extraItems > 0)
    {
        NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
        for (int i=0; i<extraItems; i++)
        {
            NSInteger idx = (numberOfItems - 1) - i;
            [indexes addIndex:idx];
        }
        _extraIndexes = indexes;
    }
    
    if (_direction == ASJCollectionViewFillLayoutVertical) {
        [self prepareVerticalLayout];
    }
    else {
        [self prepareHorizontalLayout];
    }
}

- (void)prepareVerticalLayout
{
    CGFloat xOffset = _itemSpacing;
    CGFloat yOffset = _itemSpacing;
    CGFloat rowHeight = 0.0f;
    CGFloat contentWidth = 0.0f;
    CGFloat contentHeight = 0.0f;
    NSUInteger column = 0;
    NSInteger numberOfItems = self.numberOfItemsInCollectionView;
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    // header
    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    headerAttributes.frame = CGRectMake(0.0, 0.0, self.collectionView.bounds.size.width, _headerHeight);
    [layoutAttributes addObject:headerAttributes];
    
    // update y
    yOffset += _headerHeight;
    
    for (int i = 0; i < numberOfItems; i++)
    {
        CGFloat itemWidth = 0.0f;
        
        // calculate item size. extra items will have different widths
        if (_stretchesLastItems && _extraIndexes.count && [_extraIndexes containsIndex:i])
        {
            CGFloat availableSpaceForItems = self.collectionView.bounds.size.width - (2 * _itemSpacing) - ((_extraIndexes.count - 1) * _itemSpacing);
            itemWidth = availableSpaceForItems / _extraIndexes.count;
        }
        else
        {
            CGFloat availableSpaceForItems = self.collectionView.bounds.size.width - (2 * _itemSpacing) - ((_numberOfItemsInSide - 1) * _itemSpacing);
            itemWidth = availableSpaceForItems / _numberOfItemsInSide;
        }
        
        // by default, item height is equal to item width
        // if not setting default item width
        if (!_itemLength) {
            _itemLength = itemWidth;
        }
        CGSize itemSize = CGSizeMake(itemWidth, _itemLength);
        
        if (itemSize.height > rowHeight) {
            rowHeight = itemSize.height;
        }
        
        // create layout attributes objects
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
        [layoutAttributes addObject:attributes];
        
        // move 'x' for next item
        xOffset = xOffset + itemSize.width + _itemSpacing;
        column++;
        
        // if item was the last one in current row
        // special case handled for when number of items is lesser than
        // number of items in row
        if ((numberOfItems < _numberOfItemsInSide && column == numberOfItems) ||
            (column == _numberOfItemsInSide))
        {
            if (xOffset > contentWidth) {
                contentWidth = xOffset;
            }
            
            // reset
            column = 0;
            xOffset = _itemSpacing;
            yOffset += rowHeight + _itemSpacing;
        }
    }
    
    // update y
    yOffset += rowHeight + _itemSpacing;
    
    // footer
    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    footerAttributes.frame = CGRectMake(0.0, yOffset, self.collectionView.bounds.size.width, _footerHeight);
    [layoutAttributes addObject:footerAttributes];
    
    // calculate content height
    UICollectionViewLayoutAttributes *lastAttributes = layoutAttributes.lastObject;
    contentHeight = lastAttributes.frame.origin.y + lastAttributes.frame.size.height;
    _contentSize = CGSizeMake(contentWidth, contentHeight);
    _itemAttributes = [NSArray arrayWithArray:layoutAttributes];
}

- (void)prepareHorizontalLayout
{
    CGFloat xOffset = _itemSpacing;
    CGFloat yOffset = _itemSpacing;
    CGFloat columnWidth = 0.0f;
    CGFloat contentWidth = 0.0f;
    CGFloat contentHeight = 0.0f;
    NSUInteger row = 0;
    NSInteger numberOfItems = self.numberOfItemsInCollectionView;
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    // header
    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    headerAttributes.frame = CGRectMake(0.0, 0.0, _headerHeight, self.collectionView.bounds.size.height);
    //  [layoutAttributes addObject:headerAttributes];
    
    // update x
    //  xOffset += _headerHeight + _itemSpacing;
    
    for (int i = 0; i < numberOfItems; i++)
    {
        CGFloat itemHeight = 0.0f;
        
        // calculate item size. extra items will have different heights
        if (_stretchesLastItems && _extraIndexes.count && [_extraIndexes containsIndex:i])
        {
            CGFloat availableSpaceForItems = self.collectionView.bounds.size.height - (2 * _itemSpacing) - ((_extraIndexes.count - 1) * _itemSpacing);
            itemHeight = availableSpaceForItems / _extraIndexes.count;
        }
        else
        {
            CGFloat availableSpaceForItems = self.collectionView.bounds.size.height - (2 * _itemSpacing) - ((_numberOfItemsInSide - 1) * _itemSpacing);
            itemHeight = availableSpaceForItems / _numberOfItemsInSide;
        }
        
        // by default, item height is equal to item width
        // if not setting default item height
        if (!_itemLength) {
            _itemLength = itemHeight;
        }
        CGSize itemSize = CGSizeMake(_itemLength, itemHeight);
        
        if (itemSize.width > columnWidth) {
            columnWidth = itemSize.width;
        }
        
        // create layout attributes objects
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
        [layoutAttributes addObject:attributes];
        
        // move 'y' for next item
        yOffset = yOffset + itemSize.height + _itemSpacing;
        row++;
        
        // if item was the last one in current column
        // special case handled for when number of items is lesser than
        // number of items in row
        if ((numberOfItems < _numberOfItemsInSide && row == numberOfItems) ||
            (row == _numberOfItemsInSide))
        {
            if (xOffset > contentWidth) {
                contentWidth = xOffset;
            }
            
            // reset
            row = 0;
            yOffset = _itemSpacing;
            xOffset += columnWidth + _itemSpacing;
        }
        
        // update x
        xOffset += columnWidth + _itemSpacing;
        
        // footer
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        footerAttributes.frame = CGRectMake(xOffset, 0.0, _footerHeight, self.collectionView.bounds.size.height);
        //    [layoutAttributes addObject:footerAttributes];
        
        // calculate content width
        UICollectionViewLayoutAttributes *lastAttributes = layoutAttributes.lastObject;
        contentWidth = lastAttributes.frame.origin.x + lastAttributes.frame.size.width;
        _contentSize = CGSizeMake(contentWidth, contentHeight);
        _itemAttributes = [NSArray arrayWithArray:layoutAttributes];
    }
}

#pragma mark - Property getters

- (NSInteger)numberOfItemsInCollectionView
{
    if (self.collectionView.numberOfSections >0){
        return [self.collectionView numberOfItemsInSection:0];
    }else{
        //Avoid crash if no sections are available
        return 0;
    }
}

- (CGSize)collectionViewContentSize
{
    return _contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemAttributes[indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings)
                              {
        return CGRectIntersectsRect(rect, evaluatedObject.frame);
    }];
    return [_itemAttributes filteredArrayUsingPredicate:predicate];
}

#pragma mark - Property setters

- (void)setNumberOfItemsInSide:(NSInteger)numberOfItemsInSide
{
    if (_numberOfItemsInSide != numberOfItemsInSide)
    {
        _numberOfItemsInSide = numberOfItemsInSide;
        [self invalidateLayout];
    }
}

- (void)setItemLength:(CGFloat)itemLength
{
    if (_itemLength != itemLength)
    {
        _itemLength = itemLength;
        [self invalidateLayout];
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    if (_itemSpacing != itemSpacing)
    {
        _itemSpacing = itemSpacing;
        [self invalidateLayout];
    }
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    if (_headerHeight != headerHeight)
    {
        _headerHeight = headerHeight;
        [self invalidateLayout];
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    if (_footerHeight != footerHeight)
    {
        _footerHeight = footerHeight;
        [self invalidateLayout];
    }
}

- (void)setDirection:(ASJCollectionViewFillLayoutDirection)direction
{
    if (_direction != direction)
    {
        _direction = direction;
        [self invalidateLayout];
    }
}

@end
