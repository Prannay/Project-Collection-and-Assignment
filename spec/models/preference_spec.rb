require 'spec_helper'

describe Preference, :type => :model do
  it { should belong_to :team }
  it { should belong_to :project}
  it { should validate_presence_of :team_id }
  it { should validate_presence_of :project_id }
end
