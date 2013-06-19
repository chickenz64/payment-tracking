$(function(){


  $('form[data-remote]').on('ajax:beforeSend', function(evt, xhr, settings) {
    $(this).find("input:text, textarea, select").attr("readonly", true);
    $(this).find("input:submit").addClass("disabled");
  })
  .on('ajax:success', function(evt, data, status, xhr) {
    if ( /new_/g.test($(this).attr('class')) ) {
      $(this).find("input:text, textarea").val("");
    }
  })
  .on('ajax:complete', function(evt, xhr, status) {
    $(this).find("input:text, textarea, select").removeAttr("readonly");
    $(this).find("input:submit").removeClass("disabled");
  });

  $(".new_group_clients").on('ajax:complete', function(evt, xhr, status) {
    var res = $.parseJSON(xhr.responseText);
    
    $(this).find("input:text").val("");
    $("#newGroupModal").modal('hide');

    $.each(res, function(){ 
      $("#select_group").append($('<option></option>', {value: this.id, text: this.name, selected: true}));
    });
  });

  $(".new_client").on('ajax:complete', function(evt, xhr, status) {
    var flash = $("#flash_msgs"), res = $.parseJSON(xhr.responseText),
      ul = $("<ul></ul>"), div = $("<div></div>", {class: "alert"}), a = $("<a></a>");

    if (xhr.status === 201) { div.addClass('alert-success'); } 
    else { div.addClass('alert-error'); }

    $.each(res, function(){ 
      $.each(this.msg, function(){ ul.append($("<li></li>", {text: this})); });
      if (xhr.status === 201) { 
        a.attr('href', window.location.pathname + '/' + this.clientid).text(this.clientname);
        $('#list_clients tbody').prepend
        ("<tr><td><i class='icon-asterisk'></i> "+a[0].outerHTML+"</td></tr>");
        // $('#list_clients tbody tr:first td').css({''});
      }
    });
    flash.html(div.html(ul));
  });

  $(".edit_client").on('ajax:complete', function(evt, xhr, status) {
    var flash = $("#flash_msgs"), res = $.parseJSON(xhr.responseText),
      ul = $("<ul></ul>"), div = $("<div></div>", {class: "alert"});

    if (xhr.status === 201) { div.addClass('alert-success'); } 
    else { div.addClass('alert-error'); }

    $.each(res, function(){ 
      $.each(this.msg, function(){ ul.append($("<li></li>", {text: this})); });
    });
    flash.html(div.html(ul));
  })
  .on('ajax:success', function(evt, data, status, xhr) {
  })
  .on('ajax:error', function(evt, xhr, status, error) {
  });

});