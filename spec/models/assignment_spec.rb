require 'spec_helper'

describe Assignment, :type => :model do
  it { should belong_to :team }
  it { should belong_to :project}
end
