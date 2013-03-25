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
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            CGFloat alpha;
            switch ([setCard shading]) {
                case OpenShading:
                    alpha = 0;
                    break;
                case StripedShading:
                    alpha = 0.2;
                    break;
                default:
                    alpha = 1.;
                    break;
            }
            NSMutableAttributedString *cardAttributedString = [[NSMutableAttributedString alloc] initWithString:[card description]];
            [cardAttributedString addAttributes:@{
                           NSFontAttributeName : [[cardButton.titleLabel font] fontWithSize:18],
                NSForegroundColorAttributeName : [[setCard color] colorWithAlphaComponent:alpha],
                    NSStrokeColorAttributeName : [setCard color],
                    NSStrokeWidthAttributeName : @-5}
                                          range:NSMakeRange(0, [[setCard description] length])];
            [cardButton setAttributedTitle:cardAttributedString forState:UIControlStateNormal];
            [cardButton setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:@""] forState:UIControlStateSelected|UIControlStateDisabled];
            cardButton.selected = setCard.isFaceUp;
            cardButton.enabled = !setCard.isUnplayable;
            cardButton.alpha = (setCard.isFaceUp ? 0.5 : 1);
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipResultLabel.text = self.game.flipResult;
}
@end
