require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    it "renders the home/index template" do
      get :index
      expect(response).to render_template("home/index")
    end
  end
end
