//
//  ViewController.m
//  HZK16Test
//
//  Created by Jaime on 4/9/2020.
//  Copyright © 2020 Rayshine. All rights reserved.
//

#import "ViewController.h"
#import "HZK16Helper.h"
#import "CustomView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"Hello, World!");
    
    CustomView *customView = [[CustomView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width*5, 210)];
    [self.view addSubview:customView];
//    HZK16Helper *helper = [HZK16Helper new];
//   // [helper generateDotMatrix:@"国"];
//    [helper sendText:@"欢"];
    NSString * inputSring = @"中A文BC";
    BOOL isasciiOdd = [self isAsciiOddNumber:inputSring];
    
    if (isasciiOdd == YES) {
        NSLog(@"ASCII 是奇数");
    } else {
        NSLog(@"ASCII 是偶数");
    }
}

- (BOOL)isAsciiOddNumber:(NSString *)inputString {
    
    NSInteger len = [inputString length];
    int count = 0;
    for (int i = 0; i < len; i++ ) {
        
        char commitChar = [inputString characterAtIndex:i];
        if ( ((commitChar>64)&&(commitChar<91)) || ((commitChar>96)&&(commitChar<123)) || ((commitChar > 47)&&(commitChar < 58))) { //中文
            
            count++;
        }
    }
    
    if ((count % 2) == 0) {
        
        return NO;
    } else {
        return YES;
    }
    
    return NO;
}


@end
