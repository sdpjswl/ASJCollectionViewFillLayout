//
//  ViewController.m
//  ASJCollectionViewFillLayoutExample
//
//  Created by sudeep on 25/11/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import "ViewController.h"
#import "ASJCollectionViewFillLayout.h"

static NSInteger const kNoOfItems = 20;
static NSString *const reuseIdentifier = @"cell";

@interface ViewController () <ASJCollectionViewFillLayoutDelegate> {
  IBOutlet UICollectionView *aCollectionView;
}

@property (copy, nonatomic) NSArray *objects;

- (void)setup;
- (void)setupCollectionViewData;
- (void)setupLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setup
{
  [self setupCollectionViewData];
  [self setupLayout];
}

- (void)setupLayout
{
  ASJCollectionViewFillLayout *myLayout = [[ASJCollectionViewFillLayout alloc] init];
  myLayout.delegate = self;
  aCollectionView.collectionViewLayout = myLayout;
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
  NSString *message = [NSString stringWithFormat:@"Item %d tapped", indexPath.row + 1];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

#pragma mark - ASJCollectionViewFillLayoutDelegate

- (NSInteger)numberOfItemsInRow
{
  return 3;
}

- (CGFloat)itemHeight
{
  return 70.0;
}

- (CGFloat)itemSpacing
{
  return 5.0;
}

@end
