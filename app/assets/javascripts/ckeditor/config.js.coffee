CKEDITOR.editorConfig = (config) ->
  config.language = 'de'

  config.toolbar = [
    ['Format','BulletedList','PasteFromWord'],
    ['Anchor','Image'],
    ['Source']
  ]

  config.format_tags = 'p;h1'

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
