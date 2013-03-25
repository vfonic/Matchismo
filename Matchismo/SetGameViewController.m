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

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation SetGameViewController

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

- (void)updateUI {
    NSLog(@"SetGameViewController updateUI");
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
//        [cardButton setAttributedTitle:[card attributedDescription] forState:UIControlStateNormal];
//        [cardButton setTitle:[card description] forState:UIControlStateNormal|UIControlState];
        [cardButton setTitle:@"" forState:UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isFaceUp ? 0.5 : 1);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipResultLabel.text = self.game.flipResult;
}
@end
