function togglePost(id)
{
	var post = document.getElementById('post_'+id);
	var clPrompt = document.getElementById('click_prompt_'+id);

	if (post.style.display == 'block')
	{
		hideElement(document.getElementById('post_comments_'+id), document.getElementById('click_prompt_comments_'+id));
		hideElement(post, clPrompt);
	}
	else
		showElement(post, clPrompt);
}

function togglePostComments(id)
{
	var comments = document.getElementById('post_comments_'+id);
	var clPrompt = document.getElementById('click_prompt_comments_'+id);

	if (comments.style.display == 'block')
		hideElement(comments, clPrompt);
	else
		showElement(comments, clPrompt);
}

function hideElement(element, clickPrompt)
{
	element.style.display = 'none';
	clickPrompt.style.display = 'block';
}

function showElement(element, clickPrompt)
{
	element.style.display = 'block';
	clickPrompt.style.display = 'none';
}

// Search

function toggleBG()
{
	var element = document.getElementById("s");
	if(element.value.length == 0)
		showSearchBG(element);
	else
		hideSearchBG(element);
}

function hideSearchBG(element)
{
	element.style.background = '#F8FAFE';
}

function showSearchBG(element)
{
	element.style.background = 'none';
}
