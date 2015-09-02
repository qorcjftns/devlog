<?php

	// Start session
	session_start();

	include "Twig-1.20.0/lib/Twig/Autoloader.php";

	Twig_Autoloader::register();
	try {
	// specify where to look for templates
	$loader = new Twig_Loader_Filesystem("templates");

	// initialize Twig environment
	$twig = new Twig_Environment($loader);

	$page = "tag";
	if(isset($_GET['query'])) {
		$page = $_GET['query'];
	}

	// load template
	$template = $twig->loadTemplate("manual/" . $_GET['query'] . ".tpl");

	// set template variables
	// render template

	$user = NULL;

	$error = "";
	
	if(isset($_SESSION['error'])) {
		$error = $_SESSION['error'];
		unset($_SESSION['error']);
	}

	if(isset($_SESSION['user'])) {
		$user = $_SESSION['user'];
	}

	echo $template->render(array(
		'site_title' => 'DevLog',
		'user' => $user,
		'cur_url' => $_SERVER['REQUEST_URI'],
		'error' => $error,
		'new_msg_count' => 0,
	));

	} catch (Exception $e) {
		die ('ERROR: ' . $e->getMessage());
	}
?>
