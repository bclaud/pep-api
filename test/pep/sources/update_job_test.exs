defmodule Pep.Sources.UpdateJobTest do
  use ExUnit.Case, async: true

  alias Pep.Sources.UpdateJob

  describe "shift_ano_mes/2" do
    test "shifts forward within the same year" do
      assert UpdateJob.shift_ano_mes("202101", 0) == "202101"
      assert UpdateJob.shift_ano_mes("202101", 1) == "202102"
      assert UpdateJob.shift_ano_mes("202101", 2) == "202103"
      assert UpdateJob.shift_ano_mes("202106", 3) == "202109"
    end

    test "shifts backward within the same year" do
      assert UpdateJob.shift_ano_mes("202112", -1) == "202111"
      assert UpdateJob.shift_ano_mes("202112", -3) == "202109"
      assert UpdateJob.shift_ano_mes("202106", -5) == "202101"
    end

    test "shifts across year boundary going forward" do
      assert UpdateJob.shift_ano_mes("202110", 3) == "202201"
      assert UpdateJob.shift_ano_mes("202111", 2) == "202201"
      assert UpdateJob.shift_ano_mes("202112", 1) == "202201"
      assert UpdateJob.shift_ano_mes("202112", 3) == "202203"
    end

    test "shifts across year boundary going backward" do
      assert UpdateJob.shift_ano_mes("202101", -1) == "202012"
      assert UpdateJob.shift_ano_mes("202101", -3) == "202010"
      assert UpdateJob.shift_ano_mes("202102", -4) == "202010"
      assert UpdateJob.shift_ano_mes("202103", -15) == "201912"
    end

    test "handles edge of year 2020" do
      assert UpdateJob.shift_ano_mes("202001", -1) == "201912"
      assert UpdateJob.shift_ano_mes("201912", 1) == "202001"
    end

    test "shifts work correctly with update_range -3..3" do
      source_ano_mes = "202103"

      results =
        Enum.map(-3..3, fn x ->
          UpdateJob.shift_ano_mes(source_ano_mes, x)
        end)

      assert results == [
               "202012",
               "202101",
               "202102",
               "202103",
               "202104",
               "202105",
               "202106"
             ]
    end
  end
end
