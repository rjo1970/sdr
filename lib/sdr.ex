defmodule SDR do
  @moduledoc """
  A Sparse Densitity Representation (SDR) Implementation
  """
  @member_size 2048

  defstruct(
    n: @member_size,  # Number of bits
    w: 0,     # Number of active bits
    body: MapSet.new # Collection of bit references
  )

  @doc """
  New up an SDR instance.

  ## Examples

      iex> SDR.new
      %SDR{}

  """
  def new() do
    %SDR{}
  end

  def new(body, n \\ @member_size) do
    if (is_list(body)) do
      set = MapSet.new(body)
      %SDR{n: n, body: set, w: MapSet.size(set)}
    else
      %SDR{n: n, body: body, w: MapSet.size(body)}
    end
  end

  def sparsity(%SDR{n: n, w: w}) do
    w / n
  end

  def overlap(%SDR{body: body1}, %SDR{body: body2}) do
    MapSet.intersection(body1, body2)
    |> MapSet.size
  end

  def match?(sdr1, sdr2, theta) do
    overlap(sdr1, sdr2) >= theta
  end

  def union(%SDR{body: body1, n: n}, %SDR{body: body2, n: n}) do
    MapSet.union(body1, body2)
    |> new(n)
  end

  def subsample(%SDR{body: body}, sample_size) do
    MapSet.to_list(body)
    |> Enum.shuffle
    |> Enum.take(sample_size)
    |> Enum.sort
  end
end
