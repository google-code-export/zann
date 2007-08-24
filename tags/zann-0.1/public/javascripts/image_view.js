
function setPhotoScale(intScale){
	var scale = intScale;
	if (intScale < 50 || intScale > 100) {
		scale = 100;
	}
	document.images["viewedimage"].width = Math.round((intPhotoW * scale) / 100);
}
function bg(color){
	document.getElementById("imagebg").style.backgroundColor = color;
}