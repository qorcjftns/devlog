<div class="modal fade" id="write-post" tabindex="-1" role="dialog" aria-labelledby="addListing" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<form class="post-form" action="/backend/post.php" method="POST">
				<input type="hidden" name="request" value="post-add" />
				<input type="hidden" name="from" value="{{cur_url}}" />
				<input type="hidden" name="board" value="{{board.b_id}}" />
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">
						New Posting
					</h4>
				</div>
				<div class="modal-body">
					<div class="title-row">
						<div class="write-label">Title</div>
						<div class="write-field"><input type="text" name="title" /></div>
					</div>
					<div class="body-row">
						<div class="write-label">Body</div>
						<div class="write-field"><textarea id="write-body" name="body"></textarea></div>
					</div>
					<div class="tag-row">
						<div class="write-label">Tags</div>
						<div class="write-field">
							<input name="tags" onkeypress="return checkTags(this);" placeholder="Add Tags..."/>
							<div class="write-tags"></div>
						</div>
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
<div class="modal fade" id="edit-post" tabindex="-1" role="dialog" aria-labelledby="addListing" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<form class="post-form edit-form" action="/backend/post.php" method="POST">
				<input type="hidden" name="request" value="post-edit" />
				<input type="hidden" name="from" value="{{cur_url}}" />
				<input type="hidden" name="board" value="{{board.b_id}}" />
				<input type="hidden" name="p_id" value="{{post.p_id}}" />
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">
						Edit Post
					</h4>
				</div>
				<div class="modal-body">
					<div class="title-row">
						<div class="write-label">Title</div>
						<div class="write-field"><input type="text" name="title" value="{{post.p_title}}"/></div>
					</div>
					<div class="body-row">
						<div class="write-label">Body</div>
						<div class="write-field"><textarea id="add-body" name="body">{{post.p_body_raw}}</textarea></div>
					</div>
					<div class="tag-row">
						<div class="write-label">Tags</div>
						<div class="write-field">
							<input name="tags" onkeypress="return checkTags(this);" placeholder="Add Tags..."/>
							<div class="write-tags">
							{% for pt in post_tags %}
								<div class="tag" value="{{pt.t_name}}">{{pt.t_name}} <i onclick="removeTag(this);" class="ion-close remove-tag"></i><input name="tag[]" value="{{pt.t_name}}" type="hidden"></div>
        					{% endfor %}
							</div>
						</div>
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
<script type="text/javascript">
	CKEDITOR.replace( 'write-body',{filebrowserUploadUrl: '/backend/upload.php'} );
	CKEDITOR.replace( 'add-body',{filebrowserUploadUrl: '/backend/upload.php'} );
</script>