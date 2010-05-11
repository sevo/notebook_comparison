wi = function($) {

  feedback_sent = false;
  
  // This is required to get around XSS restrictions in browsers
  // when HTML base tag changes the relative URLs
  var base = window.location.host;
  
  function wiSendFeedback(value) {  	
	if (!feedback_sent) {
  		$.post('http://' + base + '/webimp/feedback?nologging', {
  		  	'url': location.href,
  			'value': value,
  			'nologging': 'true'
  		});
  		feedback_sent = true;
		document.getElementById('wiFeedback').style.display = 'none';		
  	}	
  }  
  
  $(document).ready(function() {
	  $('#wiLike').click(function() {
	  	wiSendFeedback(1);
	  });	  
	  $('#wiDislike').click(function() {
	  	wiSendFeedback(-1);
	  });	   
	  
	  $('#wiLike').hover(
	  	function() {
	  		$(this).attr('src', animate($(this).attr('src')));},
		function() {
			$(this).attr('src', normal($(this).attr('src')));	
		});
	  $('#wiDislike').hover(
	  	function() {
	  		$(this).attr('src', animate($(this).attr('src')));},
		function() {
			$(this).attr('src', normal($(this).attr('src')));	
		});	
  });
  
  function animate(filename) {
  	return filename.replace('like.png', 'like_anim.png');
  }
  
  function normal(filename) {
  	return filename.replace('like_anim.png', 'like.png');
  }

}(adaptiveProxyJQuery);