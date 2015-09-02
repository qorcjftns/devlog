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

	$("input[name=tags]").autocomplete({
		source: "/backend/tags.php"
	});
	$("input[name=tags]").attr('autocomplete','on');
})

function deleteComment(id) {
	return confirm("Do you really want to delete this post?", "yes", "no");
}
function organizeTags(th) {
	var tagContainer = $(th).find(".write-tags")

}

function checkTags(th) {
	if(event.keyCode == 13) {
        var tags = $('input[name=tags]').val().trim();
        if(tags.length == 0) return false;
        var tagList = $(th).parent().find(".write-tags").find(".tag");
    	for(i = 0 ; i < tagList.length ; i++) {
        	if($(tagList[i]).attr("value") == tags) {
        		$('input[name=tags]').val("");
        		$('.ui-menu-item').hide();
				return false;
			}
        }
        var tagHTML = "<div class=\"tag\" value=\""+tags+"\">"+tags+" <i onclick=\"removeTag(this);\" class=\"ion-close remove-tag\"></i></div> ";
        tagHTML += "<input name=\"tag[]\" value=\""+tags+"\" type=\"hidden\">";

        $(th).parent().find(".write-tags").append(tagHTML);
		$('input[name=tags]').val("");
        $('.ui-menu-item').hide();

        return false;
    }
    if($('input[name=tags]').val().length > 0) {

    }
    return true;
}
function removeTag(th) {
	var value = $(th).parent().attr("value");
	$('[value='+value+']').remove();
}

function removeTagFilter(t) {
	var curLocation = location.href;
	var arguments = curLocation.split("?")[0].split("/");
	arguments.splice(arguments.indexOf(t), 1);
	location.href = arguments.join("/");
}
function addTagFilter(t) {
	if(event.keyCode == 13) {
		var newtag = $(t).val();
		var curLocation = location.href;
		var arguments = curLocation.split("?")[0].split("/");
		if(arguments.indexOf(newtag) < 0) {
			if(arguments[arguments.length-1] == "") {
				if(/[0-9]/.test(arguments[arguments.length-2])) {
					arguments[arguments.length-2] = newtag;
				} else {
					arguments[arguments.length-1] = newtag;
				}
			} else {
				if(/[0-9]/.test(arguments[arguments.length-1])) {
					arguments[arguments.length-1] = newtag;
				} else {
					arguments[arguments.length] = newtag;
				}
			}
			location.href = arguments.join("/");
		} else {
			alert("There was duplicate in filter.\nPlease check again.")
			$(t).val("");
		}
	}
}

function changeFilterOption(t) {
	var option = $(t).val();
	var parameters = []
	var curLocation = location.href;

	location.href = curLocation.split("?")[0] + "?option=" + option;
}



