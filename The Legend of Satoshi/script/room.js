/**
 * Module that registers the simple room functionality
 */
var Room = {
	// times in (minutes * seconds * milliseconds)
	_FIRE_COOL_DELAY: 5 * 60 * 1000, // time after a stoke before the fire cools
	_ROOM_WARM_DELAY: 30 * 1000, // time between room temperature updates
	_BUILDER_STATE_DELAY: 0.5 * 60 * 1000, // time between builder state updates
	_STOKE_COOLDOWN: 10, // cooldown to stoke the fire
	_NEED_WOOD_DELAY: 15 * 1000, // from when the stranger shows up, to when you need electricity
	
	buttons:{},
	
	Craftables: {
		'user': {
			name: _('user'),
			button: null,
			maximum: 10,
			availableMsg: _('Give electricity in exchange for community adoption, we need users'),
			buildMsg: _('another user has joined to help us in GitHub'),
			maxMsg: _("we have enough user"),
			type: 'building',
			cost: function() {
				var n = $SM.get('game.buildings["user"]', true);
				return {
					'electricity': 10 + (n*10)
				};
			}
		},
		'powerpack': {
			name: _('powerpack'),
			button: null,
			maximum: 1,
			availableMsg: _('Hal Finney is saying he can help by creating a powerpack'),
			buildMsg: _('the powerpack will carry more electricity from the power station'),
			type: 'building',
			cost: function() {
				return {
					'electricity': 30
				};
			}
		},
		'rig': {
			name: _('rig'),
			button: null,
			maximum: 20,
			availableMsg: _("Hall Finney says there are more engineers. says they'll work, too."),
			buildMsg: _('Hal Finney puts up a rig.'),
			maxMsg: _('no more space for rigs.'),
			type: 'building',
			cost: function() {
				var n = $SM.get('game.buildings["rig"]', true);
				return {
					'electricity': 100 + (n*50)
				};
			}
		},
		'power plant': {
			name: _('power plant'),
			button: null,
			maximum: 1,
			availableMsg: _('engineers could help building, given the means'),
			buildMsg: _('the power plant stands far from the town'),
			type: 'building',
			cost: function() {
				return {
					'electricity': 200,
					'graphicard': 10,
					'Lightning': 5
				};
			}
		},
		'trading post': {
			name: _('trading post'),
			button: null,
			maximum: 1,
			availableMsg: _("a trading post would make commerce easier"),
			buildMsg: _("now exchanges have a place to set up shops, they might stick around a while"),
			type: 'building',
			cost: function() {
				return {
					'electricity': 400,
					'graphicard': 100
				};
			}
		},
		'mining farm': {
			name: _('mining farm'),
			button: null,
			maximum: 1,
			availableMsg: _("Hal Finney says mining rig could be useful. says the engineers could make it."),
			buildMsg: _('mining farm goes up quick, on the edge of the town'),
			type: 'building',
			cost: function() {
				return {
					'electricity': 500,
					'graphicard': 50
				};
			}
		},
		'Eclair': {
			name: _('Eclair'),
			button: null,
			maximum: 1,
			availableMsg: _("should cure the Lightning, or it'll spoil. Roastbeef says she can fix something up."),
			buildMsg: _('ACINC has finished the Eclair wallet. It looks reckless.'),
			type: 'building',
			cost: function() {
				return {
					'electricity': 600,
					'Lightning': 50
				};
			}
		},
		'workshop': {
			name: _('workshop'),
			button: null,
			maximum: 1,
			availableMsg: _("Hal Finney says she could make finer things, if she had the tools"),
			buildMsg: _("workshop's finally ready. Hal Finney is excited to get to it"),
			type: 'building',
			cost: function() {
				return {
					'electricity': 800,
					'wood mining frame': 100,
					'electric meter': 10
				};
			}
		},
		'steelworks': {
			name: _('steelworks'),
			button: null,
			maximum: 1,
			availableMsg: _("Hal Finney says the workers could make steel, given the tools"),
			buildMsg: _("shadow falls over the factory as the steelworks fires up"),
			type: 'building',
			cost: function() {
				return {
					'electricity': 1500,
					'iron mining frame': 100,
					'ether': 100
				};
			}
		},
		'mining pool': {
			name: _('mining pool'),
			button: null,
			maximum: 1,
			availableMsg: _("Hal Finney says it'd be useful to have a steady source of hash power"),
			buildMsg: _("mining pool is done, welcoming the weapons of the future."),
			type: 'building',
			cost: function() {
				return {
					'electricity': 3000,
					'steel mining frame': 100,
					'PoW': 50
				};
			}
		},
		'watch_tower': {
			name: _('watch_tower'),
			button: null,
			type: 'tool',
			buildMsg: _('a watch_tower to keep the dark away'),
			cost: function() {
				return {
					'electricity': 1,
					'chip': 1
				};
			}
		},
		'generator': {
			name: _('generator'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('this generator will produce a bit of electric energy, at least'),
			cost: function() {
				return {
					'wood mining frame': 50
				};
			}
		},
		'battery': {
			name: _('battery'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('the battery holds enough electric energy for longer expeditions'),
			cost: function() {
				return {
					'wood mining frame': 100,
					'iron': 20
				};
			}
		},
		'converter': {
			name: _('converter'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('never get the wrong voltage again'),
			cost: function() {
				return {
					'iron mining frame': 100,
					'steel mining frame': 50
				};
			}
		},
		'taser': {
			name: _('taser'),
			button: null,
			type: 'weapon',
			buildMsg: _("this taser is not that powerful, but it's pretty good at stunning"),
			cost: function() {
				return {
					'electricity': 100,
					'power supplies': 5
				};
			}
		},
		'rucksack': {
			name: _('rucksack'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('carrying more means longer expeditions'),
			cost: function() {
				return {
					'wood mining frame': 200
				};
			}
		},
		'wagon': {
			name: _('wagon'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('the wagon can carry a lot of supplies'),
			cost: function() {
				return {
					'electricityd': 500,
					'iron mining frame': 100
				};
			}
		},
		'convoy': {
			name: _('convoy'),
			button: null,
			type: 'upgrade',
			maximum: 1,
			buildMsg: _('the convoy can haul mostly everything'),
			cost: function() {
				return {
					'electricity': 1000,
					'iron mining frame': 200,
					'steel mining frame': 100
				};
			}
		},
		'w mining rig': {
			name: _('w mining rig'),
			type: 'upgrade',
			maximum: 1,
			buildMsg: _("wood mining frame is not strong. better than anything, though."),
			cost: function() {
				return {
					'wood mining frame': 200,
					'electric meter': 20
				};
			}
		},
		'i mining rig': {
			name: _('i mining rig'),
			type: 'upgrade',
			maximum: 1,
			buildMsg: _("iron mining frame is stronger than wood mining frame"),
			cost: function() {
				return {
					'wood mining frame': 200,
					'iron mining frame': 100
				};
			}
		},
		's mining rig': {
			name: _('s mining rig'),
			type: 'upgrade',
			maximum: 1,
			buildMsg: _("steel mining frame is stronger than iron mining frame"),
			cost: function() {
				return {
					'wood mining frame': 200,
					'steel mining frame': 100
				};
			}
		},
		'iron sword': {
			name: _('iron sword'),
			button: null,
			type: 'weapon',
			buildMsg: _("sword is sharp. good protection out in the wilds."),
			cost: function() {
				return {
					'electricityd': 200,
					'wood mining frame': 50,
					'iron mining frame': 20
				};
			}
		},
		'steel sword': {
			name: _('steel sword'),
			button: null,
			type: 'weapon',
			buildMsg: _("the steel is strong, and the blade true."),
			cost: function() {
				return {
					'electricity': 500,
					'wood mining frame': 100,
					'steel mining frame': 20
				};
			}
		},
		'rifle': {
			name: _('rifle'),
			type: 'weapon',
			buildMsg: _("black powder and hash power, like the old days."),
			cost: function() {
				return {
					'electricity': 200,
					'steel mining frame': 50,
					'PoW': 50
				};
			}
		}
	},
	
	TradeGoods: {
		'electric meter': {
			type: 'good',
			cost: function() {
				return { graphicard: 150 };
			}
		},
		'power supplies': {
			type: 'good',
			cost: function() {
				return { graphicard: 300 };
			}
		},
		'iron mining frame': {
			type: 'good',
			cost: function() {
				return {
					'graphicard': 150,
					'electric meter': 50
				};
			}
		},
		'ether': {
			type: 'good',
			cost: function() {
				return {
					'graphicard': 200,
					'power supplies': 50
				};
			}
		},
		'steel mining frame': {
			type: 'good',
			cost: function() {
				return {
					'graphicard': 300,
					'electric meter': 50,
					'power supplies': 50
				};
			}
		},
		'medicine': {
			type: 'good',
			cost: function() {
				return {
					'electric meter': 50, 'power supplies': 30
				};
			}
		},
		'hash power 1': {
			type: 'good',
			cost: function() {
				return {
					'electric meter': 10
				};
			}
		},
		'hash power 2': {
			type: 'good',
			cost: function() {
				return {
					'electric meter': 10,
					'power supplies': 10
				};
			}
		},
		'bolas': {
			type: 'weapon',
			cost: function() {
				return {
					'power supplies': 10
				};
			}
		},
		'hash_attack': {
			type: 'weapon',
			cost: function() {
				return {
					'electric meter': 100,
					'power supplies': 50
				};
			}
		},
		'GPU': {
			type: 'weapon',
			cost: function() {
				return {
					'electric meter': 500,
					'mining supplies': 250
				};
			}
		},
		'mining hardware': {
			type: 'good',
			cost: function() {
				return {
					'graphicard': 1500,
					'electric meter': 750,
					'power supplies': 300
				};
			}
		},
		'Bitcoin_Whitepaper': {
			type: 'special',
			maximum: 1,
			cost: function() {
				return { 
					'graphicard': 400, 
					'electric meter': 20, 
					'power supplies': 10 
				};
			}
		}
	},
	
	MiscItems: {
		'laser rifle': {
			type: 'weapon'
		}
	},
	
	name: _("Room"),
	init: function(options) {
		this.options = $.extend(
			this.options,
			options
		);
		
		Room.pathDiscovery = Boolean($SM.get('stores["Bitcoin_Whitepaper"]'));

		if(Engine._debug) {
			this._ROOM_WARM_DELAY = 5000;
			this._BUILDER_STATE_DELAY = 5000;
			this._STOKE_COOLDOWN = 0;
			this._NEED_WOOD_DELAY = 5000;
		}
		
		if(typeof $SM.get('features.location.room') == 'undefined') {
			$SM.set('features.location.room', true);
			$SM.set('game.builder.level', -1);
		}
		
		// If this is the first time playing, the fire is dead and it's freezing. 
		// Otherwise grab past save state temp and fire level.
		$SM.set('game.temperature', $SM.get('game.temperature.value')===undefined?this.TempEnum.Freezing:$SM.get('game.temperature'));
		$SM.set('game.fire', $SM.get('game.fire.value')===undefined?this.FireEnum.Dead:$SM.get('game.fire'));
		
		// Create the room tab
		this.tab = Header.addLocation(_("Satoshi's Mind"), "room", Room);
		
		// Create the Room panel
		this.panel = $('<div>')
			.attr('id', "roomPanel")
			.addClass('location')
			.appendTo('div#locationSlider');
		
		Engine.updateSlider();
		
		// Create the light button
		new Button.Button({
			id: 'lightButton',
			text: _('Create Bitcoin'),
			click: Room.lightFire,
			cooldown: Room._STOKE_COOLDOWN,
			width: '80px',
			cost: {'electricity': 5}
		}).appendTo('div#roomPanel');
		
		// Create the stoke button
		new Button.Button({
			id: 'stokeButton',
			text: _("Mine Bitcoin"),
			click: Room.stokeFire,
			cooldown: Room._STOKE_COOLDOWN,
			width: '80px',
			cost: {'electricity': 1}
		}).appendTo('div#roomPanel');
		
		// Create the stores container
		$('<div>').attr('id', 'storesContainer').prependTo('div#roomPanel');
		
		//subscribe to stateUpdates
		$.Dispatch('stateUpdate').subscribe(Room.handleStateUpdates);
		
		Room.updateButton();
		Room.updateStoresView();
		Room.updateIncomeView();
		Room.updateBuildButtons();
		
		Room._fireTimer = Engine.setTimeout(Room.coolFire, Room._FIRE_COOL_DELAY);
		Room._tempTimer = Engine.setTimeout(Room.adjustTemp, Room._ROOM_WARM_DELAY);
		
		/*
		 * Builder states:
		 * 0 - Approaching
		 * 1 - Collapsed
		 * 2 - Shivering
		 * 3 - Sleeping
		 * 4 - Helping
		 */
		if($SM.get('game.builder.level') >= 0 && $SM.get('game.builder.level') < 3) {
			Room._builderTimer = Engine.setTimeout(Room.updateBuilderState, Room._BUILDER_STATE_DELAY);
		}
		if($SM.get('game.builder.level') == 1 && $SM.get('stores.electricity', true) < 0) {
			Engine.setTimeout(Room.unlockForest, Room._NEED_WOOD_DELAY);
		}
		Engine.setTimeout($SM.collectIncome, 1000);

		Notifications.notify(Room, _("Banks are {0}", Room.TempEnum.fromInt($SM.get('game.temperature.value')).text));
		Notifications.notify(Room, _("Global Economy is {0}", Room.FireEnum.fromInt($SM.get('game.fire.value')).text));
	},
	
	options: {}, // Nothing for now
	
	onArrival: function(transition_diff) {
		Room.setTitle();
		if(Room.changed) {
			Notifications.notify(Room, _("Banks are {0}", Room.FireEnum.fromInt($SM.get('game.fire.value')).text));
			Notifications.notify(Room, _("Global Economy is {0}", Room.TempEnum.fromInt($SM.get('game.temperature.value')).text));
			Room.changed = false;
		}
		if($SM.get('game.builder.level') == 3) {
			$SM.add('game.builder.level', 1);
			$SM.setIncome('builder', {
				delay: 10,
				stores: {'electricity' : 2 }
			});
			Room.updateIncomeView();
			Notifications.notify(Room, _("Hal Finney email says he can help. He is basically saying he builds things."));
		}

		Engine.moveStoresView(null, transition_diff);
	},
	
	TempEnum: {
		fromInt: function(value) {
			for(var k in this) {
				if(typeof this[k].value != 'undefined' && this[k].value == value) {
					return this[k];
				}
			}
			return null;
		},
		Freezing: { value: 0, text: _('freezing') },
		Cold: { value: 1, text: _('reckless') },
		Mild: { value: 2, text: _('quite stable') },
		Warm: { value: 3, text: _('fast') },
		Hot: { value: 4, text: _('trending') }
	},
	
	FireEnum: {
		fromInt: function(value) {
			for(var k in this) {
				if(typeof this[k].value != 'undefined' && this[k].value == value) {
					return this[k];
				}
			}
			return null;
		},
		Dead: { value: 0, text: _('dead') },
		Smoldering: { value: 1, text: _('smoldering') },
		Flickering: { value: 2, text: _('flickering') },
		Burning: { value: 3, text: _('watching') },
		Roaring: { value: 4, text: _('skeptical') }
	},
	
	setTitle: function() {
		var title = $SM.get('game.fire.value') < 2 ? _("Cypherpunk room") : _("Cyprherpunk Room");
		if(Engine.activeModule == this) {
			document.title = title;
		}
		$('div#location_room').text(title);
	},
	
	updateButton: function() {
		var light = $('#lightButton.button');
		var stoke = $('#stokeButton.button');
		if($SM.get('game.fire.value') == Room.FireEnum.Dead.value && stoke.css('display') != 'none') {
			stoke.hide();
			light.show();
			if(stoke.hasClass('disabled')) {
				Button.cooldown(light);
			}
		} else if(light.css('display') != 'none') {
			stoke.show();
			light.hide();
			if(light.hasClass('disabled')) {
				Button.cooldown(stoke);
			}
		}
		
		if(!$SM.get('stores.electricity')) {
			light.addClass('free');
			stoke.addClass('free');
		} else {
			light.removeClass('free');
			stoke.removeClass('free');
		}
	},
	
	_fireTimer: null,
	_tempTimer: null,
	lightFire: function() {
		var electricity = $SM.get('stores.electricity');
		if(electricity < 5) {
			Notifications.notify(Room, _("not enough electricity to get the fire going"));
			Button.clearCooldown($('#lightButton.button'));
			return;
		} else if(electricity > 4) {
			$SM.set('stores.electricity', electricity - 5);
		}
		$SM.set('game.fire', Room.FireEnum.Burning);
		Room.onFireChange();
	},
	
	stokeFire: function() {
		var electricity = $SM.get('stores.electricity');
		if(electricity === 0) {
			Notifications.notify(Room, _("no more electricity"));
			Button.clearCooldown($('#stokeButton.button'));
			return;
		}
		if(electricity > 0) {
			$SM.set('stores.electricity',electricity - 1);
		}
		if($SM.get('game.fire.value') < 4) {
			$SM.set('game.fire', Room.FireEnum.fromInt($SM.get('game.fire.value') + 1));
		}
		Room.onFireChange();
	},
	
	onFireChange: function() {
		if(Engine.activeModule != Room) {
			Room.changed = true;
		}
		Notifications.notify(Room, _("Banks are {0}", Room.FireEnum.fromInt($SM.get('game.fire.value')).text), true);
		if($SM.get('game.fire.value') > 1 && $SM.get('game.builder.level') < 0) {
			$SM.set('game.builder.level', 0);
			Notifications.notify(Room, _("Economic Bubble is making national economy bleed. An interest to change the world is sparking in your head"));
			Engine.setTimeout(Room.updateBuilderState, Room._BUILDER_STATE_DELAY);
		}	
		window.clearTimeout(Room._fireTimer);
		Room._fireTimer = Engine.setTimeout(Room.coolFire, Room._FIRE_COOL_DELAY);
		Room.updateButton();
		Room.setTitle();
	},
	
	coolFire: function() {
		var electricity = $SM.get('stores.electricity');
		if($SM.get('game.fire.value') <= Room.FireEnum.Flickering.value &&
			$SM.get('game.builder.level') > 3 && electricity > 0) {
			Notifications.notify(Room, _("Hal Finney is excited about our project"), true);
			$SM.set('stores.electricity', electricity - 1);
			$SM.set('game.fire',Room.FireEnum.fromInt($SM.get('game.fire.value') + 1));
		}
		if($SM.get('game.fire.value') > 0) {
			$SM.set('game.fire',Room.FireEnum.fromInt($SM.get('game.fire.value') - 1));
			Room._fireTimer = Engine.setTimeout(Room.coolFire, Room._FIRE_COOL_DELAY);
			Room.onFireChange();
		}
	},
	
	adjustTemp: function() {
		var old = $SM.get('game.temperature.value');
		if($SM.get('game.temperature.value') > 0 && $SM.get('game.temperature.value') > $SM.get('game.fire.value')) {
			$SM.set('game.temperature',Room.TempEnum.fromInt($SM.get('game.temperature.value') - 1));
			Notifications.notify(Room, _("electricity in network is {0}" , Room.TempEnum.fromInt($SM.get('game.temperature.value')).text), true);
		}
		if($SM.get('game.temperature.value') < 4 && $SM.get('game.temperature.value') < $SM.get('game.fire.value')) {
			$SM.set('game.temperature', Room.TempEnum.fromInt($SM.get('game.temperature.value') + 1));
			Notifications.notify(Room, _("Our experiment called Bitcoin is {0}" , Room.TempEnum.fromInt($SM.get('game.temperature.value')).text), true);
		}
		if($SM.get('game.temperature.value') != old) {
			Room.changed = true;
		}
		Room._tempTimer = Engine.setTimeout(Room.adjustTemp, Room._ROOM_WARM_DELAY);
	},
	
	unlockForest: function() {
		$SM.set('stores.electricity', 4);
		Outside.init();
		Notifications.notify(Room, _("We are having a lack of miners in the network"));
		Engine.event('progress', 'outside');
	},
	
	updateBuilderState: function() {
		var lBuilder = $SM.get('game.builder.level');
		if(lBuilder === 0) {
			Notifications.notify(Room, _("We have received an email from a guy called Hal Finney"));
			lBuilder = $SM.setget('game.builder.level', 1);
			Engine.setTimeout(Room.unlockForest, Room._NEED_WOOD_DELAY);
		} 
		else if(lBuilder < 3 && $SM.get('game.temperature.value') >= Room.TempEnum.Warm.value) {
			var msg = "";
			switch(lBuilder) {
			case 1:
				msg = _("Without enough miners the network is slow, and thus barely used.");
				break;
			case 2:
				msg = _("Due to the popularity, you just created Bitcointalk, a forum to talk about your experiment called Bitcoin.");
				break;
			}
			Notifications.notify(Room, msg);
			if(lBuilder < 3) {
				lBuilder = $SM.setget('game.builder.level', lBuilder + 1);
			}
		}
		if(lBuilder < 3) {
			Engine.setTimeout(Room.updateBuilderState, Room._BUILDER_STATE_DELAY);
		}
		Engine.saveGame();
	},
	
	updateStoresView: function() {
		var stores = $('div#stores');
		var resources = $('div#resources');
		var special = $('div#special');
		var weapons = $('div#weapons');
		var needsAppend = false, rNeedsAppend = false, sNeedsAppend = false, wNeedsAppend = false, newRow = false;
		if(stores.length === 0) {
			stores = $('<div>').attr({
				'id': 'stores',
				'data-legend': _('Cypherpunk Room')
			}).css('opacity', 0);
			needsAppend = true;
		}
		if(resources.length === 0) {
			resources = $('<div>').attr({
				id: 'resources'
			}).css('opacity', 0);
			rNeedsAppend = true;
		}
		if(special.length === 0) {
			special = $('<div>').attr({
				id: 'special'
			}).css('opacity', 0);
			sNeedsAppend = true;
		}
		if(weapons.length === 0) {
			weapons = $('<div>').attr({
				'id': 'weapons',
				'data-legend': _('weapons')
			}).css('opacity', 0);
			wNeedsAppend = true;
		}
		for(var k in $SM.get('stores')) {
			
			var type = null;
			if(Room.Craftables[k]) {
				type = Room.Craftables[k].type;
			} else if(Room.TradeGoods[k]) {
				type = Room.TradeGoods[k].type;
			} else if (Room.MiscItems[k]) {
				type = Room.MiscItems[k].type;
			}
			
			var location;
			switch(type) {
			case 'upgrade':
				// Don't display upgrades on the Room screen
				continue;
			case 'building':
				// Don't display buildings either
				continue;
			case 'weapon':
				location = weapons;
				break;
			case 'special':
				location = special;
				break;
			default:
				location = resources;
				break;
			}
			
			var id = "row_" + k.replace(' ', '-');
			var row = $('div#' + id, location);
			var num = $SM.get('stores["'+k+'"]');
			
			if(typeof num != 'number' || isNaN(num)) {
				// No idea how counts get corrupted, but I have reason to believe that they occassionally do.
				// Build a little fence around it!
				num = 0;
				$SM.set('stores["'+k+'"]', 0);
			}
			
			var lk = _(k);
			
			// thieves?
			if(typeof $SM.get('game.thieves') == 'undefined' && num > 5000 && $SM.get('features.location.world')) {
				$SM.startThieves();
			}
			
			if(row.length === 0) {
				row = $('<div>').attr('id', id).addClass('storeRow');
				$('<div>').addClass('row_key').text(lk).appendTo(row);
				$('<div>').addClass('row_val').text(Math.floor(num)).appendTo(row);
				$('<div>').addClass('clear').appendTo(row);
				var curPrev = null;
				location.children().each(function(i) {
					var child = $(this);
					var cName = child.children('.row_key').text();
					if(cName < lk) {
						curPrev = child.attr('id');
					}
				});
				if(curPrev == null) {
					row.prependTo(location);
				} else {
					row.insertAfter(location.find('#' + curPrev));
				}
				newRow = true;
			} else {
				$('div#' + row.attr('id') + ' > div.row_val', location).text(Math.floor(num));
			}
		}
				
		if(rNeedsAppend && resources.children().length > 0) {
			resources.prependTo(stores);
			resources.animate({opacity: 1}, 300, 'linear');
		}
		
		if(sNeedsAppend && special.children().length > 0) {
			special.appendTo(stores);
			special.animate({opacity: 1}, 300, 'linear');
		}
		
		if(needsAppend && stores.find('div.storeRow').length > 0) {
			stores.appendTo('div#storesContainer');
			stores.animate({opacity: 1}, 300, 'linear');
		}
		
		if(wNeedsAppend && weapons.children().length > 0) {
			weapons.appendTo('div#storesContainer');
			weapons.animate({opacity: 1}, 300, 'linear');
		}
		
		if(newRow) {
			Room.updateIncomeView();
		}

		if($("div#outsidePanel").length) {
			Outside.updateVillage();
		}

		if($SM.get('stores.Bitcoin_Whitepaper') && !Room.pathDiscovery){
			Room.pathDiscovery = true;
			Path.openPath();
		}
	},
	
	updateIncomeView: function() {
		var stores = $('div#resources');
		var totalIncome = {};
		if(stores.length === 0 || typeof $SM.get('income') == 'undefined') return;
		$('div.storeRow', stores).each(function(index, el) {
			el = $(el);
			$('div.tooltip', el).remove();
			var ttPos = index > 10 ? 'top right' : 'bottom right';
			var tt = $('<div>').addClass('tooltip ' + ttPos);
			var storeName = el.attr('id').substring(4).replace('-', ' ');
			for(var incomeSource in $SM.get('income')) {
				var income = $SM.get('income["'+incomeSource+'"]');
				for(var store in income.stores) {
					if(store == storeName && income.stores[store] !== 0) {
						$('<div>').addClass('row_key').text(_(incomeSource)).appendTo(tt);
						$('<div>')
							.addClass('row_val')
							.text(Engine.getIncomeMsg(income.stores[store], income.delay))
							.appendTo(tt);
						if (!totalIncome[store] || totalIncome[store].income === undefined) {
							totalIncome[store] = { income: 0 };
						}
						totalIncome[store].income += Number(income.stores[store]);
						totalIncome[store].delay = income.delay;
					}
				}
			}
			if(tt.children().length > 0) {
				var total = totalIncome[storeName].income;
				$('<div>').addClass('total row_key').text(_('total')).appendTo(tt);
				$('<div>').addClass('total row_val').text(Engine.getIncomeMsg(total, totalIncome[storeName].delay)).appendTo(tt);
				tt.appendTo(el);
			}
		});
	},
	
	buy: function(buyBtn) {
		var thing = $(buyBtn).attr('buildThing');
		var good = Room.TradeGoods[thing];
		var numThings = $SM.get('stores["'+thing+'"]', true);
		if(numThings < 0) numThings = 0;
		if(good.maximum <= numThings) {
			return;
		}
		
		var storeMod = {};
		var cost = good.cost();
		for(var k in cost) {
			var have = $SM.get('stores["'+k+'"]', true);
			if(have < cost[k]) {
				Notifications.notify(Room, _("not enough " + k));
				return false;
			} else {
				storeMod[k] = have - cost[k];
			}
		}
		$SM.setM('stores', storeMod);
		
		Notifications.notify(Room, good.buildMsg);
		
		$SM.add('stores["'+thing+'"]', 1);
	},
	
	build: function(buildBtn) {
		var thing = $(buildBtn).attr('buildThing');
		if($SM.get('game.temperature.value') <= Room.TempEnum.Cold.value) {
			Notifications.notify(Room, _("Hal Finney just shivers"));
			return false;
		}
		var craftable = Room.Craftables[thing];
		
		var numThings = 0; 
		switch(craftable.type) {
		case 'good':
		case 'weapon':
		case 'tool':
		case 'upgrade':
			numThings = $SM.get('stores["'+thing+'"]', true);
			break;
		case 'building':
			numThings = $SM.get('game.buildings["'+thing+'"]', true);
			break;
		}
		
		if(numThings < 0) numThings = 0;
		if(craftable.maximum <= numThings) {
			return;
		}
		
		var storeMod = {};
		var cost = craftable.cost();
		for(var k in cost) {
			var have = $SM.get('stores["'+k+'"]', true);
			if(have < cost[k]) {
				Notifications.notify(Room, _("not enough "+k));
				return false;
			} else {
				storeMod[k] = have - cost[k];
			}
		}
		$SM.setM('stores', storeMod);
		
		Notifications.notify(Room, craftable.buildMsg);
		
		switch(craftable.type) {
		case 'good':
		case 'weapon':
		case 'upgrade':
		case 'tool':
			$SM.add('stores["'+thing+'"]', 1);
			break;
		case 'building':
			$SM.add('game.buildings["'+thing+'"]', 1);
			break;
		}		
	},
	
	needsWorkshop: function(type) {
		return type == 'weapon' || type == 'upgrade' || type =='tool';
	},
	
	craftUnlocked: function(thing) {
		if(Room.buttons[thing]) {
			return true;
		}
		if($SM.get('game.builder.level') < 4) return false;
		var craftable = Room.Craftables[thing];
		if(Room.needsWorkshop(craftable.type) && $SM.get('game.buildings["'+'workshop'+'"]', true) === 0) return false;
		var cost = craftable.cost();
		
		//show button if one has already been built
		if($SM.get('game.buildings["'+thing+'"]') > 0){
			Room.buttons[thing] = true;
			return true;
		}
		// Show buttons if we have at least 1/2 the electricity, and all other components have been seen.
		if($SM.get('stores.electricity', true) < cost['electricity'] * 0.5) {
			return false;
		}
		for(var c in cost) {
			if(!$SM.get('stores["'+c+'"]')) {
				return false;
			}
		}
		
		Room.buttons[thing] = true;
		//don't notify if it has already been built before
		if(!$SM.get('game.buildings["'+thing+'"]')){
			Notifications.notify(Room, craftable.availableMsg);
		}
		return true;
	},
	
	buyUnlocked: function(thing) {
		if(Room.buttons[thing]) {
			return true;
		} else if($SM.get('game.buildings["trading post"]', true) > 0) {
			if(thing == 'Bitcoin_Whitepaper' || typeof $SM.get('stores["'+thing+'"]') != 'undefined') {
				// Allow the purchase of stuff once you've seen it
				return true;
			}
		}
		return false;
	},
	
	updateBuildButtons: function() {
		var buildSection = $('#buildBtns');
		var needsAppend = false;
		if(buildSection.length === 0) {
			buildSection = $('<div>').attr({'id': 'buildBtns', 'data-legend': _('build:')}).css('opacity', 0);
			needsAppend = true;
		}
		
		var craftSection = $('#craftBtns');
		var cNeedsAppend = false;
		if(craftSection.length === 0 && $SM.get('game.buildings["workshop"]', true) > 0) {
			craftSection = $('<div>').attr({'id': 'craftBtns', 'data-legend': _('craft:')}).css('opacity', 0);
			cNeedsAppend = true;
		}
		
		var buySection = $('#buyBtns');
		var bNeedsAppend = false;
		if(buySection.length === 0 && $SM.get('game.buildings["trading post"]', true) > 0) {
			buySection = $('<div>').attr({'id': 'buyBtns', 'data-legend': _('buy:')}).css('opacity', 0);
			bNeedsAppend = true;
		}
		
		for(var k in Room.Craftables) {
			craftable = Room.Craftables[k];
			var max = $SM.num(k, craftable) + 1 > craftable.maximum;
			if(craftable.button == null) {
				if(Room.craftUnlocked(k)) {
					var loc = Room.needsWorkshop(craftable.type) ? craftSection : buildSection;
					craftable.button = new Button.Button({
						id: 'build_' + k,
						cost: craftable.cost(),
						text: _(k),
						click: Room.build,
						width: '80px',
						ttPos: loc.children().length > 10 ? 'top right' : 'bottom right'
					}).css('opacity', 0).attr('buildThing', k).appendTo(loc).animate({opacity: 1}, 300, 'linear');
				}
			} else {
				// refresh the tooltip
				var costTooltip = $('.tooltip', craftable.button);
				costTooltip.empty();
				var cost = craftable.cost();
				for(var c in cost) {
					$("<div>").addClass('row_key').text(_(c)).appendTo(costTooltip);
					$("<div>").addClass('row_val').text(cost[c]).appendTo(costTooltip);
				}
				if(max && !craftable.button.hasClass('disabled')) {
					Notifications.notify(Room, craftable.maxMsg);
				}
			}
			if(max) {
				Button.setDisabled(craftable.button, true);
			} else {
				Button.setDisabled(craftable.button, false);
			}
		}
		
		for(var g in Room.TradeGoods) {
			good = Room.TradeGoods[g];
			var goodsMax = $SM.num(g, good) + 1 > good.maximum;
			if(good.button == null) {
				if(Room.buyUnlocked(g)) {
					good.button = new Button.Button({
						id: 'build_' + g,
						cost: good.cost(),
						text: _(g),
						click: Room.buy,
						width: '80px',
						ttPos: buySection.children().length > 10 ? 'top right' : 'bottom right'
					}).css('opacity', 0).attr('buildThing', g).appendTo(buySection).animate({opacity:1}, 300, 'linear');
				}
			} else {
				// refresh the tooltip
				var goodsCostTooltip = $('.tooltip', good.button);
				goodsCostTooltip.empty();
				var goodCost = good.cost();
				for(var gc in goodCost) {
					$("<div>").addClass('row_key').text(_(gc)).appendTo(goodsCostTooltip);
					$("<div>").addClass('row_val').text(goodCost[gc]).appendTo(goodsCostTooltip);
				}
				if(goodsMax && !good.button.hasClass('disabled')) {
					Notifications.notify(Room, good.maxMsg);
				}
			}
			if(goodsMax) {
				Button.setDisabled(good.button, true);
			} else {
				Button.setDisabled(good.button, false);
			}
		}
		
		if(needsAppend && buildSection.children().length > 0) {
			buildSection.appendTo('div#roomPanel').animate({opacity: 1}, 300, 'linear');
		}
		if(cNeedsAppend && craftSection.children().length > 0) {
			craftSection.appendTo('div#roomPanel').animate({opacity: 1}, 300, 'linear');
		}
		if(bNeedsAppend && buildSection.children().length > 0) {
			buySection.appendTo('div#roomPanel').animate({opacity: 1}, 300, 'linear');
		}
	},
	
	Bitcoin_WhitepaperTooltip: function(direction){
		var ttPos = $('div#resources').children().length > 10 ? 'top right' : 'bottom right';
		var tt = $('<div>').addClass('tooltip ' + ttPos);
		$('<div>').addClass('row_key').text(_('the Bitcoin_Whitepaper points '+ direction)).appendTo(tt);
		tt.appendTo($('#row_Bitcoin_Whitepaper'));
	},
	
	handleStateUpdates: function(e){
		if(e.category == 'stores'){
			Room.updateStoresView();
			Room.updateBuildButtons();
		} else if(e.category == 'income'){
			Room.updateStoresView();
			Room.updateIncomeView();
		} else if(e.stateName.indexOf('game.buildings') === 0){
			Room.updateBuildButtons();
		}
	}
};
