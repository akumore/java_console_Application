$(".accordion-spacey").append("<%=j render @news_items %>")
$(".load-more").html("<%= j load_more_link(@offset) %>")
