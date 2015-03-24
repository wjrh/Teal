
//recurring refreshes
setInterval( "updateSongInfo();", 7000 );

$(function() {
	updateSongInfo = function(){

		$('#djdata').load("show_dj.php").fadeIn("slow");
		$('#songdata').load("show_song.php").fadeIn("slow");
	}
});

//first refresh
$(document).ready(function(){
		$('#djdata').load("show_dj.php").fadeIn("slow");
		$('#songdata').load("show_song.php").fadeIn("slow");
});


var checkData = function(){
	if ($("#songdata").text().length > 50 || $("#djdata").text() == "WJRH RoboDJ\n"){
		$("#nowplaying-dj").hide();
	} else {
		$("#nowplaying-dj").show();
	}
}


$( document ).ajaxComplete(function() {
  checkData();
});