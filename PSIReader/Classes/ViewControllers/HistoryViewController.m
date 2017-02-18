//
//  HistoryViewController.m
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "HistoryViewController.h"
#import "RegionalPSI.h"
#import "DataController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HistoryViewController

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

    _psiRecords = [[DataController sharedController] getAllPSIRecords];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _psiRecords.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *psiInfo = _psiRecords[_psiRecords.count - indexPath.row - 1];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [(RegionalPSI *) psiInfo.firstObject timeStamp];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *psiInfo = _psiRecords[_psiRecords.count - indexPath.row - 1];
    //show
    
}
- (IBAction)btnBackTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
