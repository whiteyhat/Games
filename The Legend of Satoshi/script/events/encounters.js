/**
 * Events that can occur when wandering around the world
 **/
Events.Encounters = [
	{ /* Bcasher */
		title: _('Bcasher'),
		isAvailable: function() {
			return World.getDistance() <= 10 && World.getTerrain() == World.TILE.FOREST;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'Bcasher',
				enemyName: _('Bcasher'),
				deathMessage: _('the Bcasher is dead'),
				chara: 'R',
				damage: 1,
				hit: 0.8,
				attackDelay: 1,
				health: 5,
				loot: {
					'smart_contract': {
						min: 1,
						max: 3,
						chance: 1
					},
					'Lightning': {
						min: 1,
						max: 3,
						chance: 1
					},
					'power_supply': {
						min: 1,
						max: 3,
						chance: 0.8
					}
				},
				notification: _('Bcasher beast leaps out of the underbrush')
			}
		}
	},
	{ /* Gaunt Man */
	title: _('A Gaunt Man'),
		isAvailable: function() {
			return World.getDistance() <= 10 && World.getTerrain() == World.TILE.BARRENS;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'gaunt man',
				enemyName: _('gaunt man'),
				deathMessage: _('the gaunt man is dead'),
				chara: 'E',
				damage: 2,
				hit: 0.8,
				attackDelay: 2,
				health: 6,
				loot: {
					'cloth': {
						min: 1,
						max: 3,
						chance: 0.8
					},
					'power_supply': {
						min: 1,
						max: 2,
						chance: 0.8
					},
					'mining_rig': {
						min: 1,
						max: 2,
						chance: 0.5
					}
				},
				notification: _('a gaunt man approaches, a crazed look in his eye')
			}
		}
	},
	{ /* Faketoshi */
	title: _('Faketoshi'),
		isAvailable: function() {
			return World.getDistance() <= 10 && World.getTerrain() == World.TILE.FIELD;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'Faketoshi',
				enemyName: _('Faketoshi'),
				deathMessage: _('Faketoshi is dead'),
				chara: 'R',
				damage: 3,
				hit: 0.8,
				attackDelay: 2,
				health: 4,
				loot: {
					'scales': {
						min: 1,
						max: 3,
						chance: 0.8
					},
					'power_supply': {
						min: 1,
						max: 2,
						chance: 0.5
					},
					'Lightning': {
						min: 1,
						max: 3,
						chance: 0.8
					}
				},
				notification: _('a strange looking bird speeds across the plains')
			}
		}
	},
	{ /* SEC */
		title: _('SEC'),
		isAvailable: function() {
			return World.getDistance() > 10 && World.getDistance() <= 20 && World.getTerrain() == World.TILE.BARRENS;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'sec',
				enemyName: _('The SEC'),
				deathMessage: _('the SEC are dead'),
				chara: 'E',
				damage: 5,
				hit: 0.5,
				attackDelay: 1,
				health: 20,
				loot: {
					'cloth': {
						min: 1,
						max: 1,
						chance: 0.2
					},
					'power_supply': {
						min: 1,
						max: 2,
						chance: 0.8
					},
					'mining_rig': {
						min: 1,
						max: 1,
						chance: 0.2
					},
					'Bitcoin_culture': {
						min: 1,
						max: 3,
						chance: 0.7
					}
				},
				notification: _('The SEC approaches and attacks with surprising regulations')
			}
		}
	},
	{ /* scamy ICO */
		title: _('A scammy ICO'),
		isAvailable: function() {
			return World.getDistance() > 10 && World.getDistance() <= 20 && World.getTerrain() == World.TILE.FOREST;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'ico',
				enemyName: _('Scammy ICO'),
				deathMessage: _('the Scammy ICO community and project are dead'),
				chara: 'T',
				damage: 3,
				hit: 0.8,
				attackDelay: 1,
				health: 25,
				loot: {
					'smart_contract': {
						min: 5,
						max: 10,
						chance: 1
					},
					'Lightning': {
						min: 5,
						max: 10,
						chance: 1
					},
					'power_supply': {
						min: 5,
						max: 10,
						chance: 0.8
					}
				},
				notification: _('A new scammy ICO is arasing, we need to annihilate it')
			}
		}
	},
	{ /* Jamie Dimon */
	title: _('Jamie Dimon'),
		isAvailable: function() {
			return World.getDistance() > 10 && World.getDistance() <= 20 && World.getTerrain() == World.TILE.BARRENS;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'jamie',
				enemyName: _('Jamie Dimon'),
				deathMessage: _('Jamie DImon is dead'),
				chara: 'E',
				damage: 4,
				hit: 0.8,
				attackDelay: 2,
				health: 30,
				loot: {
					'cloth': {
						min: 5,
						max: 10,
						chance: 0.8
					},
					'mining_rig': {
						min: 5,
						max: 10,
						chance: 0.8
					},
					'iron': {
						min: 1,
						max: 5,
						chance: 0.5
					},
					'Bitcoin_culture': {
						min: 1,
						max: 2,
						chance: 0.1
					}
				},
				notification: _('a scavenger draws close, hoping for an easy score')
			}
		}
	},
	{ /* Debt */
		title: _('A Debt'),
		isAvailable: function() {
			return World.getDistance() > 10 && World.getDistance() <= 20 && World.getTerrain() == World.TILE.FIELD;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'Debt',
				enemyName: _('Debt'),
		
				chara: 'T',
				damage: 5,
				hit: 0.8,
				attackDelay: 2,
				health: 20,
				loot: {
					'scales': {
						min: 5,
						max: 10,
						chance: 0.8
					},
					'power_supply': {
						min: 5,
						max: 10,
						chance: 0.5
					},
					'Lightning': {
						min: 5,
						max: 10,
						chance: 0.8
					}
				},
				notification: _('the grass thrashes wildly as a huge lizard pushes through')
			}
		}
	},
	/* Tier 3*/
	{ /* Feral Terror */
		title: _('A Feral Terror'),
		isAvailable: function() {
			return World.getDistance() > 20 && World.getTerrain() == World.TILE.FOREST;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'feral terror',
				enemyName: _('feral terror'),
				deathMessage: _('the feral terror is dead'),
				chara: 'T',
				damage: 6,
				hit: 0.8,
				attackDelay: 1,
				health: 45,
				loot: {
					'smart_contract': {
						min: 5,
						max: 10,
						chance: 1
					},
					'Lightning': {
						min: 5,
						max: 10,
						chance: 1
					},
					'power_supply': {
						min: 5,
						max: 10,
						chance: 0.8
					}
				},
				notification: _('Debt is increasing and there is only way to get rid of it, fight it!')
			}
		}
	},
	{ /* Soldier */
	title: _('A Soldier'),
		isAvailable: function() {
			return World.getDistance() > 20 && World.getTerrain() == World.TILE.BARRENS;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'soldier',
				enemyName: _('soldier'),
				deathMessage: _('the soldier is dead'),
				ranged: true,
				chara: 'D',
				damage: 8,
				hit: 0.8,
				attackDelay: 2,
				health: 50,
				loot: {
					'cloth': {
						min: 5,
						max: 10,
						chance: 0.8
					},
					'has_power': {
						min: 1,
						max: 5,
						chance: 0.5
					},
					'rifle': {
						min: 1,
						max: 1,
						chance: 0.2
					},
					'Bitcoin_culture': {
						min: 1,
						max: 2,
						chance: 0.1
					}
				},
				notification: _('a soldier opens fire from across the desert')
			}
		}
	},
	{ /* Sniper */
	title: _('A Sniper'),
		isAvailable: function() {
			return World.getDistance() > 20 && World.getTerrain() == World.TILE.FIELD;
		},
		scenes: {
			'start': {
				combat: true,
				enemy: 'sniper',
				enemyName: _('sniper'),
				deathMessage: _('the sniper is dead'),
				chara: 'D',
				damage: 15,
				hit: 0.8,
				attackDelay: 4,
				health: 30,
				ranged: true,
				loot: {
					'cloth': {
						min: 5,
						max: 10,
						chance: 0.8
					},
					'has_power': {
						min: 1,
						max: 5,
						chance: 0.5
					},
					'rifle': {
						min: 1,
						max: 1,
						chance: 0.2
					},
					'Bitcoin_culture': {
						min: 1,
						max: 2,
						chance: 0.1
					}
				},
				notification: _('a shot rings out, from somewhere in the long grass')
			}
		}
	}
];
