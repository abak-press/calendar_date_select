module CalendarDateSelect::IncludesHelper
  # returns the selected calendar_date_select stylesheet (not an array)
  def calendar_date_select_stylesheets(options = {})
    options.assert_valid_keys(:style)
    "calendar_date_select/#{options[:style] || "default"}"
  end

  # returns an array of javascripts needed for the selected locale, date_format, and calendar control itself.
  def calendar_date_select_javascripts(options = {})
    options.assert_valid_keys(:locale)
    files = ["calendar_date_select/calendar_date_select_#{CalendarDateSelect.lib}"]
    files << "calendar_date_select/locale/#{options[:locale]}" if options[:locale]
    files << "calendar_date_select/#{CalendarDateSelect.format[:javascript_include]}" if CalendarDateSelect.format[:javascript_include]
    files
  end

  # returns html necessary to load javascript and css to make calendar_date_select work
  def calendar_date_select_includes(*args)
    return '' if @cds_already_included

    install_files!
    @cds_already_included = true
    
    options = (Hash === args.last) ? args.pop : {}
    options.assert_valid_keys(:style, :locale)
    options[:style] ||= args.shift
    
    html = javascript_include_tag(*calendar_date_select_javascripts(:locale => options[:locale])) + "\n"
    unless options[:style] === false 
      html += stylesheet_link_tag(*calendar_date_select_stylesheets(:style => options[:style])) + "\n"
    end
    html
  end

  def install_files!
    cds_files = Dir.glob("#{Rails.root}/public/javascripts/calendar_date_select/calendar_date_select*js")
    #CalendarDateSelect.lib = cds_files.first[/calendar_date_select_([^\/]*)\.js/, 1]

    return if cds_files.any?

    ['/public', '/public/javascripts/calendar_date_select', '/public/stylesheets/calendar_date_select', '/public/images/calendar_date_select', '/public/javascripts/calendar_date_select/locale'].each do |dir|
      source = File.dirname(__FILE__) + "/../#{dir}"
      dest   = RAILS_ROOT + dir
      FileUtils.mkdir_p(dest)

      files = Dir.glob(source + '/*.*')
      if dir == '/public/javascripts/calendar_date_select'
        files = files.reject{|f| f =~ /calendar_date_select[^\/]*js/} # all but calendar_date_select<sthg>js
        p cds_file = File.join(source, "calendar_date_select_#{CalendarDateSelect.lib}.js")
        files << cds_file
      end
      FileUtils.cp(files, dest)
    end

  end
end
