CKEDITOR.editorConfig = (config) ->
  config.language = 'de'

  config.toolbar = [
    ['Format'],
    ['Bold', 'Italic', 'Superscript', '-', 'RemoveFormat'],
    ['Link', 'Unlink'],
    ['Image', 'Anchor'],
    ['Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo'],
    ['Source', '-', 'ShowBlocks'],
    ['Maximize']
  ]

  config.format_tags = 'p;h1;h2;h3;h4;pre'
