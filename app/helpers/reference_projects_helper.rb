module ReferenceProjectsHelper

  def reference_project_sections
    [
      [t("reference_projects.section.residential_building"), ReferenceProjectSection::RESIDENTIAL_BUILDING],
      [t("reference_projects.section.business_building"), ReferenceProjectSection::BUSINESS_BUILDING],
      [t("reference_projects.section.public_building"), ReferenceProjectSection::PUBLIC_BUILDING],
      [t("reference_projects.section.rebuilding"), ReferenceProjectSection::REBUILDING]
    ]
  end
end
