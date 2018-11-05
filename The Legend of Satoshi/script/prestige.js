var Prestige = {
		
	name: 'Prestige',

	options: {},

	init: function(options) {
		this.options = $.extend(this.options, options);
	},
	
	storesMap: [
		{ store: 'electricity', type: 'g' },
		{ store: 'graphicard', type: 'g' },
		{ store: 'Lightning', type: 'g' },
		{ store: 'iron', type: 'g' },
		{ store: 'coal', type: 'g' },
		{ store: 'sulphur', type: 'g' },
		{ store: 'steel', type: 'g' },
		{ store: 'Lighting node', type: 'g' },
		{ store: 'scales', type: 'g' },
		{ store: 'power_supply', type: 'g' },
		{ store: 'mining_rig', type: 'g' },
		{ store: 'clickbait', type: 'g' },
		{ store: 'torch', type: 'g' },
		{ store: 'cloth', type: 'g' },
		{ store: 'bone spear', type: 'w' },
		{ store: 'iron sword', type: 'w' },
		{ store: 'steel sword', type: 'w' },
		{ store: 'bayonet', type: 'w' },
		{ store: 'rifle', type: 'w' },
		{ store: 'laser rifle', type: 'w' },
		{ store: 'has_power', type: 'a' },
		{ store: 'energy cell', type: 'a' },
		{ store: 'grenade', type: 'a' },
		{ store: 'bolas', type: 'a' }
	],
	
	getStores: function(reduce) {
		var stores = [];
		
		for(var i in this.storesMap) {
			var s = this.storesMap[i];
			stores.push(Math.floor($SM.get('stores["' + s.store + '"]', true) / 
					(reduce ? this.randGen(s.type) : 1)));
		}
		
		return stores;
	},
	
	get: function() {
		return {
			stores: $SM.get('previous.stores'),
			score: $SM.get('previous.score')
		};
	},
	
	set: function(prestige) {
		$SM.set('previous.stores', prestige.stores);
		$SM.set('previous.score', prestige.score);
	},
	
	save: function() {
		$SM.set('previous.stores', this.getStores(true));
		$SM.set('previous.score', Score.totalScore());
	},
  
	collectStores : function() {
		var prevStores = $SM.get('previous.stores');
		if(prevStores != null) {
			var toAdd = {};
			for(var i in this.storesMap) {
				var s = this.storesMap[i];
				toAdd[s.store] = prevStores[i];
			}
			$SM.addM('stores', toAdd);
			
			// Loading the stores clears em from the save
			prevStores.length = 0;
		}
	},

	randGen : function(storeType) {
		var amount;
		switch(storeType) {
		case 'g':
			amount = Math.floor(Math.random() * 10);
			break;
		case 'w':
			amount = Math.floor(Math.floor(Math.random() * 10) / 2);
			break;
		case 'a':
			amount = Math.ceil(Math.random() * 10 * Math.ceil(Math.random() * 10));
			break;
		default:
			return 1;
		}
		if (amount !== 0) {
			return amount;
		}
		return 1;
	}

};
