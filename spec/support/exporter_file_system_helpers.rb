module ExporterFileSystemHelpers
  def create_tmp_export_dir!
    @tmp_path = File.join Rails.root, 'tmp', 'specs'
    FileUtils.mkdir_p @tmp_path
    FileUtils.mkdir_p File.join(@tmp_path, 'data')
    FileUtils.mkdir_p File.join(@tmp_path, 'images')
    FileUtils.mkdir_p File.join(@tmp_path, 'movies')
    FileUtils.mkdir_p File.join(@tmp_path, 'documents')
  end

  def remove_tmp_export_dir!
    FileUtils.rm_rf(@tmp_path)
  end
end