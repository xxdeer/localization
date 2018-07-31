//
//  ViewController.m
//  LocalizationalTest
//
//  Created by Minewtech on 2018/7/30.
//  Copyright © 2018年 Minewtech. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"File"]

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *piker;
    NSArray *languageAry;
    NSInteger indexs;
    UILabel *label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indexs = 0;
    languageAry = @[@"Chinese",@"French",@"English"];
    
    label = [[UILabel alloc]init];
//    //本地化语言自动切换：
//    label.text = NSLocalizedString(@"loss", nil);
    //本地化语言自己查找：
    label.text = [NSString stringWithFormat:@"测试: %@",Localized(@"loss")];
    label.frame = CGRectMake(50, 50, 300, 60);
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(50, 200, 300, 60);
    [button addTarget:self action:@selector(changeLanguage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    piker = [[UIPickerView alloc]init];
    piker.frame = CGRectMake(50, 350, 300, 60);
    piker.delegate = self;
    piker.dataSource = self;
    piker.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:piker];
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark target handler
- (void)changeLanguage{

    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];

    if ([language isEqualToString: @"en"]) {

        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];

    }else {

        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];

}

- (void)chooseLanguage{
    NSLog(@"choose indexs: %ld",(long)indexs);
    switch (indexs) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            [self notification];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"appLanguage"];
            [self notification];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            [self notification];
            break;
        default:
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            [self notification];
            break;
    }
}
- (void)notification{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseLanguage" object:nil];
}

- (void)somethingChange{
    NSLog(@"%@",Localized(@"loss"));
    label.text = [NSString stringWithFormat:@"测试: %@",Localized(@"loss")];
//    label.text = NSLocalizedString(@"loss", nil);
    
}
#pragma mark delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"select %ld",(long)row);
    indexs = row;
    [self chooseLanguage];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return languageAry[row];
}

#pragma mark view life
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChange) name:@"chooseLanguage" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
