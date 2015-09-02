<html>
	<head>
		<title>{{ site_title }}</title>

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
		<div class="jumbotron main-jumbotron">
			<div class="container">
				
			</div>
		</div>
		<div class="wrapper container">
			<div class="col-xs-12">
				<div class="featured">
					<div class="board col-xs-12 notice"> <!-- 3 Post MAx -->
						<div class="board-name">
							Notice
						</div>
						{% for n in notice %}
						<div class="board-posts">&nbsp;
							<div class="board-post-id">
								{{n.p_id}}
							</div>
							<div class="board-post-title">
								<a href="/b/notice/{{n.p_id}}/">
									{{n.p_title}}
								</a>
							</div>
							<div class="board-post-comments">
								<i class="icon ion-eye"></i>{{n.p_view}}
							</div>
							<div class="board-post-timestamp">
								{{n.p_initial_time|date("Y-m-d")}}
							</div>
						</div>
						{% endfor %}
					</div>
					<div class="board col-xs-12 all"> <!-- 8 Post MAx -->
						<div class="board-name">
							All
						</div>
						{% for p in posts %}
						<div class="board-posts">&nbsp;
							<div class="board-post-id">
								{{p.p_id}}
							</div>
							<div class="board-post-title">
								<a href="/b/{{p.p_id}}/">
									{{p.p_title}}
								</a>
							</div>
							<div class="board-post-comments">
								<i class="icon ion-eye"></i>{{p.p_view}}
							</div>
							<div class="board-post-timestamp">
								{{p.p_initial_time|date("Y-m-d")}}
							</div>
						</div>
						{% endfor %}
					</div>
				</div>
			</div>
			<div class="col-xs-3">
				{% include "login.tpl" %}
			</div>
		</div>
	</body>
</html>