//
//  PSIViewerViewController.m
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "PSIViewerViewController.h"
#import "PSITableViewCell.h"
#import "RegionalPSI.h"
static NSString *cellIdentifier = @"PSITableViewCellIdentier";
@interface PSIViewerViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PSIViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)UIColorFromRGB(0x98DBC6).CGColor,
                        (id)UIColorFromRGB(0x5BC8AC).CGColor,
                        (id)UIColorFromRGB(0x98DBC6).CGColor
                        ];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_tableView registerClass:[PSITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"PSITableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _labelTop.text = [(RegionalPSI *)_psiInfos.firstObject timeStamp];
    [_tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _psiInfos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PSITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    RegionalPSI *psiInfo = _psiInfos[indexPath.row];
    if (cell){
        cell.lbRegion.text = psiInfo.region.capitalizedString;
        cell.lbPSI24.text = ((NSNumber*)[psiInfo.psiValues objectForKey:@"psi_three_hourly"]).stringValue;
        cell.lbPSI3.text = ((NSNumber*)[psiInfo.psiValues objectForKey:@"psi_twenty_four_hourly"]).stringValue;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PSITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell){
        cell.lbRegion.text = @"Region";
        cell.lbPSI24.text = @"24h PSI";
        cell.lbPSI3.text = @"3h PSI";
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.bounds)-10.0f, CGRectGetWidth(cell.bounds), 0.5f)];
        line.backgroundColor = [UIColor whiteColor];
        [cell addSubview:line];
    }
    return cell;
}
- (IBAction)btnBackTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
