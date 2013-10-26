module ApplicationHelper

  def form_errors(object)
    render partial: "form_errors", locals: {object: object}
  end

  def form_text_field(f, tag)
    render partial: "form_text_field", locals: {f: f, tag: tag}
  end

  def form_date_field(f, tag, id, value)
    render partial: "form_date_field", locals: {f: f, tag: tag, id: id, value: value}
  end

  def form_text_area(f, tag)
    render partial: "form_text_area", locals: {f: f, tag: tag}
  end

end
