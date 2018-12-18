//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  AYTikTokPod.m
//  AYTikTokPod
//
//  Created by AiJe on 2018/12/18.
//  Copyright (c) 2018 AYJk. All rights reserved.
//

#import "AYTikTokPod.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AWEHookSettingViewController.h"
#define HOOK_MENU_TITLE @"🎉TikTok🎉小插件"
#define HookInitAreaValue @{@"area": @"日本🇯🇵", @"code": @"JP", @"mcc": @"440", @"mnc": @"01"}

@interface AWESettingSectionModel

@property(copy, nonatomic) NSString *sectionFooterTitle; // @synthesize sectionFooterTitle=_sectionFooterTitle;
@property(retain, nonatomic) NSArray *itemArray; // @synthesize itemArray=_itemArray;
@property(nonatomic) double sectionHeaderHeight; // @synthesize sectionHeaderHeight=_sectionHeaderHeight;
@property(copy, nonatomic) NSString *sectionHeaderTitle; // @synthesize sectionHeaderTitle=_sectionHeaderTitle;
@property(nonatomic) long long type; // @synthesize type=_type;

@end


@interface AWESettingItemModel: NSObject

@property(copy, nonatomic) id cellRefreshBlock; // @synthesize cellRefreshBlock=_cellRefreshBlock;
@property(copy, nonatomic) id switchChangedBlock; // @synthesize switchChangedBlock=_switchChangedBlock;
@property(copy, nonatomic) void(^cellTappedBlock)(void); // @synthesize cellTappedBlock=_cellTappedBlock;
@property(nonatomic) double cellHeight; // @synthesize cellHeight=_cellHeight;
@property(nonatomic) long long dotType; // @synthesize dotType=_dotType;
@property(nonatomic) _Bool showDotView; // @synthesize showDotView=_showDotView;
@property(nonatomic) _Bool isEnable; // @synthesize isEnable=_isEnable;
@property(nonatomic) _Bool isSwitchOn; // @synthesize isSwitchOn=_isSwitchOn;
@property(nonatomic) long long cellType; // @synthesize cellType=_cellType;
@property(copy, nonatomic) NSString *iconImageName; // @synthesize iconImageName=_iconImageName;
@property(copy, nonatomic) NSString *detail; // @synthesize detail=_detail;
@property(copy, nonatomic) NSString *fancySubtitle; // @synthesize fancySubtitle=_fancySubtitle;
@property(copy, nonatomic) NSString *subTitle; // @synthesize subTitle=_subTitle;
@property(copy, nonatomic) NSString *title; // @synthesize title=_title;
@property(nonatomic) long long type; // @synthesize type=_type;

@end

@interface AWESettingsViewModel

@property (nonatomic, copy) NSString *isHooked;

@end

@interface AWEURLModel

@property(retain, nonatomic) NSArray *originURLList;

@end

@interface AWEVideoModel

@property(readonly, nonatomic) AWEURLModel *playURL;
@property(readonly, nonatomic) AWEURLModel *downloadURL;

@end

@interface AWEAwemeModel

@property(nonatomic, assign) BOOL preventDownload;
@property(retain, nonatomic) AWEVideoModel *video;

@end

CHConstructor{
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    if (areaDic == nil) {
        [UserDefaults setValue:HookInitAreaValue forKey:HookArea];
        [UserDefaults setBool:NO forKey:HookDownLoad];
        [UserDefaults setBool:NO forKey:HookWaterMark];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#pragma GCC diagnostic ignored "-Wundeclared-selector"

// MARK: - Hook CTCarrier
CHDeclareClass(CTCarrier)

CHMethod0(NSString *, CTCarrier, isoCountryCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *code = [areaDic objectForKey:@"code"];
    return code;
}

CHMethod0(NSString *, CTCarrier, mobileCountryCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *mcc = [areaDic objectForKey:@"mcc"];
    return mcc;
}

CHMethod0(NSString *, CTCarrier, mobileNetworkCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *mnc = [areaDic objectForKey:@"mnc"];
    return mnc;
}

CHConstructor {
    CHLoadLateClass(CTCarrier);
    CHHook0(CTCarrier, isoCountryCode);
    CHHook0(CTCarrier, mobileCountryCode);
    CHHook0(CTCarrier, mobileNetworkCode);
}

// MARK: - Setting界面
CHDeclareClass(AWESettingsTableViewController)
CHDeclareClass(AWESettingsViewModel)

CHPropertyAssign(AWESettingsViewModel, NSString *, isHooked, setIsHooked);

CHMethod0(NSArray *, AWESettingsViewModel, sectionDataArray) {
    NSMutableArray *hookSettings = [CHSuper0(AWESettingsViewModel, sectionDataArray) mutableCopy];
    if (![self.isHooked isEqualToString:@"YES"]) {
        AWESettingSectionModel *firstSectionModle = hookSettings.firstObject;
        NSMutableArray *items = [firstSectionModle.itemArray mutableCopy];
        AWESettingItemModel *hookItem = [objc_getClass("AWESettingItemModel") new];
        hookItem.type = -1;
        hookItem.title = HOOK_MENU_TITLE;
        hookItem.iconImageName = @"awe-settings-icon-safety-center";
        hookItem.cellType = 2;
        hookItem.cellTappedBlock = ^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AWEHookSettingViewController *settingVc = [[AWEHookSettingViewController alloc] init];
                UIViewController *tabbarVc = UIApplication.sharedApplication.keyWindow.rootViewController;
                UINavigationController *hookNavi = [[UINavigationController alloc] initWithRootViewController:settingVc];
                [tabbarVc presentViewController:hookNavi animated:YES completion:nil];
            });
        };
        [items insertObject:hookItem atIndex:0];
        firstSectionModle.itemArray = [items copy];
        self.isHooked = @"YES";
    }
    return [hookSettings copy];
}

CHConstructor {
    CHLoadLateClass(AWESettingsTableViewController);
    CHLoadLateClass(AWESettingsViewModel);
    CHHook0(AWESettingsViewModel, sectionDataArray);
    CHHook0(AWESettingsViewModel, isHooked);
    CHHook1(AWESettingsViewModel, setIsHooked);
}

// MARK: - AWEAwemeModel
CHDeclareClass(AWEShareServiceUtils)
CHDeclareClass(AWEAwemeModel)

CHMethod1(void, AWEAwemeModel, setPreventDownload, BOOL, arg1) {
    arg1 = ![UserDefaults boolForKey:HookDownLoad];
    CHSuper1(AWEAwemeModel, setPreventDownload, arg1);
}

CHMethod1(void, AWEAwemeModel, setVideo, AWEVideoModel *, arg1) {
    BOOL isHookDownLoad = [UserDefaults boolForKey:HookDownLoad];
    if (isHookDownLoad) {
        arg1.downloadURL.originURLList = arg1.playURL.originURLList;
    }
    CHSuper1(AWEAwemeModel, setVideo, arg1);
}

CHConstructor {
    CHLoadLateClass(AWEAwemeModel);
    CHLoadLateClass(AWEShareServiceUtils);
    CHHook1(AWEAwemeModel, setPreventDownload);
    CHHook1(AWEAwemeModel, setVideo);
}

// MARK: - WaterMark
CHDeclareClass(AWEDynamicWaterMarkExporter)

CHOptimizedClassMethod0(self, NSArray *, AWEDynamicWaterMarkExporter, watermarkLogoImageArray) {
    BOOL isHookWaterMark = [UserDefaults boolForKey:HookWaterMark];
    if (isHookWaterMark) {
        return @[];
    }
    return CHSuper0(AWEDynamicWaterMarkExporter, watermarkLogoImageArray);
}

CHConstructor {
    CHLoadLateClass(AWEDynamicWaterMarkExporter);
    CHClassHook0(AWEDynamicWaterMarkExporter, watermarkLogoImageArray);
}
