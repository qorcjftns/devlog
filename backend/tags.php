<?php
	$con = new mysqli("localhost", "root", "cjftns119", "DevLog");
	$term = mysqli_real_escape_string($con, $_GET['term']);
	$query = "SELECT * FROM dl_tags WHERE t_name LIKE '%$term%' ORDER BY t_name";
	$result = $con->query($query);
	$rows = array();
	while($r = $result->fetch_assoc()) {
		$query = "SELECT count(*) AS count FROM dl_posts_tags WHERE pt_tag=$r[t_id]";
		$counter = $con->query($query);
		$counter_row = $counter->fetch_assoc();
		$rows[] = array(
			"label" => $r['t_name'] . " (" . $counter_row['count'] . ")",
			"value" => $r['t_name']
			);
	}
	echo json_encode($rows);
?>