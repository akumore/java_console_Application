$ ->
  table = $(".datatable").DataTable
    "sDom": "<'row-fluid data-table__header'<'span6'l><'span6'<'js-clear-search clear-search'>f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    "sPaginationType": "bootstrap"
    aaSorting: [[0, "asc"], [1, "asc"], [2, "asc"] ]
    aoColumnDefs: [
      {"aTargets": [ -2, -1 ], "bSortable": false }
    ]
    iDisplayLength: 50
    aLengthMenu: [[25, 50, 100, 200, -1], [25, 50, 100, 200, "All"]]
    bStateSave: true
    oLanguage:
      oPaginate:
        sNext: "Weiter"
        sPrevious: "Zurück"
      sInfo: "Einträge _START_ bis _END_ von _TOTAL_"
      sInfoEmpty: "keine Einträge vorhanden"
      sInfoFiltered: "(von gesamthaft _MAX_ Einträgen)"
      sSearch: "Suche:"
      sLengthMenu: "Einträge pro Seite: _MENU_"
      sEmptyTable: "keine Einträge gefunden"
      sZeroRecords: "keine Einträge gefunden"

  $('.js-clear-search').append("<button class='js-clear-search__button clear-search__button btn'>Zurücksetzen</button>")

  $('.js-clear-search__button').on 'click', (e) ->
    e.preventDefault()
    table.search('').columns().search('').draw()
