//
//  ViewController.m
//  ASJCollectionViewFillLayoutExample
//
//  Created by sudeep on 25/11/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import "ViewController.h"
#import "ASJCollectionViewFillLayout.h"

static NSInteger const kNoOfItems = 30;
static NSString *const reuseIdentifier = @"cell";

@interface ViewController () <ASJCollectionViewFillLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *aCollectionView;
@property (strong, nonatomic) ASJCollectionViewFillLayout *aLayout;
@property (copy, nonatomic) NSArray *objects;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionSegmentedControl;

- (void)setup;
- (void)setupCollectionViewData;
- (void)setupLayout;
- (IBAction)directionChanged:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark - Setup

- (void)setup
{
    [self setupCollectionViewData];
    [self setupLayout];
}

- (void)setupLayout
{
    _aLayout = [[ASJCollectionViewFillLayout alloc] init];
    _aLayout.delegate = self;
    _aLayout.direction = ASJCollectionViewFillLayoutVertical;
    _aCollectionView.collectionViewLayout = _aLayout;
}

- (void)setupCollectionViewData
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i=0; i<kNoOfItems; i++)
    {
        [temp addObject:[NSString stringWithFormat:@"Item %d", i+1]];
    }
    _objects = [NSArray arrayWithArray:temp];
}

- (IBAction)directionChanged:(id)sender
{
    NSInteger selectedSegmentIndex = _directionSegmentedControl.selectedSegmentIndex;
    _aLayout.direction = (ASJCollectionViewFillLayoutDirection)selectedSegmentIndex;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    lbl.text = _objects[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    }
    else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [NSString stringWithFormat:@"Item %ld tapped", (long)indexPath.row + 1];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tap" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ASJCollectionViewFillLayoutDelegate

- (NSInteger)numberOfItemsInSide
{
    return 3;
}

- (CGFloat)itemLength
{
    return 100.0f;
}

- (CGFloat)itemSpacing
{
    return 5.0f;
}

- (CGFloat)headerHeight
{
    return 160.0f;
}

- (CGFloat)footerHeight
{
    return 80.0f;
}

@end
