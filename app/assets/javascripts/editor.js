//= require wmd/wmd
//= require wmd/showdown

var initializeWMDEditor = function () {
  new WMDEditor({
    input: "item_description",
    button_bar: "editor-button-bar",
    preview: "editor-preview",
    output: "editor-output"
  });

  $(".wmd-help-button").html("<a id='markdown-help-link'></a>");

  $("#markdown-help-link").click(function(){
    $("#editor-help-panel").slideToggle('fast');

    return false;
  });
};

$(function () { // dom ready
  initializeWMDEditor();
});

// Turbolink 이벤트를 통한 처리
$(document).on('page:load', initializeWMDEditor);