//
//  WhiskeyViewController.m
//  Alcolator
//
//  Created by Kenneth Chou on 5/23/16.
//  Copyright © 2016 Kenneth Chou. All rights reserved.
//

#import "WhiskeyViewController.h"

@interface WhiskeyViewController ()

@end

@implementation WhiskeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//This is for chapter 21 assignment
//-(void)setBeerCountSlider:(UISlider *)beerCountSlider{
//    self.navigationItem.title = @"Whiskey(12 shot)";
//}
- (IBAction)whiskeyCountSlider:(UISlider *)sender {
    NSLog(@"Slider value change to %f", sender.value);
        [self.beerPercentTextField resignFirstResponder];
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //assume they are 12oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue];
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    float ouncesOfOneWhiskeyGlass = 1; // a 1oz shot
    float alcoholPercentageOfWhiskey = 0.4; // 40% is average
    
    float ouncesOfAlcoholPerWhiskeyGlass = ouncesOfOneWhiskeyGlass * alcoholPercentageOfWhiskey;
    float numberOfWhiskeyGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal/ouncesOfAlcoholPerWhiskeyGlass;
    int wholeNumber = numberOfWhiskeyGlassesForEquivalentAlcoholAmount;
    
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", wholeNumber]];
   
    //This is for chapter 21 assignment
    //self.navigationItem.title = self.navigationItem.title = @"Whiskey(12 shot)";

}



-(void)buttonPressed:(UIButton *)sender{
    [self.beerPercentTextField resignFirstResponder];
    
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //assume they are 12oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue];
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    float ouncesOfOneWhiskeyGlass = 1; // a 1oz shot
    float alcoholPercentageOfWhiskey = 0.4; // 40% is average
    
    float ouncesOfAlcoholPerWhiskeyGlass = ouncesOfOneWhiskeyGlass * alcoholPercentageOfWhiskey;
    float numberOfWhiskeyGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal/ouncesOfAlcoholPerWhiskeyGlass;
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    }else{
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *whiskeyText;
    
    if (numberOfWhiskeyGlassesForEquivalentAlcoholAmount == 1) {
        whiskeyText = NSLocalizedString(@"shot", @"single shot");
    }else{
        whiskeyText = NSLocalizedString(@"shots", @"plural of shot");
    }
    
    NSString *resultLabel =[NSString stringWithFormat:NSLocalizedString(@"%d %@ (with %.2f%% alcohol) contains as much alcohol as %.1f %@ of whiskey.", nil), numberOfBeers, beerText, [self.beerPercentTextField.text floatValue], numberOfWhiskeyGlassesForEquivalentAlcoholAmount, whiskeyText];
    
    self.resultLable.text = resultLabel;
}

@end


















