//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import <QuartzCore/QuartzCore.h>

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

- (GameResult *)gameResult {
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game {
    int mode = [self.gameModeSegmentedControl selectedSegmentIndex]+2;
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc]init]
                                                           // 0 or 1 plus 2 shifts this to 2 for dual and 3 for tripple mode
                                                           withMode:mode];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)gameModeChanged:(UISegmentedControl *)sender {
    [self dialNewGame];
}

- (void)setGameModeSegmentedControl:(UISegmentedControl *)gameModeSegmentedControl {
    _gameModeSegmentedControl = gameModeSegmentedControl;
    [gameModeSegmentedControl addTarget:self
                                 action:@selector(gameModeChanged:)
                       forControlEvents:UIControlEventValueChanged];
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"Card_back.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.description forState:UIControlStateSelected];
        [cardButton setTitle:card.description forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.5 : 1);
        if (card.isFaceUp) {
            [cardButton setImage:nil forState:UIControlStateNormal];
        } else {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        }
        cardButton.layer.cornerRadius = 10;
        cardButton.layer.masksToBounds = YES;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipResultLabel.text = self.game.flipResult;
    self.gameModeSegmentedControl.enabled = false;
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
    self.gameModeSegmentedControl.enabled = YES;
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
