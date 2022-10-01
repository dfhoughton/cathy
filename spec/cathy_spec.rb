# frozen_string_literal: true

RSpec.describe Cathy do
  it "has a version number" do
    expect(Cathy::VERSION).not_to be nil
  end

  it "picks things with the expected frequences" do
    picker = Cathy.new
    4.times { picker.add :foo }
    picker.add :bar
    map = Hash.new(0)
    5000.times { map[picker.pick] += 1 }
    expect((map[:foo] / 1000.0).round).to eq(4)
    expect((map[:bar] / 1000.0).round).to eq(1)
  end

  it "serializes and deserializes properly" do
    picker = Cathy.new
    %i[a b c d e f g].each_with_index { |c, i| (i + 1).times { picker.add c } }
    counts = {a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7}
    expect(picker.counts.to_a.sort_by(&:first).to_h).to eq(counts)
    expect(Cathy.from_counts(counts).counts).to eq(picker.counts)
    expect(Cathy.from_counts(counts.to_a.reverse.to_h).counts).to eq(picker.counts)
  end
end
