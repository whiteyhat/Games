define(function() {
	
	var SITE_URL = encodeURIComponent("http://satoshis.games");
	var links = [
		{
			className: 'twitter',
			url: 'https://twitter.com/intent/tweet?text=Get%20paid%20while%20gaming!&url=' + SITE_URL,
			name: 'Twitter'
		},  {
			className: 'reddit',
			url: 'http://www.reddit.com/submit?url=' + SITE_URL,
			name: 'Reddit'
		}
	];
	
	var _el = null;
	function el() {
		var G = require('app/graphics/graphics');
		if(_el == null) {
			G.addStyleRule('.social:before', 'content:"- ' + G.getText('SHARE') + ' -";');
			_el = G.make('social submenu', 'ul');
			links.forEach(function(link) {
				var l = G.make('litBorder', 'li').appendTo(_el);
				G.make(link.className).appendTo(l);
				G.make(link.className + ' nightSprite', 'a').attr({
					href: link.url,
					target: '_blank',
					title: link.name
				}).click(function() {
					require('app/eventmanager').trigger('click', [link.className]);
				}).appendTo(l);
			});
		}
		
		return _el;
	}
	
	return {
		init: function() {
			var G = require('app/graphics/graphics');
			G.addToMenu(el());
		}
	};
});