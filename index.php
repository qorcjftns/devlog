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

	// load template
	$template = $twig->loadTemplate("index.tpl");

	// set template variables
	// render template
	$con = new mysqli("localhost", "root", "cjftns119", "DevLog");
	$query = "SELECT * FROM dl_posts_tags JOIN dl_posts ON pt_post=p_id JOIN dl_tags ON pt_tag=t_id JOIN dl_users ON p_user=u_id WHERE t_name='notice' GROUP BY p_id ORDER BY p_initial_time DESC LIMIT 4";
	$result = $con->query($query);
	$notice = array();
	for($i = 0 ; $i < $result->num_rows ; $i++) {
		array_push($notice, $result->fetch_assoc());
	}

	$query = "SELECT * FROM dl_posts ORDER BY p_initial_time DESC LIMIT 8";
	$result = $con->query($query);
	$posts = array();
	for($i = 0 ; $i < $result->num_rows ; $i++) {
		array_push($posts, $result->fetch_assoc());
	}

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
		'notice' => $notice,
		'posts' => $posts,
		'user' => $user,
		'cur_url' => $_SERVER['REQUEST_URI'],
		'error' => $error,
		'new_msg_count' => 0,
	));

	} catch (Exception $e) {
		die ('ERROR: ' . $e->getMessage());
	}
?>
