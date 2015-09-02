<html>
	<head>
		<title>Tag - {{ site_title }}</title>
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
			<h2>태그</h2>
			<p>DevLog에는 게시판 대신에 태그 시스템만 존재합니다. 글을 올릴때, 글과 관련된 태그들을 여러개 달아줄 수 있으며, 다른 유저들은 그 태그를 이용해서 글을 분류하여 볼 수 있게 됩니다. 태그 시스템은 기존의 딱딱한 게시판 시스템에서 벗어나, 조금 더 유연한 커뮤니티 환경을 조성할 수 있도록 도와줍니다.</p>
			<h2>태그 다는 법</h2>
			<p>1. 글쓰기 화면의 하단의 Tag 섹션을 클릭한다.</p>
			<p class="center"><img src="/image/Tag1.PNG"></p>
			<p>2. 원하는 태그를 입력한다.</p>
			<p class="center"><img src="/image/Tag2.PNG"></p>
			<p>3. 엔터를 눌러 태그를 등록한다.</p>
			<p class="center"><img src="/image/Tag3.PNG"></p>
			<h2>Tip</h2>
			<ul>
				<li>태그는 기본적으로 대소문자 구분이 됩니다. (case sensitive)</li>
				<li>특수한 목적으로 사용되는 태그들이 존재하며, 그 태그들을 사용하면 게시글에 특정한 기능을 추가할 수 있습니다.</li>
			</ul>
			<h2>스페셜 태그</h2>
			<p>DevLog에는 스페셜 태그가 몇개 존재합니다. 그중에 중요한 태그 몇개를 소개해드립니다.</p>
			<ul>
				<li><a href="/b/notice/" class="post-tag">notice</a> - 공지사항용 태그. 운영자만 사용 가능.</li>
				<li><a href="/b/devlog:bug/" class="post-tag">devlog:bug</a> - 버그리포팅용 태그. DevLog의 버그를 보고할때 사용되는 태그입니다.</li>
				<li><a href="/b/devlog:bug/" class="post-tag">devlog:qna</a> - 질문 게시글을 만들기 위한 태그. 이 태그가 달려있는 게시글에는 댓글에도 게시글 작성시와 같은 에디터가 제공되며, 유저들이 댓글을을 추천할 수 있게 됩니다. 댓글은 자동으로 "추천 - 비추천"의 값이 큰 순으로 정렬되며, 동률일경우에는 먼저 등록된 글이 위로 가게 됩니다.</li>
			</ul>
		</div>
	</body>
</html>