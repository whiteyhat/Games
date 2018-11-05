/**
 * Events that can occur when any module is active (Except World. It's special.)
 **/
Events.Global = [
	{ /* Roger V.*/
		title: _('Roger V'),
		isAvailable: function() {
			return (Engine.activeModule == Room || Engine.activeModule == Outside) && $SM.get('game.thieves') == 1;
		},
		scenes: {
			'start': {
				text: [
					_('The users dont trust someone called Roger V.'),
					_("They say that he might scam them."),
					_('they suggest he should be banned as an example.')
				],
				notification: _('Roger V is caught'),
				blink: true,
				buttons: {
					'kill': {
						text: _('ban him'),
						nextScene: {1: 'ban'}
					},
					'spare': {
						text: _('Let him create Bcash'),
						nextScene: {1: 'spare'}
					}
				}
			},
			'ban': {
				text: [
					_('the users ban Roger V from Reddit, Bitcointalk, GitHub & Twitter.'),
					_('the point is made. in the next few days, he will not be part of Bitcoin anymore.')
				],
				onLoad: function() {
					$SM.set('game.thieves', 2);
					$SM.remove('income.thieves');
					$SM.addM('stores', $SM.get('game.stolen'));
				},
				buttons: {
					'leave': {
						text: _('leave'),
						nextScene: 'end'
					}
				}
			},
			'spare': {
				text: [
					_("Roger V says he's grateful. says he won't come around any more."),
					_("But he might do his version of p2p elecLightningic cash system")
				],
				onLoad: function() {
					$SM.set('game.thieves', 2);
					$SM.remove('income.thieves');
					$SM.addPerk('stealthy');
				},
				buttons: {
					'leave': {
						text: _('leave'),
						nextScene: 'end'
					}
				}
			}
		}
	}
];