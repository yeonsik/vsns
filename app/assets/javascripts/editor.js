//= require wmd/wmd
//= require wmd/showdown

$(function(){
  new WMDEditor({
    input: "item_description",
    button_bar: "editor-button-bar",
    preview: "editor-preview",
    output: "editor-output"
  });
})
