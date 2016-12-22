# Download and extract a SQL Server 'setup file'
#   A file that once extracted gives us a setup.exe file to call
#   This can be a SQL Server iso file or a Service Pack / Cumulative Update executable.
#
# $source: The url to download from
#
# $creates: The full path of setup.exe where this resource will extract setup.exe.
#           If not defined, setup.exe will be extracted at
#           C:/Windows/Temp/<$source_filename_without_extension>/setup.exe
define sqlserver::common::download_installer(
  $source,
  $creates = undef
  ) {
    require archive

    if $creates {
      $folder = inline_template('<%= File.dirname(@create, ".*") %>')
      $setup_file = $creates
    } else {
      $folder_name = inline_template('<%= File.basename(@source, ".*") %>')
      $folder = "c:/windows/temp/${folder_name}"
      $setup_file = "${folder}/setup.exe"
    }

    $downloaded_filename = inline_template('<%= File.basename(@source) %>')

    file { $folder:
      ensure  => directory,
    }
    ->
    archive { "c:/windows/temp/${downloaded_filename}":
      source       => $source,
      extract      => true,
      extract_path => $folder,
      creates      => $setup_file,
      cleanup      => true,
    }
}
