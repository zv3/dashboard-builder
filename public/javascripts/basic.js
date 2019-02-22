$(document).ready(function() {
	if ($('#login .login-button')) 
	{
		$('#login .login-button').click(function () {
			if ($('#login-popout').is(':visible'))
			{
				$(this).removeClass('login-button-alternative');
				$('#login-popout').hide("slide", { direction: "up" }, 500);
			}
			else
			{
				$('#login-popout').show("slide", { direction: "up" }, 500);
				$(this).addClass('login-button-alternative');
			}
		});
	}

	if ($('#admin .admin-button')) 
	{
		$('#admin .admin-button').click(function () {
			if ($('#admin-popout').is(':visible'))
			{
				$(this).removeClass('admin-button-alternative');
				$('#admin-popout').hide("slide", { direction: "up" }, 500);
			}
			else
			{
				$('#admin-popout').show("slide", { direction: "up" }, 500);
				$(this).addClass('admin-button-alternative');
			}
		});
	}

	if ($('#user-menu .user-menu-button')) 
	{
		$('#user-menu .user-menu-button').click(function () {
			if ($('#user-menu-popout').is(':visible'))
			{
				$(this).removeClass('user-menu-button-alternative');
				$('#user-menu-popout').hide("slide", { direction: "up" }, 500);
			}
			else
			{
				$('#user-menu-popout').show("slide", { direction: "up" }, 500);
				$(this).addClass('user-menu-button-alternative');
			}
		});
	}

	if ($('#tabSearchInput')) 
	{
		$('#tabSearchInput').keyup(function() {
			if ($(this).val().length > 0)
				$('#tabSearchClear').show();
			else
				$('#tabSearchClear').hide();
		});
	}

	if ($('#tabSearchClear')) 
	{
		$('#tabSearchClear').click(function () {
			$('#tabSearchInput').val('');
		});
	}
});