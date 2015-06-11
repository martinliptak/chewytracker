require "test_helper"

describe User do
  let(:user_params) { 
    { 
      name: "I Am Grook", 
      email: "iamgrook@example.com", 
      password: "password", 
      password_confirmation: "password" 
    } 
  }
  let(:user) { 
    User.new user_params 
  }

  it "is valid with valid params" do
    user.must_be :valid?
  end

  it "is invalid without required params" do
    user_params.clear

    user.wont_be :valid?
    user.errors[:name].must_be :present? 
    user.errors[:email].must_be :present? 
    user.errors[:password].must_be :present? 
    user.errors[:password_confirmation].must_be :present? 
  end

  it "has default settings" do
    user.settings.must_equal {}
  end
end