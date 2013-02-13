$(".reference-projects-container").empty()
$(".reference-projects-container").append("<%=j render 'reference_project', :reference_projects => @reference_projects %>")
