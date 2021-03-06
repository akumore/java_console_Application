CKEDITOR.editorConfig = (config) ->
  config.language = 'de'
  config.entities = false

  config.toolbar = [
    ['Format','BulletedList','PasteFromWord'],
    ['Link','Unlink','Anchor'],
    ['Image'],
    ['Source']
  ]

  config.format_tags = 'p;h3;h4;h5;h6'

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
