define(function() {
	
	var providers = [
		
	
		'<div class="bitcoin">' +
			'<a onclick="require(\'app/eventmanager\').trigger(\'click\', [\'bitcoin\']);" href="3Q5peHUTmipwHAQbHds93XAyzEfp8atdPN" ' +
				'data-info="none" data-address="3Q5peHUTmipwHAQbHds93XAyzEfp8atdPN" ' +
				'class="bitcoin-button nightSprite" target="_blank"></a>' +
			'<input type="image" alt=" " class="bitcoin-button"></input>' + 
			
			
			'<div class="bitcoin-bubble">' +
				'<img width="200" height="200" alt="QR code" ' +
					'src="https://chart.googleapis.com/chart?chs=200x200&amp;cht=qr&amp;chld=H|0&amp;chl=bitcoin%3A3Q5peHUTmipwHAQbHds93XAyzEfp8atdPN">' +
				'3Q5peHUTmipwHAQbHds93XAyzEfp8atdPN' + 
			'</div>' +
		'</div>',

		
		'<div class="bitcoin">' +
			'<a onclick="require(\'app/eventmanager\').trigger(\'click\', [\'bitcoin\']);" href="0x3a19B946916C97A2C5972bFdebb7aDbbc2dF47bd" ' +
				'data-info="none" data-address="0x3a19B946916C97A2C5972bFdebb7aDbbc2dF47bd" ' +
				'class="bitcoin-button nightSprite" target="_blank"></a>' +
				'<input type="image" alt=" " class="flattr"></input>' +
			
			
			'<div class="bitcoin-bubble">' +
				'<img width="200" height="200" alt="QR code" ' +
					'src="https://chart.googleapis.com/chart?chs=200x200&amp;cht=qr&amp;chld=H|0&amp;chl=bitcoin%3A0x3a19B946916C97A2C5972bFdebb7aDbbc2dF47bd">' +
				'0x3a19B946916C97A2C5972bFdebb7aDbbc2dF47bd' + 
			'</div>' +
		'</div>',

	];
	
	var _el = null;
	function el() {
		var G = require('app/graphics/graphics');
		if(_el == null) {
			G.addStyleRule('.donate:before', 'content:"- ' + G.getText('DONATE') + ' -";');
			_el = G.make('donate submenu', 'ul');
			providers.forEach(function(link) {
				G.make('litBorder', 'li').html(link).appendTo(_el);
			});
		}
		
		return _el;
	}
	
	return {
		init: function() {
			require('app/graphics/graphics').addToMenu(el());
		}
	};
});