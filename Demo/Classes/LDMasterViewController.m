//
//  LDMasterViewController.m
//  LivelyDemo
//
//  Created by Romain Goyet on 24/04/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import "LDMasterViewController.h"
#import "LDCollectionViewCell.h"
#import "ADLivelyCollectionView.h"

@implementation LDMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ADLivelyDemo";
        _objects = [[NSMutableArray alloc] init];
        for (int i = 0; i < 200; i++) {
            [(NSMutableArray *)_objects addObject:[NSString stringWithFormat:@"#%d", i]];
        }
    }
    return self;
}
							
- (void)dealloc {
    [_objects release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * transitionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pickTransform:)];
    self.navigationItem.rightBarButtonItem = transitionButton;
    ADLivelyCollectionView * livelyTableView = (ADLivelyCollectionView *)self.view;
    [livelyTableView registerNib:[UINib nibWithNibName:@"LDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
    [transitionButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pickTransform:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a transform"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Fan", @"Curl", @"Fade", @"Helix", @"Wave", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    [actionSheet release];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ADLivelyCollectionView * livelyTableView = (ADLivelyCollectionView *)self.view;
    NSArray * transforms = [NSArray arrayWithObjects:ADLivelyTransformFan, ADLivelyTransformCurl, ADLivelyTransformFade, ADLivelyTransformHelix, ADLivelyTransformWave, nil];

    if (buttonIndex < [transforms count]) {
        livelyTableView.initialCellTransformBlock = [transforms objectAtIndex:buttonIndex];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"Cell";
    
    LDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell.backgroundView) {
        UIView * backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        [backgroundView release];
    }

    cell.textLabel.text = [_objects objectAtIndex:indexPath.row];

    UIColor * altBackgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    cell.backgroundView.backgroundColor = [indexPath row] % 2 == 0 ? [UIColor whiteColor] : altBackgroundColor;
    cell.textLabel.backgroundColor = cell.backgroundView.backgroundColor;

    return cell;
}
@end
