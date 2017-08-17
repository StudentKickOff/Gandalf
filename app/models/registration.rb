# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id                 :integer          not null, primary key
#  barcode            :string
#  lastname           :string
#  email              :string
#  created_at         :datetime
#  updated_at         :datetime
#  event_id           :integer
#  paid               :integer
#  student_number     :string
#  price              :integer
#  checked_in_at      :datetime
#  comment            :text
#  barcode_data       :string
#  payment_code       :string
#  phone_number       :string
#  title              :string
#  job_function       :string
#  admin_note         :string
#  firstname          :string
#  has_plus_one       :boolean
#  plus_one_title     :string
#  plus_one_firstname :string
#  plus_one_lastname  :string
#  club_id            :integer
#  payment_method     :string
#  payment_id         :string
#

class Registration < ActiveRecord::Base
  belongs_to :event
  has_many :accesses, dependent: :destroy
  has_many :access_levels, through: :accesses

  scope :paid, -> { where('price <= paid') }

  validates :firstname, presence: true
  validates :lastname, presence: true
  # Names shouldn't be unique, because people can have te same name
  # validates :name, presence: true, uniqueness: { scope: :event_id }
  # Uniqueness temporarily disabled; see the Partner model for the reason
  # validates :email, presence: true, uniqueness: { scope: :event_id }
  validates :email, presence: true, email: true
  validates :student_number, format: { with: /\A[0-9]*\Z/, message: 'has invalid format' },
                             allow_blank: true
  # TODO: fix student_number uniqueness when having a plus one
  validates :student_number, presence: true, if: 'access_levels.first.try(:requires_login?)'
  validates :paid, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :payment_code, presence: true, uniqueness: true
  validates :phone_number, presence: true, if: 'phone_number_required?'
  validates :comment, presence: true, if: 'comment_required?'
  validates :title, presence: true, if: 'extra_info_required?'
  validates :job_function, presence: true, if: 'extra_info_required?'

  validates :plus_one_title, presence: true, if: 'has_plus_one?'
  validates :plus_one_firstname, presence: true, if: 'has_plus_one?'
  validates :plus_one_lastname, presence: true, if: 'has_plus_one?'

  has_paper_trail only: %i[paid payment_code checked_in_at]

  before_validation do |record|
    if record.payment_code.nil?
      record.payment_code = Registration.create_payment_code
    end
  end

  after_save do |record|
    record.access_levels.each do |access_level|
      if !access_level.capacity.nil? && access_level.registrations.count > access_level.capacity
        record.errors.add :access_levels, 'type is sold out.'
        raise ActiveRecord::Rollback
      end
    end
  end

  default_scope { order 'lastname ASC' }

  def paid
    from_cents read_attribute(:paid)
  end

  def paid=(value)
    write_attribute :paid, to_cents(value)
  end

  def to_pay
    price - paid
  end

  def to_pay=(value)
    self.paid = price - (to_cents(value) / 100.0)
  end

  def price
    from_cents read_attribute(:price)
  end

  def price=(value)
    write_attribute(:price, to_cents(value))
  end

  def is_paid
    price <= paid
  end

  def generate_barcode
    self.barcode_data = Array.new(12) { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: barcode_data)
    self.barcode = calculated_barcode.caption_data
    save!
  end

  def name
    "#{lastname} #{firstname}"
  end

  def family_name
    lastname
  end

  def self.find_payment_code_from_csv(csvline)
    match = /GAN\d+/.match(csvline)
    if match
      return Registration.find_by_payment_code(match[0])
    else
      return false
    end
  end

  def self.create_payment_code
    random = rand(10**15)
    format('GAN%02d%015d', random % 97, random)
  end

  def deliver
    generate_barcode if barcode.nil?

    if is_paid
      RegistrationMailer.ticket(self).deliver_now
    else
      RegistrationMailer.confirm_registration(self).deliver_now
    end
  end

  def self.personal_titles
    %i[prof dr ms mr mx]
  end

  def self.personal_titles_scope
    'registration.titles'
  end

  def salutation
    return '' unless title

    I18n.t(title, scope: Registration.personal_titles_scope) + ' '
  end

  private

  def from_cents(value)
    (value || 0) / 100.0
  end

  def to_cents(value)
    value.sub!(',', '.') if value.is_a? String
    (value.to_f * 100).to_int
  end

  def phone_number_required?
    event && event.phone_number_state == 'required'
  end

  def comment_required?
    return false unless event && event.id == 1
    access_levels.each do |access_level|
      return true if access_level.has_comment
    end
    false
  end

  def extra_info_required?
    event && event.extra_info
  end
end
