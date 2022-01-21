# ASJCollectionViewFillLayout

The standard available `UICollectionViewLayout` does the job well, but the UI may look asymmetric, depending on the number of items the `UICollectionView` is displaying. This library attempts to solve this problem. This is a `UICollectionViewLayout` subclass that fills the full width of the collection view.

# Installation

CocoaPods is the preferred way to install this library. Add this command to your `Podfile`:

```ruby
pod 'ASJCollectionViewFillLayout'
```

If you prefer the classic way, just copy the `ASJCollectionViewFillLayout` folder (.h and .m files) to your project.

# Usage

Creating an `ASJCollectionViewFillLayout` is easy. It has a simple interface consisting of three properties. You can also use the traditional delegate pattern to return the attributes you wish to use. All are optional.

```objc
@property (assign, nonatomic) NSInteger numberOfItemsInSide;
```
Sets the number of items to show in one row or column, depending on the layout's `direction` property.

```objc
@property (assign, nonatomic) CGFloat itemLength;
```
Sets the width or height of an item, depending on the layout's `direction` property. For vertical direction, this sets the item height and for horizontal direction, this sets the item width.

```objc
@property (assign, nonatomic) CGFloat itemSpacing;
```
Sets the distance between two collection view items.

```objc
@property (assign, nonatomic) ASJCollectionViewFillLayoutDirection direction;
```
Sets the direction in which the collection view items are laid out. Valid options are `ASJCollectionViewFillLayoutVertical` and `ASJCollectionViewFillLayoutHorizontal`. Defaults to `ASJCollectionViewFillLayoutVertical`.

```objc
@property (assign, nonatomic) BOOL stretchesLastItems;
```
Sets whether the last items should be stretched to occupy the full width of the `UICollectionView`. Defaults to `YES`.

For example:

```objc
ASJCollectionViewFillLayout *aFillLayout = [[ASJCollectionViewFillLayout alloc] init];
aFillLayout.numberOfItemsInSide = 3;
aFillLayout.itemSpacing = 5.0f;
aFillLayout.itemLength = 75.0f;
aFillLayout.stretchesLastItems = NO;
aCollectionView.collectionViewLayout = aFillLayout;
```

See the example project for a demonstration of how to use the delegate pattern.

![alt tag](Images/7.png)
![alt tag](Images/8.png)

# Credits

- Damir Tursunovic - [Implementing UICollectionViewLayout](http://damir.me/implementing-uicollectionview-layout)
- [Oggerschummer](https://github.com/Oggerschummer) for adding `stretchesLastItems` property

# To-do

- ~~Handle case of total collection view items being less than the number of items in one row.~~
- ~~Add option for horizontal direction; try subclassing `UICollectionViewFlowLayout` itself.~~

# License

`ASJCollectionViewFillLayout` is available under the MIT license. See the LICENSE file for more info.
