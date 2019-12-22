//
//  ViewController.m
//  LeftAlignCollectionViewPractice
//
//  Created by pinyuan on 2019/11/17.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ViewController.h"
#import "TagCollectionViewCell.h"

#define CollectionViewPadding 30.0
#define LabelToCellPadding 48.0
#define TAGS_PLIST_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"tags.plist"]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *aryItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *aryTemp = [[NSMutableArray alloc] initWithContentsOfFile:TAGS_PLIST_PATH];
    self.aryItems = aryTemp?:[NSMutableArray new];
    self.inputTextField.delegate = self;
    self.inputTextField.placeholder = @"Add a tag here";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.inputTextField];
    self.btnAdd.enabled = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (IBAction)didPressedBtnAdd:(id)sender {
    if (![self.aryItems containsObject:self.inputTextField.text]) {
        [self.aryItems addObject:self.inputTextField.text];
        [self.aryItems writeToFile:TAGS_PLIST_PATH atomically:YES];
        self.inputTextField.text = @"";
        self.btnAdd.enabled = NO;
        [self.collectionView reloadData];
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma UICollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.aryItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagCollectionViewCell *cell = (TagCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    CGFloat labelWidth = cell.tagLabelTitle.frame.size.width;
    if (labelWidth + LabelToCellPadding > CGRectGetWidth(collectionView.frame) - CollectionViewPadding) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - CollectionViewPadding , 44.0);
    } else {
        return CGSizeMake(labelWidth + LabelToCellPadding , 44.0);
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = (TagCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureCell: (TagCollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    NSString *strTag = [_aryItems objectAtIndex:indexPath.row];
    cell.tagDeleteButton.tag = indexPath.row;
    [cell.tagDeleteButton addTarget:self action:@selector(onDeleteTag:) forControlEvents:UIControlEventTouchUpInside];
    cell.tagBackgroundView.clipsToBounds = YES;
    cell.tagBackgroundView.layer.cornerRadius = cell.tagBackgroundView.frame.size.height/2;
    cell.tagLabelTitle.text = strTag;
    [cell.tagLabelTitle sizeToFit];
}

#pragma UITextField Delegate

- (void)textFieldDidChange:(NSNotification *) notification
{
    UITextField *edit = (UITextField*)notification.object;
    self.btnAdd.enabled = (0 < edit.text.length);
}

#pragma Private Functions

- (void)onDeleteTag:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [self.aryItems removeObjectAtIndex:btn.tag];
    [self.aryItems writeToFile:TAGS_PLIST_PATH atomically:YES];
    [self.collectionView reloadData];
}


@end
