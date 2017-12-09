defmodule SDRTest do
  use ExUnit.Case, async: true

  doctest SDR

  test "can new up an SDR" do
    %SDR{n: n, w: w, body: _body} = SDR.new
    assert n == 2048
    assert w == 0
  end

  test "can new up an SDR with custom n" do
    %SDR{n: n, w: w, body: _body} = SDR.new([], 4096)
    assert n == 4096
    assert w == 0
  end

  test "can new up an SDR with custom n and active entries" do
    %SDR{n: n, w: w, body: _body} = SDR.new(MapSet.new([1,223, 1824]), 4096)
    assert n == 4096
    assert w == 3
  end

  test "can new up an SDR with custom n and active entries as list" do
    %SDR{n: n, w: w, body: _body} = SDR.new([1,223, 1824], 4096)
    assert n == 4096
    assert w == 3
  end

  test "can calculate an SDR sparsity" do
    sdr = SDR.new([1], 10)

    assert SDR.sparsity(sdr) == 0.10
  end

  test "can calculate the overlap of two SDRs" do
    sdr1 = SDR.new([1,2], 100)
    sdr2 = SDR.new([2,3], 100)

    assert SDR.overlap(sdr1, sdr2) == 1
  end

  test "can calculate a match between SDRs" do
    sdr1 = SDR.new([1,2], 100)
    sdr2 = SDR.new([2,3], 100)

    assert SDR.match?(sdr1, sdr2, 2) == false
    assert SDR.match?(sdr1, sdr2, 1) == true
  end

  test "can take the union of two SDRs" do
    sdr1 = SDR.new([1,2], 100)
    sdr2 = SDR.new([2,3], 100)

    %SDR{body: body, w: w} = SDR.union(sdr1, sdr2)
    assert body == MapSet.new([1,2,3])
    assert w == 3
  end

  test "can subsample an SDR" do
    sdr = SDR.new([1,2,3,4,5,6,7,8,9,10])

    result = SDR.subsample(sdr, 6)
    assert Enum.count(result) == 6
    assert Enum.min(result) > 0
    assert Enum.max(result) < 11
    assert Enum.at(result, 0) < Enum.at(result, 1)
  end

  test "subsequent subsamples are not equivalent (within nPr chance 1:997002000)" do
    sdr = SDR.new(Enum.to_list(1..1000))
    sub1 = SDR.subsample(sdr, 3)
    sub2 = SDR.subsample(sdr, 3)
    assert sub1 != sub2
  end

end
