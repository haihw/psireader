//
//  LandingViewController.m
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "LandingViewController.h"
#import "PSITableViewCell.h"
static NSString *cellIdentifier = @"PSITableViewCellIdentier";

@interface LandingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *psiResult;
}
@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tablePSIResult.delegate = self;
    _tablePSIResult.dataSource = self;
    [_tablePSIResult registerClass:[PSITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tablePSIResult registerNib:[UINib nibWithNibName:@"PSITableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)fetchPSIData{
    [_tablePSIResult reloadData];
}
- (IBAction)btnRefreshTapped:(id)sender {
    [self fetchPSIData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    return psiResult.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PSITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell){
        cell.lbRegion.text = @"National";
        cell.lbPSI24.text = @"111";
        cell.lbPSI3.text = @"222";
    }
    return cell;
}
@end
