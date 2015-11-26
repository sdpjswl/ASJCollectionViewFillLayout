//
//  ASJCollectionViewFillLayout.m
//  ASJCollectionViewFillLayout
//
//  Created by sudeep on 11/25/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJCollectionViewFillLayout.h"

// Thanks to: http://damir.me/implementing-uicollectionview-layout

@interface ASJCollectionViewFillLayout ()

@property (nonatomic) CGSize contentSize;
@property (copy, nonatomic) NSIndexSet *extraIndexes;
@property (copy, nonatomic) NSArray *itemAttributes;

- (void)setupDefaults;

@end

@implementation ASJCollectionViewFillLayout

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self setupDefaults];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setupDefaults];
  }
  return self;
}

- (void)setupDefaults
{
  self.numberOfItemsInRow = 3;
  self.itemHeight = 75.0;
  self.itemSpacing = 8.0;
}

#pragma mark - Overrides

- (void)prepareLayout
{
  [super prepareLayout];
  
  // read values from delegate if present
  if ([_delegate respondsToSelector:@selector(numberOfItemsInRow)]) {
    _numberOfItemsInRow = [_delegate numberOfItemsInRow];
  }
  if ([_delegate itemHeight]) {
    _itemHeight = [_delegate itemHeight];
  }
  if ([_delegate itemSpacing]) {
    _itemSpacing = [_delegate itemSpacing];
  }
  
  NSUInteger column = 0;
  CGFloat xOffset = _itemSpacing;
  CGFloat yOffset = _itemSpacing;
  CGFloat rowHeight = 0.0;
  CGFloat contentWidth = 0.0;
  CGFloat contentHeight = 0.0;
  
  // store items of any extra items, if present
  NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
  NSInteger extraItems = numberOfItems % _numberOfItemsInRow;
  
  if (extraItems > 0)
  {
    NSMutableIndexSet *temp = [[NSMutableIndexSet alloc] init];
    for (int i=0; i < extraItems; i++)
    {
      NSInteger rowNo = (numberOfItems - 1) - i;
      [temp addIndex:rowNo];
    }
    _extraIndexes = temp;
  }
  
  NSMutableArray *tempAttributes = [[NSMutableArray alloc] init];
  for (int i=0; i < numberOfItems; i++)
  {
    // calculate item size. extra items will have different widths
    CGSize itemSize = CGSizeZero;
    if (_extraIndexes.count && [_extraIndexes containsIndex:i])
    {
      CGFloat availableSpaceForItems = self.collectionView.bounds.size.width - (2 * _itemSpacing) - ((_extraIndexes.count - 1) * _itemSpacing);
      CGFloat itemWidth = availableSpaceForItems / _extraIndexes.count;
      itemSize = CGSizeMake(itemWidth, _itemHeight);
    }
    else
    {
      CGFloat availableSpaceForItems = self.collectionView.bounds.size.width - (2 * _itemSpacing) - ((_numberOfItemsInRow - 1) * _itemSpacing);
      CGFloat itemWidth = availableSpaceForItems / _numberOfItemsInRow;
      itemSize = CGSizeMake(itemWidth, _itemHeight);
    }
    
    if (itemSize.height > rowHeight) {
      rowHeight = itemSize.height;
    }
    
    // create layout attributes objects
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
    [tempAttributes addObject:attributes];
    
    // move 'x' for next item
    xOffset = xOffset + itemSize.width + _itemSpacing;
    column++;
    
    // if item was the last one in current row
    if (column == _numberOfItemsInRow)
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
  
  // calculate content height
  UICollectionViewLayoutAttributes *attributes = tempAttributes.lastObject;
  contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
  _contentSize = CGSizeMake(contentWidth, contentHeight);
  _itemAttributes = [NSArray arrayWithArray:tempAttributes];
  self.collectionView.alwaysBounceVertical = YES;
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
  return [_itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
    return CGRectIntersectsRect(rect, evaluatedObject.frame);
  }]];
}

#pragma mark - Property setters

- (void)setNumberOfItemsInRow:(NSInteger)numberOfItemsInRow
{
  if (_numberOfItemsInRow != numberOfItemsInRow) {
    _numberOfItemsInRow = numberOfItemsInRow;
    [self invalidateLayout];
  }
}

- (void)setItemHeight:(CGFloat)itemHeight
{
  if (_itemHeight != itemHeight) {
    _itemHeight = itemHeight;
    [self invalidateLayout];
  }
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
  if (_itemSpacing != itemSpacing) {
    _itemSpacing = itemSpacing;
    [self invalidateLayout];
  }
}

@end
