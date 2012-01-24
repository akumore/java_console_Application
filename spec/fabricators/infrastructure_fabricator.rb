Fabricator(:infrastructure) do
  has_parking_spot false
  has_roofed_parking_spot false
  has_garage false
  inside_parking_spots 1
  outside_parking_spots 1
  inside_parking_spots_temporary 1
  outside_parking_spots_temporary 1
end
