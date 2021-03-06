# Copyright 2018 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule OMG.Watcher.Integration.WatcherApiTest do
  use ExUnitFixtures
  use ExUnit.Case, async: false
  use OMG.API.Fixtures
  use OMG.API.Integration.Fixtures

  use Plug.Test

  alias OMG.Watcher.Integration.TestHelper, as: IntegrationTest

  @eth_hex String.duplicate("00", 20)

  @moduletag :integration

  @tag fixtures: [:watcher_sandbox, :child_chain, :token, :alice, :alice_deposits]
  test "utxos from deposits on child chain are available in WatcherDB", %{
    alice: alice,
    token: token,
    alice_deposits: {deposit_blknum, token_deposit_blknum}
  } do
    token_addr = token |> Base.encode16()

    # expected utxos
    eth_deposit = %{
      "amount" => 10,
      "blknum" => deposit_blknum,
      "txindex" => 0,
      "oindex" => 0,
      "currency" => @eth_hex,
      "txbytes" => nil
    }

    token_deposit = %{
      "amount" => 10,
      "blknum" => token_deposit_blknum,
      "txindex" => 0,
      "oindex" => 0,
      "currency" => token_addr,
      "txbytes" => nil
    }

    # utxo from deposit should be available
    assert [eth_deposit, token_deposit] == IntegrationTest.get_utxos(alice)
  end
end
