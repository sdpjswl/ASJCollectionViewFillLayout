//
//  ViewController.m
//  ASJCollectionViewFillLayoutExample
//
//  Created by sudeep on 25/11/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import "ViewController.h"
#import "ASJCollectionViewFillLayout.h"

static NSInteger const kNoOfItems = 14;
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

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *message = [NSString stringWithFormat:@"Item %ld tapped", (long)indexPath.row + 1];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

#pragma mark - ASJCollectionViewFillLayoutDelegate

- (NSInteger)numberOfItemsInRow
{
  return 3;
}

- (CGFloat)itemSpacing
{
  return 5.0f;
}

@end
