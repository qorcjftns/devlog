<?php

$upload_dir = "../image/uploads/";
$filename = tempnam($upload_dir, '');
unlink($filename);
$milliseconds = round(microtime(true) * 1000);
if (file_exists($upload_dir . $milliseconds . $_FILES["upload"]["name"])) {
	echo $_FILES["upload"]["name"] . " already exists please choose another image.";
} else {
	move_uploaded_file($_FILES["upload"]["tmp_name"], $upload_dir . $milliseconds . $_FILES["upload"]["name"]);

	// Required: anonymous function reference number as explained above.
	$funcNum = $_GET['CKEditorFuncNum'] ;
	// Optional: instance name (might be used to load a specific configuration file or anything else).
	$CKEditor = $_GET['CKEditor'] ;
	// Optional: might be used to provide localized messages.
	$langCode = $_GET['langCode'] ;
	 
	// Check the $_FILES array and save the file. Assign the correct path to a variable ($url).
	$url = "image/uploads/" . $milliseconds . $_FILES["upload"]["name"];
	// Usually you will only assign something here if the file could not be uploaded.
	$message = '';
	 
	echo "<script> window.parent.CKEDITOR.tools.callFunction($funcNum, location.protocol + '//' + location.hostname + '/' + '$url', '$message');</script>";
}

?>