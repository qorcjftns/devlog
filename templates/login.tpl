<div class="modal fade" id="register" tabindex="-1" role="dialog" aria-labelledby="addListing" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<form action="/backend/user.php" method="POST">
				<input type="hidden" name="request" value="register" />
				<input type="hidden" name="from" value="{{cur_url}}" />
				<input type="hidden" name="board" value="{{board.b_id}}" />
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">
						Register
					</h4>
				</div>
				<div class="modal-body">
					<div class="email-row">
						<div class="register-label">Email</div>
						<div class="register-field"><input type="text" name="email" /></div>
					</div>
					<div class="password-row">
						<div class="register-label">Password</div>
						<div class="register-field"><input type="password" name="password" /></div>
					</div>
					<div class="nickname-row">
						<div class="register-label">Nickname</div>
						<div class="register-field"><input type="text" name="nickname" /></div>
					</div>
				</div>
				<div class="modal-footer">
					<button data-dismiss="modal" data-target="#write-post" class="btn btn-default">Cancel</button>
					<button class="btn btn-primary">Submit</button>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- When not logged in -->
<div class="modal fade" id="login-modal" tabindex="-1" role="dialog" aria-labelledby="addListing" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				{% if not user %}
				<div class="login-panel">
					<form method="POST" action="/backend/user.php">
						<input type="hidden" name="request" value="login" />
						<input type="hidden" name="from" value="{{cur_url}}" />
						<div class="login-header center">
							Login
						</div>
						<div class="login-id">
							Login Email:<br/><input class="form-control" name="u_email" type="text">
						</div>
						<div class="login-pw">
							Login PW:<br/><input class="form-control" name="u_pw" type="password">
						</div>
						<div class="login-btn">
							<button class="btn btn-primary">Log In</button>
						</div>
						<div class="login-footer center">
							<div><a href="#" data-dismiss="modal" data-toggle="modal" data-target="#register">Create an account</a></div>
							<div><a href="">Forgot password</a></div>
						</div>
					</form>
				</div>
				{% else %}
				<!-- When logged in -->
				<div class="login-panel">
					<div class="login-greeting">Hello, {{user.u_nickname}}!</div>
					<div class="login-msg-count">You have {{new_msg_count}} new messages.</div>
					<div class="login-btn">
						<form method="POST" action="/backend/user.php">
							<input type="hidden" name="request" value="logout" />
							<input type="hidden" name="from" value="{{cur_url}}" />
							<button class="btn btn-default">Log Out</button>
						</form>
					</div>
				</div>
				{% endif %}
			</div>
		</div>
	</div>
</div>
