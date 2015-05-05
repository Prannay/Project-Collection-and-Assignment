require 'spec_helper'

describe Relationship, :type => :model do
  it { should belong_to :team }
  it { should belong_to :user}
  it { should validate_presence_of :team_id }
  it { should validate_presence_of :user_id }
end
