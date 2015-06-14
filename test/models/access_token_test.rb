require "test_helper"

describe AccessToken do
  let(:user) { FactoryGirl.build(:user) }
  let(:access_token) { AccessToken.new(user: user) }

  it "must be valid" do
    value(access_token).must_be :valid?
  end

  it "sets default values" do
    access_token.save
    access_token.name.must_be :present?
    access_token.expires_at.must_be :present?
  end

  it "can be expired" do
    access_token.save
    access_token.wont_be :expired?

    Timecop.freeze Time.now + 3.weeks do
      access_token.must_be :expired?
    end
  end
end
