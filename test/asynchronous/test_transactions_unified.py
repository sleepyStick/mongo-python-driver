# Copyright 2021-present MongoDB, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Test the Transactions unified spec tests."""
from __future__ import annotations

import os
import sys
from pathlib import Path

sys.path[0:0] = [""]

from test import client_context, unittest
from test.asynchronous.unified_format import generate_test_classes

_IS_SYNC = False


def setUpModule():
    pass


# Location of JSON test specifications.
if _IS_SYNC:
    TEST_PATH = os.path.join(Path(__file__).resolve().parent, "transactions/unified")
else:
    TEST_PATH = os.path.join(Path(__file__).resolve().parent.parent, "transactions/unified")

# Generate unified tests.
globals().update(generate_test_classes(TEST_PATH, module=__name__))

# Location of JSON test specifications for transactions-convenient-api.
if _IS_SYNC:
    TEST_PATH = os.path.join(Path(__file__).resolve().parent, "transactions-convenient-api/unified")
else:
    TEST_PATH = os.path.join(
        Path(__file__).resolve().parent.parent, "transactions-convenient-api/unified"
    )

# Generate unified tests.
globals().update(generate_test_classes(TEST_PATH, module=__name__))

if __name__ == "__main__":
    unittest.main()
