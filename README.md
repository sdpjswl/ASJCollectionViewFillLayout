ASJCollectionViewFillLayout
===========================

The standard available UICollectionViewLayout does the job well, but the UI may look asymmetric, depending on the number of items the collection view is displaying. This small layout class attempts to solve this problem. This is a UICollectionViewLayout that fills the full width of the collection view.

# Usage

Creating an ASJCollectionViewFillLayout is easy. It has a simple interface consisting of three properties. You can also use the traditional delegate way to return the attributes you wish to use.

```
@property (nonatomic) NSInteger numberOfItemsInRow;
```
Sets the number of items to show in one row.

```
@property (nonatomic) CGFloat itemHeight;
```
Sets the height of an item. The width will be calculated to fill the view.

```
@property (nonatomic) CGFloat itemSpacing;
```
Sets the distance between two collection view items.

![alt tag](Images/19.png)
![alt tag](Images/20.png)
![alt tag](Images/21.png)

###To-do
- ~~Handle case of total collection view items being less than the number of items in one row~~

# License

ASJCollectionViewFillLayout is available under the MIT license. See the LICENSE file for more info.
