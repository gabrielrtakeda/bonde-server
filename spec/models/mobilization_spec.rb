require 'rails_helper'

RSpec.describe Mobilization, type: :model do
  it { should belong_to :user }
  it { should have_many :blocks }
  it { should have_many(:widgets).through(:blocks) }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :goal }

  context "generate a slug" do
    before do
      @mobilization = Mobilization.create!(name: "mobilization", goal: "change the world", user: User.make!)
    end

    it "should include mobilization's name" do
      expect(@mobilization.slug).to include @mobilization.name.parameterize
    end
  end
end
