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
static NSString *cellIdentifier = @"PSITableViewCellIdentier";
static NSString *kKeyLastestPSIInfos = @"regionalPSIInfos";
@interface LandingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSArray *regionalPSIInfos;
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
    
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyLastestPSIInfos];
    regionalPSIInfos = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    //Load the local data
    if (regionalPSIInfos){
        NSDate *lastResultTime = ((RegionalPSI *)regionalPSIInfos.firstObject).time;
        _lbDateTime.text = [NSString stringWithFormat:@"Last Result: %@", [self stringFromDate:lastResultTime]];
        [_tablePSIResult reloadData];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    NSDate *currentTime = [NSDate date];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Getting data";
    hud.detailsLabel.text = @"Tap to cancel";
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudWasCancelled)]];
    [[BackendConnector sharedConnector] getPSIForDateTime:currentTime
                                                 response:^(BOOL success, NSString *message, NSArray *result) {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     if (success){
                                                         regionalPSIInfos = result;

                                                         NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:regionalPSIInfos];
                                                         [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:kKeyLastestPSIInfos];
                                                         
                                                         _lbDateTime.text = [NSString stringWithFormat:@"Last Result: %@", [self stringFromDate:currentTime]];
                                                         [_tablePSIResult reloadData];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0){
        [self fetchPSIData];
    }
}
@end
