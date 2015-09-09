<?php

	session_start();

	$request = $_POST['request'];

	if($request == "comment-add") {
		addComment();
	}
	if($request == "comment-edit") {
		editComment();
	}
	if($request == "comment-delete") {
		deleteComment();
	}
	if($request == "comment-thumb-up") {
		thumbUp();
	}
	if($request == "comment-thumb-down") {
		thumbDown();
	}
	if($request == "post-add") {
		addPost();
	}
	if($request == "post-edit") {
		editPost();
	}
	if($request == "post-delete") {
		deletePost();
	}

	function escapeText($text) {
		$result = "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">" . $text;
		$dom = new DOMDocument();

		$dom->loadHTML($result);

		$script = $dom->getElementsByTagName('script');

		$remove = [];
		foreach($script as $item)
		{
		  $remove[] = $item;
		}

		foreach ($remove as $item)
		{
		  $item->parentNode->removeChild($item); 
		}

		$xpath = new DOMXPath($dom);            // create a new XPath
		/*
		$nodes = $xpath->query('//*[@style]');  // Find elements with a style attribute
		foreach ($nodes as $node) {              // Iterate over found elements
			$node->removeAttribute('style');    // Remove style attribute
		}
		*/

		$result = $dom->saveHTML();
		return $result;
	}

	function addComment() {
		// get user information
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$post = $_POST['post'];
		$body = "";
		if($_POST['qnacomment'] == 1) {
			$body = mysqli_real_escape_string($con, escapeText($_POST['comment-body']));
		} else {
			$body = mysqli_real_escape_string($con, $_POST['comment-body']);
		}

		$query = "INSERT INTO dl_comments (c_post, c_body, c_user) VALUES ($post, '$body', $user_id)";
		$con->query($query);
		$con->close();
		echo $query;
		header("Location: " . $_POST['from']);
		return;
	}
	function editComment() {
		// get user information
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$c_id = $_POST['c_id'];
		$body = "";
		if($_POST['qnacomment'] == 1) {
			$body = mysqli_real_escape_string($con, escapeText($_POST['comment-body']));
		} else {
			$body = mysqli_real_escape_string($con, $_POST['comment-body']);
		}

		$query = "UPDATE dl_comments SET c_body = '$body' WHERE c_id='$c_id'";
		$con->query($query);
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}

	function deleteComment() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$comment_id = $_POST['c_id'];

		// Check if the user can delete post.
		$query = "SELECT c_user FROM dl_comments WHERE c_id=$comment_id";
		$result = $con->query($query);
		$row = $result->fetch_assoc();
		if($row['c_user'] != $user_id) {
			$_SESSION['error'] .= "You don't have permission to delete this post. ($row[c_user] and $user_id)";
			header("Location: " . $_POST['from']);
			return;
		}

		$query = "UPDATE dl_comments SET c_deleted = true WHERE c_id=$comment_id";
		$con->query($query);
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}

	function thumbCheckValid() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");
		$user_id = $_SESSION['user']['u_id'];
		$comment_id = $_POST['c_id'];
		
		$query = "SELECT * FROM dl_comments_thumb WHERE ct_user = $user_id AND ct_comment = $comment_id";
		$result = $con->query($query);
		$ret = true;
		if($result->num_rows > 0) {
			$ret = false;
		}
		$con->close();
		return $ret;
	}

	function thumbUp() {
		if(!thumbCheckValid()) {
			$_SESSION['error'] .= "You already thumbed up this comment.";
			header("Location: " . $_POST['from']);
			return;
		}
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$comment_id = $_POST['c_id'];
		
		$query = "UPDATE dl_comments SET c_thumb_up = c_thumb_up + 1 WHERE c_id=$comment_id";
		$con->query($query);
		$query = "INSERT INTO dl_comments_thumb (ct_comment, ct_user) VALUES ($comment_id, $user_id)";
		$con->query($query);
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}
	function thumbDown() {
		if(!thumbCheckValid()) {
			$_SESSION['error'] .= "You already thumbed down this comment.";
			header("Location: " . $_POST['from']);
			return;
		}
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$comment_id = $_POST['c_id'];

		$query = "UPDATE dl_comments SET c_thumb_up = c_thumb_down + 1 WHERE c_id=$comment_id";
		$con->query($query);
		$query = "INSERT INTO dl_comments_thumb (ct_comment, ct_user) VALUES ($comment_id, $user_id)";
		$con->query($query);
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}

	function addPost() {
		// get user information
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}
		if(!isset($_POST['tag']) || count($_POST['tag']) == 0) {
			$_SESSION['error'] .= "Please set more than one tag.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$tags = $_POST['tag'];

		// Check if there is bad tag
		for($i = 0 ; $i < count($tags) ; $i++) {
			$tag = mysqli_real_escape_string($con,$tags[$i]);
			$query = "SELECT t_special FROM dl_tags WHERE BINARY t_name = '$tag'";
			$result = $con->query($query);
			if($result->num_rows > 0) {
				$row = $result->fetch_assoc();
				if($row['t_special'] == 1) {
					$_SESSION['error'] .= "Tag '".$tag."' is not valid. Please try different tag name.";
					header("Location: " . $_POST['from']);
					return;
				}
			}
		}
		

		$user_id = $_SESSION['user']['u_id'];
		$title = mysqli_real_escape_string($con, $_POST['title']);
		$body = mysqli_real_escape_string($con, escapeText($_POST['body']));
		$raw = mysqli_real_escape_string($con, $_POST['body']);

		$query = "INSERT INTO dl_posts (p_title, p_body, p_body_raw, p_user) VALUES ('$title', '$body', '$raw', $user_id)";
		$con->query($query);

		$post_id = $con->insert_id;


		// tags
		for($i = 0 ; $i < count($tags) ; $i++) {
			$tag = mysqli_real_escape_string($con,$tags[$i]);

			$query = "SELECT t_id FROM dl_tags WHERE BINARY t_name = '$tag'";
			$result = $con->query($query);
			if($result->num_rows == 0) {
				$query = "INSERT INTO dl_tags(t_name) VALUES ('$tag')";
				$con->query($query);
				$query = "SELECT t_id FROM dl_tags WHERE BINARY t_name = '$tag'";
				$result = $con->query($query);
			}
			$row = $result->fetch_assoc();
			$query = "INSERT INTO dl_posts_tags(pt_post, pt_tag) VALUES ($post_id, $row[t_id])";
			$con->query($query);
		}

		$con->close();
		header("Location: /b/" . join($tags, "/") . "/" . $post_id );
		return;
	}

	function editPost() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}
		if(!isset($_POST['tag']) || count($_POST['tag']) == 0) {
			$_SESSION['error'] .= "Please set more than one tag.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$post_id = $_POST['p_id'];
		$title = mysqli_real_escape_string($con, $_POST['title']);
		$body = mysqli_real_escape_string($con, escapeText($_POST['body']));
		$raw = mysqli_real_escape_string($con, $_POST['body']);

		// Check if the user can delete post.
		$query = "SELECT p_user FROM dl_posts WHERE p_id=$post_id";
		$result = $con->query($query);
		$row = $result->fetch_assoc();
		if($row['p_user'] != $user_id) {
			$_SESSION['error'] .= "You don't have permission to delete this post.";
			header("Location: " . $_POST['from']);
			return;
		}

		$tags = $_POST['tag'];

		// Check if there is bad tag
		for($i = 0 ; $i < count($tags) ; $i++) {
			$tag = mysqli_real_escape_string($con,$tags[$i]);
			$query = "SELECT t_special FROM dl_tags WHERE BINARY t_name = '$tag'";
			$result = $con->query($query);
			if($result->num_rows > 0) {
				$row = $result->fetch_assoc();
				if($row['t_special'] == 1) {
					$_SESSION['error'] .= "Tag '".$tag."' is not valid. Please try different tag name.";
					header("Location: " . $_POST['from']);
					return;
				}
			}
		}

		// Remove tag list.
		$query = "DELETE FROM dl_posts_tags WHERE pt_post=$post_id";
		$con->query($query);

		// tags
		for($i = 0 ; $i < count($tags) ; $i++) {
			$tag = mysqli_real_escape_string($con,$tags[$i]);
			
			$query = "SELECT t_id FROM dl_tags WHERE BINARY t_name = '$tag'";
			$result = $con->query($query);
			if($result->num_rows == 0) {
				$query = "INSERT INTO dl_tags(t_name) VALUES ('$tag')";
				$con->query($query);
				$query = "SELECT t_id FROM dl_tags WHERE BINARY t_name = '$tag'";
				$result = $con->query($query);
			}
			$row = $result->fetch_assoc();
			$query = "INSERT INTO dl_posts_tags(pt_post, pt_tag) VALUES ($post_id, $row[t_id])";
			$con->query($query);
			echo "$tag($row[t_id]) : " . $con->error . "<br>";
		}

		$query = "UPDATE dl_posts SET p_title = '$title', p_body = '$body', p_body_raw = '$raw' WHERE p_id=$post_id";
		$con->query($query);
		$con->close();
		header("Location: /b/" . join($tags, "/") . "/" . $post_id );
		return;
	}

	function deletePost() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] .= "Please Log in and retry.";
			header("Location: " . $_POST['from']);
			return;
		}

		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		$user_id = $_SESSION['user']['u_id'];
		$post_id = $_POST['p_id'];

		// Check if the user can delete post.
		$query = "SELECT p_user FROM dl_posts WHERE p_id=$post_id";
		$result = $con->query($query);
		$row = $result->fetch_assoc();
		if($row['p_user'] != $user_id) {
			$_SESSION['error'] .= "You don't have permission to delete this post.";
			header("Location: " . $_POST['from']);
			return;
		}

		$query = "UPDATE dl_posts SET p_deleted = true WHERE p_id=$post_id";
		$con->query($query);
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}
?>
