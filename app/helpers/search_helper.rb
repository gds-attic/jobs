module SearchHelper

  def permanent_options
    {
      "I don't mind" => '',
      "Permanent" => true,
      "Temporary" => false
    }
  end

  def time_options
    {
      "I don't mind" => '',
      "Full Time" => true,
      "Part Time" => false
    }
  end

  def recency_options
    {
      "any time" => '',
      "in the last fortnight" => 14,
      "in the last week" => 7,
      "in the last 3 days" => 3
    }
  end

  RAD_PER_DEG = 0.017453293
  RADIUS_MILES = 3956

  def distance(latitude_1, longitude_1, latitude_2, longitude_2)
    d_longitude = longitude_2 - longitude_1
    d_latitude = latitude_2 - latitude_1

    d_longitude_rad = d_longitude * RAD_PER_DEG
    d_latitude_rad = d_latitude * RAD_PER_DEG

    latitude_1_rad = latitude_1 * RAD_PER_DEG
    longitude_1_rad = longitude_1 * RAD_PER_DEG
    latitude_2_rad = latitude_2 * RAD_PER_DEG
    longitude_2_rad = longitude_2 * RAD_PER_DEG

    a = (Math.sin(d_latitude_rad/2))**2 + Math.cos(latitude_1_rad) * Math.cos(latitude_2_rad) * (Math.sin(d_longitude_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
    RADIUS_MILES * c
  end

  def search_form_fields(params)
    String.new.html_safe.tap do |string|
      params.each do |k, v|
        string << hidden_field_tag(k, v)
      end
    end
  end

  def pretty_format_date(date)
    return "Today" if date.to_date == Date.today
    return "Yesterday" if date.to_date == Date.yesterday
    buffer = date.strftime("%A ")
    buffer << date.strftime("%d").to_i.ordinalize
    buffer << date.strftime(" %B")
    return buffer
  end

  def pagination(search, results)
    total = results.total
    per_page = search.per_page
    max_page = (total.to_f / per_page).ceil + 1
    current_page = search.page

    content_tag :ul, :class => 'pagination' do
      ActiveSupport::SafeBuffer.new.tap do |buffer|
        if current_page > 1
          buffer << content_tag(:li, :class => 'previous') do
            link_to("&larr; Previous page".html_safe, search.query_params.merge({:page => current_page - 1}), :rel => 'prev')
          end
        end

        if current_page < (max_page - 1)
          buffer << content_tag(:li, :class => 'next') do
            link_to("Next page &rarr;".html_safe, search.query_params.merge({:page => current_page + 1}), :rel => 'next')
          end
        end
      end
    end
  end

end