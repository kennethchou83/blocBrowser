//
//  ViewController.h
//  Alcolator
//
//  Created by Kenneth Chou on 5/22/16.
//  Copyright © 2016 Kenneth Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *resultLable;

-(void)buttonPressed:(UIButton *)sender;
//-(void)sliderValueDidChange:(UISlider *)sender;
@end

