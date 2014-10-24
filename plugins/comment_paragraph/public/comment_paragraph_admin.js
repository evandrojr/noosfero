function check_fields(check, table_id, start) {
  var checkboxes = jQuery("#" + table_id + " tbody tr td input[type='checkbox']");
  for (var i = start; i < checkboxes.length; i++) {
    checkboxes[i].checked = check;
  }
}

function verify_checked() {
  var checkboxes = jQuery("#auto_marking_article_types_conf tbody tr td input[type='checkbox']");
    var allchecked = true
    for (var j = 1; j < checkboxes.length; j++) {
      if(!checkboxes[j].checked) {
        allchecked = false
        break
      }
    }

    var checkbox = checkboxes.first();
    checkboxes.first().attr('checked', allchecked);
}

function check_all() {
  jQuery("input[type='checkbox']").first().click(function () {
    check_fields(this.checked, "auto_marking_article_types_conf", 0)
  });
  verify_checked();
}

jQuery(document).ready(function() {
  check_all();
  jQuery("input[type='checkbox']").click(function () {
    var checkbox = jQuery(this).attr("id").split("_");
    verify_checked();

    if(this.checked == false) {
      jQuery("#" + checkbox.first() + "_" + checkbox.last()).attr("checked", false)
    }
  });
});
