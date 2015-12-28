//
//  ViewController.m
//  StackedTableViewDemo
//
//  Created by caiwenshu on 4/9/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import "ViewController.h"
#import "TranbStackedView.h"

@interface ViewController () <TranbStackedViewDelegate>

@property(nonatomic,strong) TranbStackedView *tranbStackedView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initSubComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSubComponents
{
    self.tranbStackedView = [[TranbStackedView alloc] initWithFrame:self.view.bounds];
    self.tranbStackedView.delegate = self;
    [self.view addSubview:self.tranbStackedView];
    
    //格式化测试1
    //格式化测试2
    NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:@"Industry" ofType:@"json"];
    
    NSData *data =  [NSData dataWithContentsOfFile:sourceFilePath options:NSDataReadingMapped error:nil];
    
    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *array = [[json valueForKey:@"Result"] valueForKey:@"result"];
    
    
    [self.tranbStackedView refreshData:array selectedCode:nil];
}

#pragma mark - TranbStackedViewDelegate
- (void)tranbStackedViewDidSelectedObjcet:(NSObject *)obj
{
    NSLog(@"IUCode:%@,name:%@",[obj valueForKey:@"IUCode"], [obj valueForKey:@"name"]);
}

@end
