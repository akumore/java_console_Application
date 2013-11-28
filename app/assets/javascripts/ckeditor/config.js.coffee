CKEDITOR.editorConfig = (config) ->
  config.language = 'de'

  config.toolbar = [
    ['Format'],
    ['Bold', 'Italic', 'Superscript', '-', 'RemoveFormat'],
    ['NumberedList','BulletedList','-','Outdent','Indent'],
    ['HorizontalRule', 'SpecialChar'], 
    ['Link', 'Unlink', 'Anchor'],
    ['Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo'],
    ['Source', '-', 'ShowBlocks'],
    ['Maximize']
  ]

  config.format_tags = 'p;h1;h2;h3;h4;pre'

# FULL OPTIONS:
#[
#['Source','-','Save','NewPage','Preview','-','Templates'],
#['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
#['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
#['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
#'/',
#['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
#['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
#['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
#['Link','Unlink','Anchor'],
#['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
#'/',
#['Styles','Format','Font','FontSize'],
#['TextColor','BGColor'],
#['Maximize', 'ShowBlocks','-','About']
#]
