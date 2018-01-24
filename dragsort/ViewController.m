//
//  ViewController.m
//  dragsort
//
//  Created by 黄亚州 on 2018/1/24.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ViewController.h"
#import "DragSortManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDragSortTouchUpInside:(UIButton *)sender {
    [[DragSortManager sharedManager] openDragSortView:@"shelf" withSortDataSource:nil];
}

@end
