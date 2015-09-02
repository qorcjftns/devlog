<!-- NAVBAR -->
<div class="navbar navbar-default top-nav" role="navigation">
	<div class="container-fluid">
		<!-- main logo -->
		<div class="navbar-header">
			<div class="navbar-brand"><a href="/"><img src="/image/Logo.png" alt="{{ site_title }}"/></a></div>
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#top-bar">
				<span class="sr-only">Toggle Navbar</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
		</div>
		<div class="collapse navbar-collapse" id="top-bar">
			<ul class="nav navbar-nav">
				<li><a href="/b/notice/">Notice</a></li>
				<li><a href="/b/">All</a></li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Programming Language <span class="caret"></span></a>
					<ul class="dropdown-menu" role="menu">
						<li><a href="/b/C++/">C</a></li>
						<li><a href="/b/C++/">C++</a></li>
						<li><a href="/b/JAVA/">JAVA</a></li>
						<li><a href="/b/Python/">Python</a></li>
						<li><a href="/b/Javascript/">Javascript</a></li>
					</ul>
				</li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Manual <span class="caret"></span></a>
					<ul class="dropdown-menu" role="menu">
						<li><a href="/manual/about/">About</a></li>
						<li><a href="/manual/tag/">Tag</a></li>
					</ul>
				</li>
			</ul>
			{% if user %}
			<form method="POST" action="/backend/user.php" class="logout-form navbar-form navbar-right">
				<div class="form-group">
					<input type="hidden" name="request" value="logout" />
					<input type="hidden" name="from" value="{{cur_url}}" />
					<button class="btn btn-default form-control">Log Out</button>
					<button type="button" data-toggle="modal" data-target="#write-post" class="btn btn-sm btn-primary form-control"><i class="ion-edit"></i> Write Post</button>
				</div>
			</form>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Hello, {{user.u_nickname}} <span class="caret"></span></a>
					<ul class="dropdown-menu" role="menu">
						<li><p class="navbar-text">Favorites</p></li>
						{% if favorite.length == 0 %}
							{% for f in favorite %}
							<li><a href="/b/{{f.uf_favorite}}?option={{f.uf_option}}">
								<form class="delete-favorite-form" action="/backend/user.php" method="POST">
									<input type="hidden" name="from" value="{{cur_url}}" />
									<input type="hidden" name="request" value="delete-favorite" />
									<input type="hidden" name="option" value="{{f.uf_option}}" />
									<input type="hidden" name="include-tags" value="{{f.uf_favorite}}" />
									<button onclick"$(this).parent().submit();return false;" class="ion-close"></button>
								</form> [{{f.uf_option}}] {{f.uf_favorite}}</a>
							</li>
							{% endfor %}
						{% else %}
							<li><p class="navbar-text">No Favorites</p></li>
						{% endif %}
					</ul>
				</li>
			</ul>
			{% else %}
			<div class="board-toolbox">
				<button type="button" data-toggle="modal" data-target="#login-modal" class="btn btn-sm btn-primary pull-right">Log in</button>
			</div>
			{% endif %}
			<!--div class="col-sm-3 pull-right">
				<form class="navbar-form">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Search" name="search">
						<div class="input-group-btn">
						<button class="btn btn-default" type="button">&nbsp;<span class="glyphicon glyphicon-arrow-right"></span>&nbsp;</button>
						<button class="btn btn-default" type="button">&nbsp;<span class="glyphicon glyphicon-search"></span>&nbsp;</button>
						</div>
					</div>
				</form>
			</div-->
		</div>
	</div>
</div>