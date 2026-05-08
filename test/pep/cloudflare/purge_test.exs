defmodule Pep.Cloudflare.PurgeTest do
  use ExUnit.Case, async: true

  alias Pep.Cloudflare.Purge

  describe "call/0" do
    test "returns {:ok, pid} from Task.start without raising" do
      assert {:ok, pid} = Purge.call()
      assert is_pid(pid)
    end
  end
end
