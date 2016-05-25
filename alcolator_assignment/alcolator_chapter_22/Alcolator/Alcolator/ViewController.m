//
//  ViewController.m
//  Alcolator
//
//  Created by Kenneth Chou on 5/22/16.
//  Copyright © 2016 Kenneth Chou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
//@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
//@property (weak, nonatomic) IBOutlet UILabel *resultLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldDidChange:(UITextField *)sender {
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    if (enteredNumber == 0){
        // The user typed 0, or something that's not a number, so clear the field
        sender.text = nil;
        
    }
}

- (IBAction)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider value change to %f", sender.value);
    [self.beerPercentTextField resignFirstResponder];
    int numberOfBeer = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12;
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue]/100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeer;
    float ouncesInOneWineGlass = 5;
    float alcoholPercentageOfWine = 0.13;
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal/ouncesOfAlcoholPerWineGlass;
    
    //round down and make it whole numbers
    int wholeNumber = numberOfWineGlassesForEquivalentAlcoholAmount;
    
    //round up and make it whole numbers(ceilf is for rounding up number)
    //int wholeNumber = ceilf(numberOfWineGlassesForEquivalentAlcoholAmount);
   
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", wholeNumber]];
    
    //This is for chapter 21 assignment
    //    self.navigationItem.title = @"Wine(One glass)";
}
//This is for chapter 21 assignment
//-(void)setBeerCountSlider:(UISlider *)beerCountSlider{
//    self.navigationItem.title = @"Wine(One glass)";
//}

- (IBAction)buttonPressed:(id)sender {
    [self.beerPercentTextField resignFirstResponder];
    
    // first, calculate how much alcohol is in all those beers..
    int numberOfBeer = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //assume they are 12oz beer bottles
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue]/100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeer;
    
    // now, calculate the equivalent amount of wine...
    float ouncesInOneWineGlass = 5; // wine glasses are usually 5oz
    float alcoholPercentageOfWine = 0.13; // 13% is average
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal/ouncesOfAlcoholPerWineGlass;
    
    // decide whether to use "beer"/"beers" and "glass"/"glasses"
    NSString *beerText;
    
    if (numberOfBeer == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    }else{
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    NSString *wineText;
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass");
    }else{
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
    // generate the result text, and display it on the label
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ (with %.2f%% alcohol) contains as much alcohol as %f.1f %@ fo wine", nil), numberOfBeer, beerText, [self.beerPercentTextField.text floatValue], numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLable.text = resultText;
}

- (IBAction)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}

@end































