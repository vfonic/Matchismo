//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "CardGameViewController.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

- (void)updateUI {
    NSLog(@"CardGameViewController updateUI");
}

-(void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
}

- (void)dialNewGame {
    self.game = nil;
    self.gameResult = nil;
    [self updateUI];
    self.flipResultLabel.text = @"";
    self.flipCount = 0;
}

- (IBAction)dialButtonPressed {
    [self dialNewGame];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    ++self.flipCount;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

@end
