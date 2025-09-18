from __future__ import annotations

import subprocess

for i in range(1, 101):
    print(f"running {i}")  # noqa:T201
    with open(f"/Users/iris.ho/Github/backpressure/runs/1.5/25/{i}.txt", "w") as f:
        result = subprocess.run(
            ["python3.13t", "withTransaction.py"],  # noqa:S607,S603
            stdout=f,
            text=True,
            check=True,
        )
