<html>
	<head>
		<title>About - {{ site_title }}</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">

		<script src="/jquery/jquery-1.11.2.min.js"></script>
			<script src="/jquery/jquery-migrate-1.2.1.min.js"></script>
			
			<!-- jQueryUI -->
			<link rel="stylesheet" href="/jqueryui/jquery-ui.min.css">
			<script src="/jqueryui/jquery-ui.min.js"></script>
			<script type="text/javascript">
			$.widget.bridge('uitooltip', $.ui.tooltip);
			</script>
			
			<!-- BOOTSTRAP -->
			<link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
			<script src="/bootstrap/js/bootstrap.min.js"></script>

			<link href="/css/styles.css" rel="stylesheet" />
			<link href="/css/ionicons.css" rel="stylesheet" />

			<script src="/ckeditor/ckeditor.js"></script>
			<script src="/js/board.js"></script>

			{% if error %}
			<script type="text/javascript">
				alert("{{error}}")
			</script>
			{% endif %}
	</head>
	<body>
		{% include "header.tpl" %}
		{% include "write.tpl" %}
		{% include "login.tpl" %}
		<div class="wrapper container">
			<h2><img src="/image/Logo.png"></h2>
			<p class="center"></p>
			<p>DevLog는 개발자들의 커뮤니티입니다. 코딩에 관련된 질문, 토론, 유머 등을 자유롭게 공유하며 개발자들간의 활발한 정보공유가 이루어지는 것이 목표입니다. 단일게시판 형식을 채택하여 진입장벽을 쉽게 하고자 하였으며, 대신에 태그 시스템을 이용해서 글의 분류를 하게 됩니다. 게시글에 다양한 태그를 달게 하므로서 진입장벽을 낮추고 더 활발한 커뮤니티 활동이 이루어지게 유도하였습니다.</p>
			<h2>DevLog 패치노트</h2>
			<p>아래는 DevLog의 패치내역입니다. 세세한 내역까지는 공개되지 않을 수 있습니다.</p>
			<ul>
				<li>2015-09-01 Launch</li>
				<li>2015-09-03
					<ul>
						<li>Added Support for Korean Tags</li>
						<li>Register bug fixed</li>
						<li>Added feature to add image/file.</li>
					</ul>
				</li>
			</ul>
			<h2>Powered By</h2>
			<ul>
				<li><a href="http://getbootstrap.com/">Bootstrap</a></li>
				<li><a href="http://ionicons.com">Ionicons</a></li>
			</ul>
		</div>
	</body>
</html>