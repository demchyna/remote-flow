(function() {
  var userRole = document.getElementById('user_role');
  var userOrganization = document.getElementById('user_organization_id');
  userRole.addEventListener('change', function() {
    if (userRole.value == 'super_admin') {
      userOrganization.parentNode.parentNode.firstChild.addClass("d-none");
    } else {
      userOrganization.parentNode.parentNode.firstChild.removeClass("d-none");
    }
  });
}());
