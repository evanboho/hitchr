// railscasts version

var = currentPage = 1;

function checkScroll() {
	if (nearBottomOfPage()) {
		currentPage++;
		new Ajax.Request('/rides?page=' + currentPage, {asynchronous:true, evalScripts:true, method:'get'});
	} else {
		setTimeout("checkScroll()", 250);
	}
}

function nearBottomOfPage() {
	return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom() {
	return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
	return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

document.observe('dom:loaded', checkScroll);

// ****************************
// another version
var currentPage = 1

function checkScroll() {
  if (nearBottomOfPage()) {
    currentPage ++;
    $.ajax(window.location.pathname + '.js?page=' + currentPage )
  } else {
    setTimeout("checkScroll()", 250);
  }
}

function nearBottomOfPage() {
  return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
  return $(document).height() - ($(window).height() + $(window).scrollTop());
}