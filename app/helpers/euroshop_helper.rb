module EuroshopHelper
  def title
    base_title = "Porovnanie notebookov"
    if @title.nil?
    base_title
    else
    "#{base_title} | #{@title}"
    end
  end

  def sidebar

    if ((@sidebar!="")&&(@sidebar!=nil))
      "<div id='sidebar'>
       #{@sidebar}
       </div>"
    end
  end

  def zoznam_obchodov

    zoznam_obchodov = "<ul>"
    @obchody.each do |e|
      zoznam_obchodov+="<li>"+"<a href=#{e.link}> #{e.name} </a>" +"</li>"
    end

    zoznam_obchodov+="</ul>"
  end




end

