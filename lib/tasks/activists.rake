namespace :activists do
  desc 'Delete activists no used'
  task free_not_used: [:environment] do
    Activist.all.order(:id).each do |activist| 
      if (Donation.where("activist_id = #{activist.id}").count == 0) && (FormEntry.where("activist_id = #{activist.id}").count == 0) && 
         (ActivistPressure.where("activist_id = #{activist.id}").count == 0) && (ActivistMatch.where("activist_id = #{activist.id}").count == 0) && 
         (CreditCard.where("activist_id = #{activist.id}").count == 0) && (Payment.where("activist_id = #{activist.id}").count == 0)
          activist.addresses.each{|addr| addr.delete}
          activist.delete
      end
    end
  end

  desc 'Correct hash data on email field'
  task hash_on_email_field: [:environment] do
    Activist.where("email like '[{%}]'").each do |activist|
      begin
        data = eval(activist.email)
        registros = data.select{|dt| dt['label'].downcase == 'email' || dt['label'].downcase =='correo electrónico' || dt['label'].downcase == 'e-mail' }
        if registros.size
          activist.email = registros[0]['value']
          activist.save! validate: false
        end
      rescue StandardError => e
        p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        p "Registro: #{activist.id}"
        p "Email: #{activist.email}"
        p activist.errors
        p e
        p '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
      end
    end
  end

end

namespace :activists_from do
  desc 'Create or identify activists on donations with blank activist_id'
  task donations: [:environment] do
    donations = Donation.where('activist_id is null')
    donations.each {|d| d.generate_activist }
    
    no_activists = donations.select{|d| d.activist_id == nil }
    no_activists.each do |don|
      don.activist = Activist.order(:id).find_by_email(don.email)
      don.save
    end
  end

  desc 'Create or identify activists on form_entries with blank activist_id'
  task form_entries: [:environment] do
    fes = FormEntry.where('activist_id is null')
    fes.each {|d| d.generate_activist }
  end

  desc 'Create or identify activists on form_entries and donations with blank activist_id'
  task all: ['donations:load_donation_customers', 'activists_from:donations', 'activists_from:form_entries']
end