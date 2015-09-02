<?php

	// Start session
	session_start();
	date_default_timezone_set('America/New_York');

	include "Twig-1.20.0/lib/Twig/Autoloader.php";

	Twig_Autoloader::register();
	try {
	// specify where to look for templates
	$loader = new Twig_Loader_Filesystem("templates");

	// initialize Twig environment
	$twig = new Twig_Environment($loader);

	// load template
	$template = $twig->loadTemplate("board.tpl");

	// set template variables
	// render template

	$user = NULL;
	$board = NULL;
	$page = 1;
	$option = "OR";

	$error = "";
	
	if(isset($_SESSION['error'])) {
		$error = $_SESSION['error'];
		unset($_SESSION['error']);
	}

	if(isset($_SESSION['user'])) {
		$user = $_SESSION['user'];
	}

	if(isset($_GET['page'])) {
		$page = $_GET['page'];
	}

	if(isset($_GET['option'])) {
		if($_GET['option'] == "OR") {
			$option = "OR";
		} else {
			$option = "AND";
		}
	}

	$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

	// Favorite Load
	$favorite = array();
	if($user) {
		$query = "SELECT * FROM dl_users_favorite WHERE uf_user = $user[u_id]";
		$result = $con->query($query);
		while($row = $result->fetch_assoc()) {
			$favorite[] = $row;
		}
	}	



	$q = array();
	$req = "";
	if(isset($_GET['query']) && $_GET['query'] != "") {
		$q = explode("/", $_GET['query']);
		$req = join($q,"/");
	}

	$postno = "";
	$max_post = 10;
	if(isset($_GET['postno'])) {
		$postno = $_GET['postno'];
		$max_post = 10;
	}

	if(array_search("all", $q)) {
		array_splice($q, array_search("all", $q), 1);
		header("location: /b/" . join($q, "/") . "/");
	}

	// Load Board Information
	 
	if(count($q) == 0) {
		$where_clause = "(true)";
	} else {
		$where_clause = build_query($q, $option, "t_name");
	}

	// Load Post List Information
	$board_id = $board['b_id'];
	$query = "SELECT * FROM dl_posts_tags JOIN dl_posts ON pt_post=p_id JOIN dl_tags ON pt_tag=t_id JOIN dl_users ON p_user=u_id WHERE $where_clause GROUP BY p_id ORDER BY p_initial_time DESC LIMIT " . (($page - 1) * $max_post) . ", " . $max_post;
	$result = $con->query($query);
	$posts = array();
	for($i = 0 ; $i < $result->num_rows ; $i++) {
		array_push($posts, $result->fetch_assoc());
	}

	// Load Post Information (If postno is set)
	$post = NULL;
	$comments = NULL;
	$post_tags = NULL;
	$qnamode = false;
	
	if(isset($_GET['postno'])) {
		$query = "SELECT * FROM dl_posts JOIN dl_users ON p_user=u_id WHERE p_id='$postno' AND p_deleted = false";
		$result = $con->query($query);
		if($result->num_rows == 1) {
			$row = $result->fetch_assoc();
			$post = $row;
		} else {
			$_SESSION['error'] = "Post Not Found";
			header("Location: /b/$_GET[query]/");
			return;
		}
		// Add View count
		$query = "UPDATE dl_posts SET p_view = p_view + 1 WHERE p_id='$postno'";
		$con->query($query);

		// Load Tag Information
		$query = "SELECT * FROM dl_posts_tags JOIN dl_tags ON pt_tag=t_id WHERE pt_post=$postno";
		$result = $con->query($query);
		$post_tags = array();
		for($i = 0 ; $i < $result->num_rows ; $i++) {
			$post_tags[] = $result->fetch_assoc();
		}
		foreach ($post_tags as $pt) {
			if($pt['t_name'] == "devlog:qna") {
				$qnamode = true;
				break;
			}
		}

		// Load Comments
		$query = "SELECT * FROM dl_comments JOIN dl_users ON c_user=u_id WHERE c_post='$postno' ORDER BY c_deleted, (c_thumb_up - c_thumb_down) DESC, c_id";
		$result = $con->query($query);
		$comments = array();
		for($i = 0 ; $i < $result->num_rows ; $i++) {
			array_push($comments, $result->fetch_assoc());
		}

	}
	

	// Page Navigation Setting.
	// Get Available post count:
	$query = "SELECT count(DISTINCT p_id) as count FROM dl_posts_tags JOIN dl_posts ON pt_post=p_id JOIN dl_tags ON pt_tag=t_id JOIN dl_users ON p_user=u_id WHERE $where_clause";
	$result = $con->query($query);
	$row = $result->fetch_assoc();
	$c = $row['count'];
	$total_pages = ceil($c / $max_post);
	$pnav = array();
	// 1. if the whole page is less than 10:
	if($total_pages < 10) {
		for($i = 1 ; $i <= $total_pages ; $i++) {
			$pnav[] = $i;
		}
	}
	// 2. if current page is less then 5:
	else if($page < 10) {
		for($i = 0 ; $i < 10 ; $i++) {
			$pnav[] = $i;
		}
	}
	// 3. if current page is less then $total_pages - 5:
	else if($page > ($total_pages - 5)) {
		for($i = $total_pages - 10 ; $i <= $total_pages ; $i++) {
			$pnav[] = $i;
		}
	}
	// else
	else {
		for($i = $page - 5 ; $i <= $page + 5 ; $i++) {
			$pnav[] = $i;
		}
	}


	echo $template->render(array(
		'site_title' => 'DevLog',
		'tag_name' => $q,
		'option' => $option,
		'req' => $req,
		'cur_page' => $page,
		'postno' => $postno,
		'posts' => $posts,
		'post' => $post,
		'post_tags' => $post_tags,
		'comments' => $comments,
		'qnamode' => $qnamode,
		'pnav' => $pnav,
		'total_pages' => $total_pages,
		'user' => $user,
		'favorite' => $favorite,
		'cur_url' => $_SERVER['REQUEST_URI'],
		'error' => $error,
		'new_msg_count' => 0,
	));

	$con->close();

	} catch (Exception $e) {
		die ('ERROR: ' . $e->getMessage());
	}

	function build_query($list, $andor, $property) {
		$ret = "(";
		for ($i=0; $i < count($list); $i++) { 
			$item = $list[$i];
			if($i == count($list)-1) {
				$ret .= "BINARY $property = '$item'";
			} else {
				$ret .= "BINARY $property = '$item' $andor ";
			}
		}
		$ret .= ")";
		return $ret;
	}
?>
