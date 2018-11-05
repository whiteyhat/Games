/**
 * Events that can occur when the Room module is active
 **/
Events.Room = [
	{/* Mt. Gox  --  Merchant */
		title: _('The Nomad'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.smart_contract', true) > 0;
		},
		scenes: {
			'start': {
				text: [
					_('Mt. Gox platform appears on the screen, asking to trade goods for crypto!')],
				notification: _('Mt. Gox appeared, enabling exchanging goods'),
				blink: true,
				buttons: {
					'buyScales': {
						text: _('buy scales'),
						cost: { 'smart_contract': 100 },
						reward: { 'scales': 1 }
					},
					'buypower_supply': {
						text: _('buy power_supply'),
						cost: { 'smart_contract': 200 },
						reward: { 'power_supply': 1 }
					},
					'buyclickbait': {
						text: _('buy clickbait'),
						cost: { 'smart_contract': 5 },
						reward: { 'clickbait': 1 },
						notification: _('traps are more effective with clickclickbait.')
					},
					'buyCompass': {
						available: function() {
							return $SM.get('stores.compass', true) < 1;
						},
						text: _('buy compass'),
						cost: { smart_contract: 300, scales: 15, power_supply: 5 },
						reward: { 'compass': 1 },
						notification: _('the old compass is dented and dusty, but it looks to work.')
					},
					'goodbye': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	},
	{ /*  Bitcoin Exploit  --  gain electricity/Lightning */
		title: _('Noises'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.electricity');
		},
		scenes: {
			'start': {
				text: [
					_('A new version of Bitcoin has been released'),
					_("It might be any exploit")
				],
				notification: _('The new version of Bitcoin might be exploitable'),
				blink: true,
				buttons: {
					'investigate': {
						text: _('investigate'),
						nextScene: { 0.3: 'stuff', 1: 'nothing' }
					},
					'ignore': {
						text: _('ignore them'),
						nextScene: 'end'
					}
				}
			},
			'nothing': {
				text: [
					_('The new version has zero exploits'),
					_('just as Satoshi designed it.')
				],
				buttons: {
					'backinside': {
						text: _('go back inside'),
						nextScene: 'end'
					}
				}
			},
			'stuff': {
				reward: { electricity: 100, smart_contract: 10 },
				text: [
					_('You found a bug in the source code. Nice!'),
					_('you have been rewarded.')
				],
				buttons: {
					'backinside': {
						text: _('go back inside'),
						nextScene: 'end'
					}
				}
			}
		}
	},
	{ /* Noises Inside  --  trade electricity for better good */
		title: _('Noises'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.electricity');
		},
		scenes: {
			start: {
				text: [
					_('There is rumour saying some of the community want to create their own vision of Bitcoin'),
					_('something\'s in there.')
				],
				notification: _('something is hardforking'),
				blink: true,
				buttons: {
					'investigate': {
						text: _('investigate'),
						nextScene: { 0.5: 'scales', 0.8: 'power_supply', 1: 'cloth' }
					},
					'ignore': {
						text: _('ignore them'),
						nextScene: 'end'
					}
				}
			},
			scales: {
				text: [
					_('some electricity is missing.'),
					_('the ground is littered with small scales')
				],
				onLoad: function() {
					var numelectricity = $SM.get('stores.electricity', true);
					numelectricity = Math.floor(numelectricity * 0.1);
					if(numelectricity === 0) numelectricity = 1;
					var numScales = Math.floor(numelectricity / 5);
					if(numScales === 0) numScales = 1;
					$SM.addM('stores', {'electricity': -numelectricity, 'scales': numScales});
				},
				buttons: {
					'leave': {
						text: _('leave'),
						nextScene: 'end'
					}
				}
			},
			power_supply: {
				text: [
					_('some electricity is missing.'),
					_('the ground is littered with small power supply')
				],
				onLoad: function() {
					var numelectricity = $SM.get('stores.electricity', true);
					numelectricity = Math.floor(numelectricity * 0.1);
					if(numelectricity === 0) numelectricity = 1;
					var numpower_supply = Math.floor(numelectricity / 5);
					if(numpower_supply === 0) numpower_supply = 1;
					$SM.addM('stores', {'electricity': -numelectricity, 'power_supply': numpower_supply});
				},
				buttons: {
					'leave': {
						text: _('leave'),
						nextScene: 'end'
					}
				}
			},
			cloth: {
				text: [
					_('some electricity is missing.'),
					_('the ground is littered with a ton of steps')
				],
				onLoad: function() {
					var numelectricity = $SM.get('stores.electricity', true);
					numelectricity = Math.floor(numelectricity * 0.1);
					if(numelectricity === 0) numelectricity = 1;
					var numCloth = Math.floor(numelectricity / 5);
					if(numCloth === 0) numCloth = 1;
					$SM.addM('stores', {'electricity': -numelectricity, 'cloth': numCloth});
				},
				buttons: {
					'leave': {
						text: _('leave'),
						nextScene: 'end'
					}
				}
			}
		}
	},
	{ /*Coinbase  --  trade Lightning for better good */
		title: _('The Beggar'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.smart_contract');
		},
		scenes: {
			start: {
				text: [
					_('a beggar arrives.'),
					_('asks for any spare Lightnings to keep him warm at night.')
				],
				notification: _('a beggar arrives'),
				blink: true,
				buttons: {
					'50smart_contracts': {
						text: _('give 50'),
						cost: {smart_contract: 50},
						nextScene: { 0.5: 'scales', 0.8: 'power_supply', 1: 'cloth' }
					},
					'100smart_contracts': {
						text: _('give 100'),
						cost: {smart_contract: 100},
						nextScene: { 0.5: 'power_supply', 0.8: 'scales', 1: 'cloth' }
					},
					'deny': {
						text: _('turn him away'),
						nextScene: 'end'
					}
				}
			},
			scales: {
				reward: { scales: 20 },
				text: [
					_('the beggar expresses his thanks.'),
					_('leaves a pile of small power_supply behind.')
				],
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			power_supply: {
				reward: { power_supply: 20 },
				text: [
					_('the beggar expresses his thanks.'),
					_('leaves a pile of small scales behind.')
				],
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			cloth: {
				reward: { cloth: 20 },
				text: [
					_('the beggar expresses his thanks.'),
					_('leaves some scraps of cloth behind.')
				],
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	},
	{/* Vitalik Buterin */
		title: _('The Shady Hal Finney'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('game.buildings["hut"]', true) >= 5 && $SM.get('game.buildings["hut"]', true) < 20;
		},
		scenes: {
			'start':{
				text: [
					_('A guy called Vitalik Buterin has appeard forking bircoin'),
					_('says he can give you help, with something he thinks he created called Lightnings')
				],
				notification: _('Vitalin Buterin pop up'),
				buttons: {
					'build': {
						text: _('300 electricity'),
						cost: { 'electricity' : 300 },
						nextScene: {0.6: 'steal', 1: 'build'}
					},
					'deny': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'steal': {
				text:[
					_("Vitalik Buterin has stolen our community")
				],
				notification: _('Vitalik Buterin has stolen our comminity'),
				buttons: {
					'end': {
						text: _('go home'),
						nextScene: 'end'
					}
				}
			},
			'build': {
				text:[
					_("Vitalik Buterin creates Ethereum")
				],
				notification: _('Vitalik Buterin creates Ethereumt'),
				onLoad: function() {
					var n = $SM.get('game.buildings["hut"]', true);
					if(n < 20){
						$SM.set('game.buildings["hut"]',n+1);
					}
				},
				buttons: {
					'end': {
						text: _('go home'),
						nextScene: 'end'
					}
				}
			}
		}
	},

	{ /* Mysterious Wanderer  --  Lightning gambling */
		title: _('The Mysterious Wanderer'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.electricity');
		},
		scenes: {
			start: {
				text: [
					_('a wanderer arrives with an empty cart. says if she leaves with Lightnings, she\'ll be back with more.'),
					_("Hal Finney's not sure he's to be trusted.")
				],
				notification: _('a mysterious wanderer arrives'),
				blink: true,
				buttons: {
					'electricity100': {
						text: _('give 100'),
						cost: {electricity: 100},
						nextScene: { 1: 'electricity100'}
					},
					'electricity500': {
						text: _('give 500'),
						cost: {electricity: 500},
						nextScene: { 1: 'electricity500' }
					},
					'deny': {
						text: _('turn him away'),
						nextScene: 'end'
					}
				}
			},
			'electricity100': {
				text: [
					_('the wanderer leaves, cart loaded with Lightnings')
				],
				action: function(inputDelay) {
					var delay = inputDelay || false;
					Events.saveDelay(function() {
						$SM.add('stores.electricity', 300);
						Notifications.notify(Room, _('the mysterious wanderer returns, cart piled high with electricity.'));
					}, 'Room[4].scenes.electricity100.action', delay);
				},
				onLoad: function() {
					if(Math.random() < 0.5) {
						this.action(60);
					}
				},
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'electricity500': {
				text: [
					_('the wanderer leaves, cart loaded with Lightnings')
				],
				action: function(inputDelay) {
					var delay = inputDelay || false;
					Events.saveDelay(function() {
						$SM.add('stores.electricity', 1500);
						Notifications.notify(Room, _('the mysterious wanderer returns, cart piled high with electricity.'));
					}, 'Room[4].scenes.electricity500.action', delay);
				},
				onLoad: function() {
					if(Math.random() < 0.3) {
						this.action(60);
					}
				},
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	},

	{ /* Mysterious Wanderer  --  Lightning gambling */
		title: _('The Mysterious Wanderer'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.smart_contract');
		},
		scenes: {
			start: {
				text: [
					_('a wanderer arrives with an empty cart. says if she leaves with smart_contracts, she\'ll be back with more.'),
					_("Hal Finney's not sure she's to be trusted.")
				],
				notification: _('a mysterious wanderer arrives'),
				blink: true,
				buttons: {
					'smart_contract100': {
						text: _('give 100'),
						cost: {smart_contract: 100},
						nextScene: { 1: 'smart_contract100'}
					},
					'smart_contract500': {
						text: _('give 500'),
						cost: {smart_contract: 500},
						nextScene: { 1: 'smart_contract500' }
					},
					'deny': {
						text: _('turn her away'),
						nextScene: 'end'
					}
				}
			},
			'smart_contract100': {
				text: [
					_('the wanderer leaves, cart loaded with Lightnings')
				],
				action: function(inputDelay) {
					var delay = inputDelay || false;
					Events.saveDelay(function() {
						$SM.add('stores.smart_contract', 300);
						Notifications.notify(Room, _('the mysterious wanderer returns, cart piled high with smart_contracts.'));
					}, 'Room[5].scenes.smart_contract100.action', delay);
				},
				onLoad: function() {
					if(Math.random() < 0.5) {
						this.action(60);
					}
				},
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'smart_contract500': {
				text: [
					_('the wanderer leaves, cart loaded with smart_contracts')
				],
				action: function(inputDelay) {
					var delay = inputDelay || false;
					Events.saveDelay(function() {
						$SM.add('stores.smart_contract', 1500);
						Notifications.notify(Room, _('the mysterious wanderer returns, cart piled high with smart_contracts.'));
					}, 'Room[5].scenes.smart_contract500.action', delay);
				},
				onLoad: function() {
					if(Math.random() < 0.3) {
						this.action(60);
					}
				},
				buttons: {
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	},

	{ /* Peter Todd  --  Map Merchant */
		title: _('The Scout'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('features.location.world');
		},
		scenes: {
			'start': {
				text: [
					_("Peter Todd says he's been all over."),
					_("willing to talk about it, for a price.")
				],
				notification: _('Peter Todd for the night'),
				blink: true,
				buttons: {
					'buyMap': {
						text: _('buy map'),
						cost: { 'smart_contract': 200, 'scales': 10 },
						available: function() {
							return !World.seenAll;
						},
						notification: _('the map uncovers a bit of the world'),
						onChoose: World.applyMap
					},
					'learn': {
						text: _('learn scouting'),
						cost: { 'smart_contract': 1000, 'scales': 50, 'power_supply': 20 },
						available: function() {
							return !$SM.hasPerk('scout');
						},
						onChoose: function() {
							$SM.addPerk('scout');
						}
					},
					'leave': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	},

	{ /* Nick Szabo */
		title: _('The Master'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('features.location.world');
		},
		scenes: {
			'start': {
				text: [
					_('Nick Szabo arrives.'),
					_('he smiles warmly and asks if he can help.')
				],
				notification: _('Nick Szabo arrives'),
				blink: true,
				buttons: {
					'agree': {
						text: _('agree'),
						cost: {
							'cured Lightning': 100,
							'smart_contract': 100,
							'torch': 1
						},
						nextScene: {1: 'agree'}
					},
					'deny': {
						text: _('turn him away'),
						nextScene: 'end'
					}
				}
			},
			'agree': {
				text: [
					_('in exchange, Nick Szabo offers his wisdom.')
				],
				buttons: {
					'evasion': {
						text: _('evasion'),
						available: function() {
							return !$SM.hasPerk('evasive');
						},
						onChoose: function() {
							$SM.addPerk('evasive');
						},
						nextScene: 'end'
					},
					'precision': {
						text: _('precision'),
						available: function() {
							return !$SM.hasPerk('precise');
						},
						onChoose: function() {
							$SM.addPerk('precise');
						},
						nextScene: 'end'
					},
					'force': {
						text: _('force'),
						available: function() {
							return !$SM.hasPerk('barbarian');
						},
						onChoose: function() {
							$SM.addPerk('barbarian');
						},
						nextScene: 'end'
					},
					'nothing': {
						text: _('nothing'),
						nextScene: 'end'
					}
				}
			}
		}
	},

	{ /*Bitcoin Cash*/
		title: _('The Sick Man'),
		isAvailable: function() {
			return Engine.activeModule == Room && $SM.get('stores.Bitcoin_culture', true) > 0;
		},
		scenes: {
			'start': {
				text: [
					_("Bitcoin Cash hobbles up, coughing."),
					_("begs for Bitcoin_culture.")
				],
				notification: _('a sick Bitcoin Cash hobbles up'),
				blink: true,
				buttons: {
					'help': {
						text: _('give 1 Bitcoin_culture'),
						cost: { 'Bitcoin_culture': 1 },
						notification: _('Bitcoin Cash swallows the Bitcoin_culture eagerly'),
						nextScene: { 0.1: 'alloy', 0.3: 'cells', 0.5: 'scales', 1.0: 'nothing' }
					},
					'ignore': {
						text: _('tell it to leave'),
						nextScene: 'end'
					}
				}
			},
			'alloy': {
				text: [
					_("the Bitcoin Cash is thankful."),
					_('he leaves a reward.'),
					_('some weird metal he picked up on his travels.')
				],
				onLoad: function() {
					$SM.add('stores["mining_hardware"]', 1);
				},
				buttons: {
					'bye': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'cells': {
				text: [
					_("the Bitcoin Cash is thankful."),
					_('he leaves a reward.'),
					_('some weird glowing boxes he picked up on his travels.')
				],
				onLoad: function() {
					$SM.add('stores["energy cell"]', 3);
				},
				buttons: {
					'bye': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'scales': {
				text: [
					_("the Bitcoin Cash is thankful."),
					_('he leaves a reward.'),
					_('all he has are some scales.')
				],
				onLoad: function() {
					$SM.add('stores.scales', 5);
				},
				buttons: {
					'bye': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			},
			'nothing': {
				text: [
					_("the Bitcoin Cash expresses his thanks and hobbles off.")
				],
				buttons: {
					'bye': {
						text: _('say goodbye'),
						nextScene: 'end'
					}
				}
			}
		}
	}
];
