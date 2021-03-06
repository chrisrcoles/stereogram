require 'rails_helper'

describe Follow do
  let (:test_user) {create :user}
  let (:test_follower) {create :user}

  it "should have users that have the ability to follow other users" do
    expect(test_user).to respond_to(:follow)
  end

  it "should keep track of the users a given user is following" do
    expect(test_user).to respond_to(:following)
  end

  it "should be valid if an existing user follows another existing user" do
    expect(test_follower.follow(test_user)).to be_valid
  end

  it "should allow users to follow other users" do
    expect{test_follower.follow(test_user)}.to change {Follow.count}.by(1)
  end

  it "assigns the correct user to be followed" do
    test_follower.follow(test_user)
    expect(test_follower.is_following?(test_user)).to eq(Follow.all.last)
  end

  it "should allow users to unfollow users they previously followed" do
    test_follower.follow(test_user)
    expect{test_follower.unfollow(test_user)}.to change {Follow.count}.by(-1)
  end
end
