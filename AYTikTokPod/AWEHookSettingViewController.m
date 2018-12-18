//
//  AWEHookSettingViewController.m
//  JPTikTokDylib
//
//  Created by AiJe on 2018/12/11.
//  Copyright © 2018 Unique. All rights reserved.
//

#import "AWEHookSettingViewController.h"


@interface AWEHookSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray<NSDictionary *>* areaLists;
@property (nonatomic, copy) NSArray *normalSettingTitle;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) BOOL isHookWaterMark;
@property (nonatomic, assign) BOOL isHookDownLoad;
@end

@implementation AWEHookSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    self.title = @"🎉TikTok🎉小插件";
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *resourcePath = [bundle pathForResource:@"AYTikTokPod" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:resourcePath];
    NSString *plistFile = [bundle pathForResource:@"countryCode" ofType:@"plist"];
    self.areaLists = [NSArray arrayWithContentsOfFile:plistFile];
    self.normalSettingTitle = @[@"移除下载限制", @"移除水印"];
    self.isHookDownLoad = [UserDefaults boolForKey:HookDownLoad];
    self.isHookWaterMark = [UserDefaults boolForKey:HookWaterMark];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, self.view.bounds.size.width - 30, 140)];
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.text = @"Author: @AYJk\nVersion: 1.2.0\nInfo: Have Fun🤣";
    infoLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:infoLabel];
    
    UITableView *areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:areaTableView];
    [areaTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"areaCell"];
    [areaTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalSettingCell"];
    areaTableView.delegate = self;
    areaTableView.dataSource = self;
    areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    areaTableView.tableFooterView = footerView;
    areaTableView.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *code = [areaDic objectForKey:@"code"];
    for (NSInteger index = 0; index < self.areaLists.count; index ++) {
        NSDictionary *dataDic = self.areaLists[index];
        if ([code isEqualToString:dataDic[@"code"]]) {
            self.selectedRow = index;
            break;
        }
    }
    [self configNaviItem];
}

- (void)configNaviItem {
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)saveAction {
    [UserDefaults setBool:self.isHookDownLoad forKey:HookDownLoad];
    [UserDefaults setBool:self.isHookWaterMark forKey:HookWaterMark];
    NSDictionary *areaDic = [UserDefaults objectForKey:HookArea];
    if (![areaDic isEqualToDictionary:self.areaLists[self.selectedRow]]) {
        [UserDefaults setObject:self.areaLists[self.selectedRow] forKey:HookArea];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"世界线已经发生变动！👹\n这一切都是命运石之门的选择！\n少年！加油吧！\n请重新打开TikTok开启冒险🎉" preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"El Psy Congroo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }]];
        [self presentViewController:alertCon animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchAction:(UISwitch *)sender {
    if (sender.tag == 1000) {
        self.isHookDownLoad = sender.isOn;
    } else if (sender.tag == 1001) {
        self.isHookWaterMark = sender.isOn;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalSettingCell" forIndexPath:indexPath];
        for (UIView *tempView in cell.contentView.subviews) {
            if ([tempView isMemberOfClass:[UISwitch class]]) {
                [tempView removeFromSuperview];
                break;
            }
        }
        UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 16 - 51, 4, 51, 31)];
        mySwitch.tag = 1000 + indexPath.row;
        [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:mySwitch];
        cell.textLabel.text = self.normalSettingTitle[indexPath.row];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
        if (indexPath.row == 0) {
            mySwitch.on = self.isHookDownLoad;
        } else if (indexPath.row == 1) {
            mySwitch.on = self.isHookWaterMark;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
        NSDictionary *dataDic = self.areaLists[indexPath.row];
        cell.textLabel.text = dataDic[@"area"];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
        cell.tintColor = [UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1];
        if (self.selectedRow == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 40)];
    [headerView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:13.0];
    titleLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.34];
    if (section == 0) {
        titleLabel.text = @"一般配置";
    } else if (section == 1) {
        titleLabel.text = @"国家/地区切换";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.normalSettingTitle.count;
    } else {
        return self.areaLists.count;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//    return footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.selectedRow = indexPath.row;
        [tableView reloadData];
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

@end
