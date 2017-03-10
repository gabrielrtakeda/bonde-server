require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DnsHostedZonesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:community) { create(:community) }

  before do
    CommunityUser.create community:community, user: user, role:1
  end

  # This should return the minimal set of attributes required to create a valid
  # DnsHostedZone. As you add validations to DnsHostedZone, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      domain_name: "nossas.org.br",
      comment: "new domain for ourcities"
    }
  }

  let(:invalid_attributes) {
    {
      comment: "new domain for ourcities"
    }
  }
  

  before { stub_current_user(user) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DnsHostedZonesController. Be sure to keep this updated too.
  describe "GET #index" do
    let!(:dns_hosted_zone) { create(:dns_hosted_zone, community: community) }
    it "assigns all dns_hosted_zones as @dns_hosted_zones" do
      get :index, {community_id: community.id}

      expect(assigns(:dns_hosted_zones)).to eq([dns_hosted_zone])
    end
  end

  describe "GET #show" do
    it "assigns the requested dns_hosted_zone as @dns_hosted_zone" do
      dns_hosted_zone = create(:dns_hosted_zone, community: community)
      get :show, {community_id: community.id, id: dns_hosted_zone.to_param}
  
      expect(assigns(:dns_hosted_zone)).to eq(dns_hosted_zone)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DnsHostedZone" do
        expect {
          post :create, {community_id: community.id, dns_hosted_zone: valid_attributes, format: :json}
        }.to change(DnsHostedZone, :count).by(1)
      end

      it "assigns a newly created dns_hosted_zone as @dns_hosted_zone" do
        post :create, {community_id: community.id, dns_hosted_zone: valid_attributes, format: :json}
        expect(assigns(:dns_hosted_zone)).to be_a(DnsHostedZone)
        expect(assigns(:dns_hosted_zone)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved dns_hosted_zone as @dns_hosted_zone" do
        post :create, {community_id: community.id, dns_hosted_zone: invalid_attributes, format: :json}
        expect(assigns(:dns_hosted_zone)).to be_a_new(DnsHostedZone)
      end
    end

  end

  describe "PUT #update" do
    let!(:dns_hosted_zone) { create(:dns_hosted_zone, community: community) }

    context "with valid params" do
      before do 
        put :update, {community_id: community.id, id: dns_hosted_zone.id, dns_hosted_zone: valid_attributes, format: :json} 
      end
      
      it { should respond_with(200) }

      it "updates the requested dns_hosted_zone" do
        dns_hosted_zone.reload
        expect(dns_hosted_zone.domain_name).to eq(valid_attributes[:domain_name])
        expect(dns_hosted_zone.comment).to eq(valid_attributes[:comment])
      end

      it "assigns the requested dns_hosted_zone as @dns_hosted_zone" do
        expect(assigns(:dns_hosted_zone)).to eq(dns_hosted_zone)
      end
    end

    context "with invalid params" do
      before do 
        put :update, {community_id: community.id, id: dns_hosted_zone.id, dns_hosted_zone: invalid_attributes, format: :json} 
      end
      
      it "assigns the dns_hosted_zone as @dns_hosted_zone" do
        expect(assigns(:dns_hosted_zone)).to eq(dns_hosted_zone)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:dns_hosted_zone) { create(:dns_hosted_zone, community: community) }
    it "destroys the requested dns_hosted_zone" do
      expect {
        delete :destroy, {id: dns_hosted_zone.to_param, community_id: community.id}
      }.to change(DnsHostedZone, :count).by(-1)
    end

  end

end
