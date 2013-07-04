$ ->
  $(".datatable").dataTable
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    "sPaginationType": "bootstrap"
    aaSorting: [[0, "asc"], [1, "asc"], [2, "asc"], [3, "asc"], [4, "asc"] ]
    aoColumnDefs: [       
      {"aTargets": [ -2, -1 ], "bSortable": false }     
    ]    
    iDisplayLength: 50
    aLengthMenu: [[25, 50, 100, 200, -1], [25, 50, 100, 200, "All"]]
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
