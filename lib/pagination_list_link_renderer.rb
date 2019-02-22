class PaginationListLinkRenderer < WillPaginate::LinkRenderer

  def to_html
    links = @options[:page_links] ? windowed_links : []
    # links.push
    # <span class="pages">P&aacute;gina 1 de 4</span>
    if current_page > 1
      links.unshift(page_link_or_span(@collection.previous_page, nil, @options[:previous_label]))
    end

    links.unshift(@template.content_tag(:span, "P&aacute;gina #{current_page} de #{max_page_number}", :class => "pages"))

    if current_page < max_page_number
      links.push(page_link_or_span(@collection.next_page, nil, @options[:next_label]))
    end

    html = links.join(@options[:separator])
    @template.content_tag(:div, @template.content_tag(:div, html, :class => "wp-pagenavi"), :class => "more_entries")
    
  end

protected

  def windowed_links
    visible_page_numbers.map { |n| page_link_or_span(n, (n == current_page ? 'current' : nil)) }
  end

  def max_page_number
    visible_page_numbers.size
  end

  def page_link_or_span(page, span_class, text = nil)
    text ||= page.to_s
    if page && page != current_page
      page_link(page, text, :class => span_class)
    else
      page_span(page, text, :class => span_class)
    end
  end

  def page_link(page, text, attributes = {})
    @template.link_to(text, url_for(page))
  end

  def page_span(page, text, attributes = {})
    @template.content_tag(:span, text, attributes)
  end

end