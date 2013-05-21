module ReferenceProjectsHelper

  def reference_project_sections
    [
      [t("reference_projects.section.residential_building"), ReferenceProjectSection::RESIDENTIAL_BUILDING],
      [t("reference_projects.section.residential_commercial_building"), ReferenceProjectSection::RESIDENTIAL_COMMERCIAL_BUILDING],
      [t("reference_projects.section.business_building"), ReferenceProjectSection::BUSINESS_BUILDING],
      [t("reference_projects.section.trade_industrial_building"), ReferenceProjectSection::TRADE_INDUSTRIAL_BUILDING],
      [t("reference_projects.section.special_building"), ReferenceProjectSection::SPECIAL_BUILDING],
      [t("reference_projects.section.rebuilding"), ReferenceProjectSection::REBUILDING]
    ]
  end
end
