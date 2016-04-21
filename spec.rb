require 'minitest/autorun'

require_relative 'differentiator'

describe :test_data do

  # a proc that returns a proc, not how I want it but only way to get this to be dry
  subject { proc {|input| Differentiator.new(input).result }}

  it "expects result to be 6x+2" do
    subject.([3,2,1]).must_equal "6x+2"
  end

  it "expects result to be 12x^2+6x+2" do
    subject.([4,3,2,1]).must_equal "12x^2+6x+2"
  end

  it "expects result to be 12x^2#{-10}x" do
    subject.([4,-5,0,1]).must_equal "12x^2#{-10}x"
  end


end
