$(document).ready(function() {
	$('[data-toggle="tooltip"]').tooltip();
	$('form.post-form').on('keyup keypress', function(e) {
		var code = e.keyCode || e.which;
		if (code == 13) { 
			e.preventDefault();
			return false;
		}
	});
	$('input[name=tags]').tooltip({
		"trigger":"focus", 
		"title":"Press enter to register tag",
		"placement":"left",
	});

	function split(val) {
		return val.split(/,\s*/);
	}
	function extractLast(term){
		return split(term).pop();
	}

	$("input[name=tags],input[name=new-filter]").autocomplete({
		source: "/backend/tags.php"
	});
	$("input[name=tags]").attr('autocomplete','on');
})
$.fn.modal.Constructor.prototype.enforceFocus = function() {}

function deleteComment(id) {
	return confirm("Do you really want to delete this post?", "yes", "no");
}
function editComment(cl) {
	var comment = $("." + cl);
	// hide existing part
	comment.find(".comment-body").hide();
	comment.find(".comment-edit-body").show();
}
function cancelEditComment(cl) {
	var comment = $("." + cl);
	// hide existing part
	comment.find(".comment-body").show();
	comment.find(".comment-edit-body").hide();
}
function organizeTags(th) {
	var tagContainer = $(th).find(".write-tags")
}

function checkTags(th) {
	if(event.keyCode == 13) {
        var tags = $(th).val().trim();
        if(tags.length == 0) return false;
        var tagList = $(th).parent().find(".write-tags").find(".tag");
    	for(i = 0 ; i < tagList.length ; i++) {
        	if($(tagList[i]).attr("value") == tags) {
        		$(th).val("");
        		$('.ui-menu-item').hide();
				return false;
			}
        }
        var tagHTML = "<div class=\"tag\" value=\""+tags+"\">"+tags+" <i onclick=\"removeTag(this);\" class=\"ion-close remove-tag\"></i><input name=\"tag[]\" value=\""+tags+"\" type=\"hidden\"></div> ";

        $(th).parent().find(".write-tags").append(tagHTML);
		$(th).val("");
        $('.ui-menu-item').hide();

        return false;
    }
    if($('input[name=tags]').val().length > 0) {

    }
    return true;
}
function removeTag(th) {
	var value = $(th).parent().remove();
}

function removeTagFilter(t) {
	var curLocation = location.href.split(location.protocol + "//" + location.host + "/")[1];
	var arguments = curLocation.split("?")[0].split("/");
	if(arguments.length > 1) {
		if(arguments.length == 2) {
			if(arguments[1] != "") {
				arguments.splice(arguments.indexOf(t), 1);
			}
		} else {
			arguments.splice(arguments.indexOf(t), 1);
		}
	}
	location.href = location.protocol + "//" + location.host + "/" + arguments.join("/");
}
function addTagFilter(t) {
	if(event.keyCode == 13) {
		var newtag = $(t).val();
		var curLocation = location.href.split(location.protocol + "//" + location.host + "/")[1];
		var arguments = curLocation.split("?")[0].split("/");
		if(arguments.indexOf(newtag) < 0) {
			if(arguments[arguments.length-1] == "") {
				if(/^\d+$/.test(arguments[arguments.length-2])) {
					arguments[arguments.length-2] = newtag;
					arguments[arguments.length-1] = "";
				} else {
					arguments[arguments.length-1] = newtag;
					arguments[arguments.length] = "";
				}
			} else {
				if(/^\d+$/.test(arguments[arguments.length-1])) {
					arguments[arguments.length-1] = newtag;
				} else {
					arguments[arguments.length] = newtag;
				}
			}
			location.href = location.protocol + "//" + location.host + "/" + arguments.join("/");
		} else {
			alert("There was duplicate in filter.\nPlease check again.")
			$(t).val("");
		}
	}
}

function changeFilterOption(t) {
	var option = $(t).val();
	var parameters = []
	var curLocation = location.href.split(location.protocol + "//" + location.host + "/")[1];

	location.href = location.protocol + "//" + location.host + "/" + curLocation.split("?")[0] + "?option=" + option;
}



