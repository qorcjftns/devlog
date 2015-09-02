$(document).ready(function() {
	$('[data-toggle="tooltip"]').tooltip();
	$('form').on('keyup keypress', function(e) {
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

function checkTags(th) {
	if(event.keyCode == 13) {
        var tags = $('input[name=tags]').val().trim();
        if(tags.length == 0) return false;
        var tagList = $(th).parent().find(".write-tags").find(".tag");
        for(t in tagList) {
        	if(tagList[t].value == tags) return false;
        }
        var tagHTML = "<div class=\"tag\" value=\""+tags+"\">"+tags+" <i onclick=\"removeTag(this);\" class=\"ion-close remove-tag\"></i></div> "
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
	$(th).parent().remove();
}