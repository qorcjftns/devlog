<html>
	<head>
		{% if post %}
		<title>{{ post.p_title }} - {{site_title}}</title>
		{% else %}
		<title>{{ site_title }}</title>
		{% endif %}
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">

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

			<!-- CKEditor -->
			<script src="/ckeditor/ckeditor.js"></script>
			<link href="/ckeditor/plugins/codesnippet/lib/highlight/styles/default.css" rel="stylesheet">
			<script src="/ckeditor/plugins/codesnippet/lib/highlight/highlight.pack.js"></script>
			<script>hljs.initHighlightingOnLoad();</script>

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
			<div class="tag-filter">
				<h1>Tag 
					<form class="favorite-form" action="/backend/user.php" method="POST">
						<input type="hidden" name="from" value="{{cur_url}}" />
						<input type="hidden" name="request" value="add-favorite" />
						<input type="hidden" name="option" value="{{option}}" />
						<input type="hidden" name="include-tags" value="{{tag_name|join("/")}}" />
						<button class="btn btn-default"><i class="ion-star"></i> Add to Favorite</button>
					</form>
				</h1>
				<select onchange="changeFilterOption(this);" name="option">
					<option {{option == "AND" ? "selected"}} value="AND">AND</option>
					<option {{option == "OR" ? "selected"}} value="OR">OR</option>
				</select>
				{% for t in tag_name %}
					<a class="post-tag header" href="/b/{{t}}/">{{t}} <i class="ion-close" onclick="removeTagFilter('{{t}}');return false;"></i></a>
				{% endfor %}
				<input type="text" name="new-filter" placeholder="New Filter..."  onkeypress="return addTagFilter(this);"/>
			</div>			

			{% if postno %}
			<div class="col-xs-12 post-wrapper">
				<div class="post-header">
					<strong>{{post.p_title}}</strong>
				</div>
				<div class="post-info">&nbsp;
					<div class="post-user pull-left">
						<i class="ion-person"></i> {{post.u_nickname}}
					</div>
					<div class="post-user pull-right align-right">
						{{post.p_initial_time}}
					</div>
					<div class="align-right">
						{% if user.u_id == post.p_user %}
						<a data-toggle="modal" data-target="#edit-post">Edit</a>
						{% else %}
						<a>Report</a>
						{% endif %}
					</div>
				</div>
				<div class="post-content">
					{{post.p_body|raw}}
				</div>
				<div class="post-tags">
					<h3>Tags</h3>
					{% for tag in post_tags %}
						<a class="post-tag" href="/b/{{tag.t_name}}/">
							{{tag.t_name}}
						</a>
					{% endfor %}
				</div>
				<div class="post-comments">
					<h3>Comments</h3>
					{% set c_first = true %}
					{% for c in comments %}
						<div class="row comment {{ c.c_deleted ? 'deleted' : '' }} {{ c_first ? 'first' : '' }} comment-{{c.c_id}}">
							<div class="comment-head">
								<div class="comment-user"><i class="ion-person"></i> {{c.u_nickname}}</div>
								<div class="comment-timestamp">{{c.c_initial_time|date("Y-m-d H:i")}}</div>
								{% if not c.c_deleted %}
								<div class="comment-recommend">
									<i class="ion-happy"></i> {{c.c_thumb_up}} <i class="ion-sad"></i> {{c.c_thumb_down}}
								</div>
								<div class="comment-tool">
									{% if user.u_id == c.c_user %}
									<form action="/backend/post.php" method="POST">
										<input type="hidden" name="request" value="comment-delete" />
										<input type="hidden" name="from" value="{{cur_url}}" />
										<input type="hidden" name="c_id" value="{{c.c_id}}" />
										<button data-toggle="tooltip" data-placement="top" data-original-title="Delete" class="btn btn-danger pull-right" onclick="return deleteComment({{c.c_id}});"><i class="ion-close-circled"></i></button>
									</form>
									<form action="/backend/post.php" method="POST">
										<input type="hidden" name="request" value="comment-edit" />
										<input type="hidden" name="from" value="{{cur_url}}" />
										<input type="hidden" name="c_id" value="{{c.c_id}}" />
									</form>
									<button data-toggle="tooltip" onclick="editComment('comment-{{c.c_id}}');" data-placement="top" data-original-title="Edit" class="btn btn-warning pull-right"><i class="ion-edit"></i></button>
									{% else %}
										{% if user %}
										<button data-toggle="tooltip" data-placement="top" data-original-title="Report" class="btn btn-danger pull-right"><i class="ion-alert"></i></button>
										<form action="/backend/post.php" method="POST">
											<input type="hidden" name="request" value="comment-thumb-down" />
											<input type="hidden" name="from" value="{{cur_url}}" />
											<input type="hidden" name="c_id" value="{{c.c_id}}" />
											<button data-toggle="tooltip" data-placement="top" data-original-title="Bad" class="btn btn-default pull-right"><i class="ion-sad"></i></button>
										</form>
										<form action="/backend/post.php" method="POST">
											<input type="hidden" name="request" value="comment-thumb-up" />
											<input type="hidden" name="from" value="{{cur_url}}" />
											<input type="hidden" name="c_id" value="{{c.c_id}}" />
											<button data-toggle="tooltip" data-placement="top" data-original-title="Good" class="btn btn-default pull-right"><i class="ion-happy"></i></button>
										</form>
										{% endif %}
									{% endif %}
								</div>
								{% endif %}
							</div>
							<div class="comment-body">
								{% if c.c_deleted %}
									<strong>This is deleted comment.</strong>
								{% else %}
									{% if qnamode %}
										{{c.c_body|raw }}
									{% else %}
										{{c.c_body|nl2br }}
									{% endif %}
								{% endif %}
							</div>
							<div class="comment-edit-body">
								<br/>
								{% if qnamode %}
									<form action="/backend/post.php" method="POST" class="align-right">
									<input type="hidden" name="request" value="comment-edit" />
									<input type="hidden" name="from" value="{{cur_url}}" />
									<input type="hidden" name="c_id" value="{{c.c_id}}" />
									<input type="hidden" name="qnacomment" value="1" />
									<textarea name="comment-body" id="qnacomment-{{c.c_id}}">
										{{c.c_body|raw }}
									</textarea>
									<button type="button" onclick="cancelEditComment('comment-{{c.c_id}}');" class="qnamode comment-submit btn btn-default">Cancel</button>
									<button class="qnamode comment-submit btn btn-primary">Submit</button>
									</form>
									<script type="text/javascript">
										CKEDITOR.replace( 'qnacomment-{{c.c_id}}', {height:"150px",filebrowserUploadUrl: '/backend/upload.php'});
									</script>
								{% else %}
									<form action="/backend/post.php" method="POST" class="align-right">
									<input type="hidden" name="request" value="comment-edit" />
									<input type="hidden" name="from" value="{{cur_url}}" />
									<input type="hidden" name="post" value="{{post.p_id}}" />
									<input type="hidden" name="qnacomment" value="1" />
									{{c.c_body|nl2br }}
									<textarea>{{c.c_body}}</textarea>
									</form>
								{% endif %}
							</div>
						</div>
						{% set c_first = false %}
					{% endfor %}
					<h4>Add Comment</h4>
					{% if qnamode %}
					<form action="/backend/post.php" method="POST" class="align-right">
						<input type="hidden" name="request" value="comment-add" />
						<input type="hidden" name="from" value="{{cur_url}}" />
						<input type="hidden" name="post" value="{{post.p_id}}" />
						<input type="hidden" name="qnacomment" value="1" />
						<textarea id="qnacomment" {{ user?'':'disabled'}} class="comment-write" name="comment-body"></textarea><button class="qnamode comment-submit btn btn-primary">Submit</button>
					</form>
					<script type="text/javascript">
						var editor = CKEDITOR.replace( 'qnacomment', {filebrowserUploadUrl: '/backend/upload.php'} );
					</script>
					{% else %}
					<form action="/backend/post.php" method="POST">
						<input type="hidden" name="request" value="comment-add" />
						<input type="hidden" name="from" value="{{cur_url}}" />
						<input type="hidden" name="post" value="{{post.p_id}}" />
						<input type="hidden" name="qnacomment" value="0" />
						{% if user %}
						<textarea class="comment-write" name="comment-body"></textarea><button class="comment-submit btn btn-primary">Submit</button>
						{% else %}
						<textarea disabled class="comment-write" name="comment-body"></textarea><button disabled class="comment-submit btn btn-primary">Submit</button>
						{% endif %}
					</form>
					{% endif %}
				</div>
			</div>
			<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
			<!-- devlog -->
			<ins class="adsbygoogle"
				style="display:inline-block;width:100%;height:90px;margin-top:20px;"
				data-ad-client="ca-pub-7569324435867375"
				data-ad-slot="3519819849"></ins>
			<script>
			(adsbygoogle = window.adsbygoogle || []).push({});
			</script>
			{% endif %}
			<div class="col-xs-12 board-wrapper">
				<h3>Posts</h3>
				<div class="row board-header">
					<div class="col-xs-2 col-sm-1 f">
						No.
					</div>
					<div class="col-xs-7 col-sm-7">
						Title
					</div>
					<div class="col-xs-3 col-sm-1">
						User
					</div>
					<div class="hidden-xs col-sm-1">
						View
					</div>
					<div class="hidden-xs col-sm-2 l">
						Date
					</div>
				</div>
				{% for p in posts %}
				<div class="row board-content {{ p.p_id == posts[0].p_id ? 'f' }} {{ p.p_id == post.p_id ? 'current' }}">
					<div class="col-xs-2 col-sm-1 no">
						{{p.p_id}}
					</div>
					{% if req == "" %}
					<a class="col-xs-7 title" href="/b/{{p.p_id}}/?page={{cur_page}}">
					{% else %}
					<a class="col-xs-7 title" href="/b/{{req}}/{{p.p_id}}/?page={{cur_page}}">
					{% endif %}
						{{p.p_title}}
					</a>
					<div class="col-xs-3 col-sm-1 view">
						{{p.u_nickname}}
					</div>
					<div class="hidden-xs col-sm-1 view">
						{{p.p_view}}
					</div>
					<div class="hidden-xs col-sm-2 timestamp">
						{% if p.initial_time > date('-1days') %}
							{{ p.p_initial_time|date('Y/m/d') }}
						{% else %}
							{{ p.p_initial_time|date('h:i A') }}
						{% endif %}
					</div>
				</div>
				{% endfor %}
			</div>
			<div class="board-nav center">
				<a href="/b/{{req}}">First Page</a>
				{% for page in pnav %}
					{% if page == cur_page %}
						<span class="">{{page}}</span>
					{% else %}
						<a href="/b/{{req}}?page={{page}}">{{page}}</a>
					{% endif %}
				{% endfor %}
				<a href="/b/{{req}}?page={{total_pages}}">Last Page</a>
			</div>
		</div>
	</body>
</html>
