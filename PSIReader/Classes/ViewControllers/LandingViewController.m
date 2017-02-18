//
//  LandingViewController.m
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "LandingViewController.h"
#import "PSITableViewCell.h"
#import "RegionalPSI.h"
#import "BackendConnector.h"
#import "LMPullToBounceWrapper.h"
#import "MBProgressHUD.h"
#import "DataController.h"

static NSString *cellIdentifier = @"PSITableViewCellIdentier";
static NSString *kKeyLastestPSIInfos = @"regionalPSIInfosKey";

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LandingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSArray *regionalPSIInfos;
}
@end

@implementation LandingViewController

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
    _tablePSIResult.backgroundColor = [UIColor clearColor];
    _tablePSIResult.backgroundView = nil;

    _tablePSIResult.delegate = self;
    _tablePSIResult.dataSource = self;
    [_tablePSIResult registerClass:[PSITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tablePSIResult registerNib:[UINib nibWithNibName:@"PSITableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    
}
- (void)displayLatestResult{
    regionalPSIInfos = [[DataController sharedController] getLatesPSI];
    if (regionalPSIInfos){
        NSDate *lastResultTime = ((RegionalPSI *)regionalPSIInfos.firstObject).time;
        _lbDateTime.text = [NSString stringWithFormat:@"Last Result: %@", [self stringFromDate:lastResultTime]];
        [_tablePSIResult reloadData];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    //Load the local data
    [self displayLatestResult];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    NSString *dateTimeString = [dateFormatter stringFromDate:date];
    return dateTimeString;
}
- (void)hudWasCancelled {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)fetchPSIData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Getting data";
    hud.detailsLabel.text = @"Tap to cancel";
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudWasCancelled)]];
    [[DataController sharedController] getCurrentPSIWithResponse:^(BOOL success, NSString *message, NSArray *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success){
            [self displayLatestResult];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%@\nDo you want to retry?", message]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Retry", nil
                                  ];
            [alert show];
        }
    }];
}
- (IBAction)btnRefreshTapped:(id)sender {
    [self fetchPSIData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return regionalPSIInfos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PSITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    RegionalPSI *psiInfo = regionalPSIInfos[indexPath.row];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0){
        [self fetchPSIData];
    }
}
@end
