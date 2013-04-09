//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 24.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import <QuartzCore/QuartzCore.h>

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *flippedCards;
@end

@implementation SetGameViewController

- (NSMutableArray *)flippedCards {
    if (!_flippedCards) _flippedCards = [[NSMutableArray alloc] initWithCapacity:3];
    return _flippedCards;
}

- (GameResult *)gameResult {
    if (!_gameResult) { _gameResult = [[GameResult alloc] init]; _gameResult.gameTypeName = @"Set"; }
    return _gameResult;
}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[SetCardDeck alloc]init]
                                                           withMode:3];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

#define CARD_FONT_SIZE 18
#define FLIP_RESULT_FONT_SIZE 12
- (void)updateUI {
    NSLog(@"SetGameViewController updateUI");
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            NSMutableAttributedString *cardAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[setCard attributedDescription]];
            [cardAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:CARD_FONT_SIZE] range:NSMakeRange(0, [cardAttributedString length])];
            [cardButton setAttributedTitle:cardAttributedString forState:UIControlStateNormal];
            [cardButton setAttributedTitle:cardAttributedString forState:UIControlStateSelected];
            
            NSMutableAttributedString *disabledCardAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
            [cardButton setAttributedTitle:disabledCardAttributedString forState:UIControlStateSelected|UIControlStateDisabled];
            cardButton.selected = setCard.isFaceUp;
            cardButton.enabled = !setCard.isUnplayable;
            cardButton.alpha = (cardButton.enabled ? (cardButton.selected ? 0.5 : 1) : 0);
            if (cardButton.selected) {
                [cardButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
            }
            else [cardButton setBackgroundColor:[UIColor whiteColor]];
            cardButton.layer.cornerRadius = 10;
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if ([self.game.flipResult isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *flipResultAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.game.flipResult];
        [flipResultAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FLIP_RESULT_FONT_SIZE] range:NSMakeRange(0, [flipResultAttributedString length])];
        self.flipResultLabel.attributedText = flipResultAttributedString;
    }
    
    if ([self.flippedCards count] == 3) [self.flippedCards removeAllObjects];
}

- (IBAction)flipCard:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    Card *card = [self.game cardAtIndex:cardIndex];
    if ([self.flippedCards containsObject:card]) [self.flippedCards removeObject:card];
    else [self.flippedCards addObject:card];
    [self.game flipCardAtIndex:cardIndex];
    ++self.flipCount;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

@end
