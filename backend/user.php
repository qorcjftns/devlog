<?php
	/**
	* This file controls all user related operations.
	*/

	session_start();

	// 1. Determine request type
	$request = $_POST['request'];

	// 2. Call corresponding function
	if($request == "login") {
		login();
	}
	if($request == "logout") {
		logout();
	}
	if($request == "register") {
		register();
	}
	if($request == "add-favorite") {
		addFavorite();
	}
	if($request == "delete-favorite") {
		deleteFavorite();
	}

	function login() {

		// Establish DB connection
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		// Get more fields
		$user_email = $_POST['u_email'];
		$user_pw = $_POST['u_pw'];

		$encrypted_pw = md5($user_pw);

		// Check if user exists first:
		$query = "SELECT * FROM dl_users WHERE u_email='$user_email'";
		$result = $con->query($query);
		if($result->num_rows == 1) {
			$row = $result->fetch_assoc();
			if($row['u_pw'] == $encrypted_pw) {
				$_SESSION['user'] = $row;
				header("Location: " . $_POST['from']);
				$con->close();
				return;
			}
		}
		$_SESSION['error'] = "Error! User Not Found.";
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}

	function logout() {
		unset($_SESSION['user']);
		$_SESSION['error'] = "Logout Success";
		header("Location: " . $_POST['from']);
		return;
	}

	function register() {
		// Establish DB connection
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");

		// Get more fields
		$user_email = mysqli_real_escape_string($con,$_POST['email']);
		$user_pw = md5($_POST['password']);
		$user_nickname = mysqli_real_escape_string($con,$_POST['nickname']);

		$encrypted_pw = mysqli_real_escape_string($con,$user_pw);

		// Validation Check
		// 1. Check if valid email
		// 2. Check if email already registered
		$query = "SELECT * FROM dl_users WHERE u_email='$user_email'";
		$result = $con->query($query);
		if($result->num_rows >= 1) {
			$_SESSION['error'] = "Error! Email already registered. Please try another email.";
			$con->close();
			header("Location: " . $_POST['from']);
			return;
		}
		// 3. Check Nickname Length
		if(strlen($user_nickname) < 4) {
			$_SESSION['error'] = "Error! Nickname length must be greater than 3.";
			$con->close();
			header("Location: " . $_POST['from']);
			return;	
		}
		// 3. Check Nickname Duplication
		$query = "SELECT * FROM dl_users WHERE u_nickname='$user_nickname'";
		$result = $con->query($query);
		if($result->num_rows >= 1) {
			$_SESSION['error'] = "Error! Nickname already registered. Please try another nickname.";
			$con->close();
			header("Location: " . $_POST['from']);
			return;
		}

		// Check if user exists first:
		$query = "INSERT INTO dl_users (u_email, u_pw, u_nickname) VALUES ('$user_email', '$user_pw', '$user_nickname')";
		$result = $con->query($query);

		$query = "SELECT * FROM dl_users WHERE u_email='$user_email'";
		$result = $con->query($query);
		$_SESSION['user'] = $result->fetch_assoc();
		$con->close();
		header("Location: " . $_POST['from']);
		return;
	}

	function addFavorite() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] = "Error! You should login first in order to add favorite tags.";
			$con->close();
			header("Location: " . $_POST['from']);
			return;	
		}
		$user = $_SESSION['user'];
		$option = $_POST['option'];
		$favorite = $_POST['include-tags'];
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");
		$query = "SELECT * FROM dl_users_favorite WHERE uf_user=$user[u_id] AND uf_favorite='$favorite' AND uf_option='$option'";
		$result = $con->query($query);
		if($result->num_rows >= 1) {
			if(!isset($_SESSION['user'])) {
				$_SESSION['error'] = "The requested favorite tag query was already in your favorite list.";
				$con->close();
				header("Location: " . $_POST['from']);
				return;	
			}
		}
		$query = "INSERT INTO dl_users_favorite (uf_user, uf_favorite, uf_option) VALUES ($user[u_id] ,'$favorite', '$option')";
		$con->query($query);
		echo $con->error;
		header("Location: " . $_POST['from']);
		return;
	}
	function deleteFavorite() {
		if(!isset($_SESSION['user'])) {
			$_SESSION['error'] = "Error! You should login first in order to add favorite tags.";
			$con->close();
			header("Location: " . $_POST['from']);
			return;	
		}
		$user = $_SESSION['user'];
		$option = $_POST['option'];
		$favorite = $_POST['include-tags'];
		$con = new mysqli("localhost", "root", "cjftns119", "DevLog");
		$query = "SELECT * FROM dl_users_favorite WHERE uf_user=$user[u_id] AND uf_favorite='$favorite' AND uf_option='$option'";
		$result = $con->query($query);
		if($result->num_rows == 1) {
			if(!isset($_SESSION['user'])) {
				$_SESSION['error'] = "The requested favorite tag was not found.";
				$con->close();
				header("Location: " . $_POST['from']);
				return;	
			}
		}
		$query = "DELETE FROM dl_users_favorite WHERE uf_user=$user[u_id] AND uf_favorite='$favorite' AND uf_option='$option'";
		$con->query($query);
		echo $con->error;
		header("Location: " . $_POST['from']);
		return;
	}

?>