//
//  ClassicalCardGameViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 25.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "ClassicalCardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import <QuartzCore/QuartzCore.h>

@interface ClassicalCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation ClassicalCardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc]init]
                                                           withMode:2];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    NSLog(@"ClassicalCardGameViewController updateUI");
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
}
@end
