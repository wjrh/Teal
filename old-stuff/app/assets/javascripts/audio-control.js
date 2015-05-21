var listenButton = document.getElementById('listen-button');
var liveIcon = document.getElementById('liveicon');

var audioElement = document.createElement('audio');
audioElement.setAttribute('src', 'http://wjrh.org:8000/wjrh');
// audioElement.setAttribute('preload', 'auto');

var playClicked = false;
var loaded = false;

//plays wjrh audio
function PlayAudio()
{
	playClicked = true;
	audioElement.load;
	listenButton.innerHTML = "LOADING";
	liveIcon.innerHTML = "<i class=\"fa fa-cloud-download\"></i>";
	audioElement.play();
	if(loaded){
		liveOnAir();
	}
}

//pauses wjrh audio
function PauseAudio()
{
	audioElement.pause();
	listenButton.innerHTML = "PAUSED";
	liveIcon.innerHTML = "<i class=\"fa fa-pause\"></i>";
}

//this is the action that comes from the toggle button
function togglePlay() {
	if (audioElement.paused) {
		PlayAudio();
	} else { 
		PauseAudio();
	}
}

//called when we want "live on air" displayed on the button
function liveOnAir(){
	listenButton.innerHTML = "LIVE ON AIR";
    liveIcon.innerHTML = "• ";
}

//called by the audio element when the data is loaded enough to play
audioElement.onloadeddata = function() {
	loaded = true;
	if (playClicked){
		liveOnAir();
	}
};
