# frozen_string_literal: true

module ApplicationHelper
  # Prettify helpers
  def nice_time(f)
    f.try { |d| l(d, format: '%a %d %b %Y %H:%M') }
  end

  def datepicker_time(f)
    f.try { |d| d.strftime('%Y-%m-%d %H:%M') }
  end

  def nice_date(f)
    f.try { |d| l(d, format: '%a %d %b %Y') }
  end

  def euro(f)
    "&euro;#{number_with_precision f, precision: 2}"
  end

  # Form helpers
  def form_errors(object)
    render partial: 'form_errors', locals: { object: object }
  end

  def form_text_field(f, tag)
    render partial: 'form_text_field', locals: { f: f, tag: tag }
  end

  def form_url_field(f, tag)
    render partial: 'form_url_field', locals: { f: f, tag: tag }
  end

  def form_text_area(f, tag, label_text = nil)
    render partial: 'form_text_area', locals: { f: f, tag: tag, label_text: label_text }
  end

  def form_fancy_text_area(f, tag)
    render partial: 'form_fancy_text_area', locals: { f: f, tag: tag }
  end

  def form_email_field(f, tag)
    render partial: 'form_email_field', locals: { f: f, tag: tag }
  end

  def form_telephone_field(f, tag, show_disclaimer)
    render partial: 'form_telephone_field', locals: { f: f, tag: tag, show_disclaimer: show_disclaimer }
  end

  def form_date_field(f, tag, id, value)
    render partial: 'form_date_field', locals: { f: f, tag: tag, id: id, value: value }
  end

  def form_number_field(f, tag)
    render partial: 'form_number_field', locals: { f: f, tag: tag }
  end

  def form_radio_field(f, tag, selected_state, states, show_label = true, do_translate = false, scope = '')
    render partial: 'form_radio_field', locals: { f: f, tag: tag, selected_state: selected_state, states: states,
                                                  show_label: show_label, do_translate: do_translate, scope: scope }
  end

  def form_collection_select(f, *args)
    # This line enable passing optional arguments such as include_blank to the
    # partial. If nothing is passed, an empty options hash is appended.
    args << {} if args.length < 5

    render partial: 'form_collection_select', locals: { f: f, args: args }
  end

  def form_check_box(f, tag, options = nil)
    render partial: 'form_check_box', locals: { f: f, tag: tag, options: options }
  end

  # Pagination
  def bootstrap_pagination(collection)
    render partial: 'bootstrap_pagination', locals: { collection: collection }
  end
end
