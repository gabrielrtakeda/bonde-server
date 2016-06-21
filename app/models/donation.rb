class Donation < ActiveRecord::Base
  store_accessor :customer
  belongs_to :widget
  belongs_to :activist
  has_one :mobilization, through: :widget
  has_one :organization, through: :mobilization
  has_many :payments

  after_create :send_mail, unless: :skip?

  delegate :name, to: :mobilization, prefix: true
  scope :by_widget, -> (widget_id) { where(widget_id: widget_id) if widget_id }

  def boleto?
    self.payment_method == 'boleto'
  end

  def self.to_txt
    attributes = %w{id email amount_formatted payment_method mobilization_name
    widget_id created_at customer transaction_id transaction_status}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |donation|
        csv << attributes.map{ |a| donation.send(a) }
      end
    end
  end

  def amount_formatted
    self.amount / 100
  end

  def send_mail
    DonationsMailer.thank_you_email(self).deliver_now
  end
end
