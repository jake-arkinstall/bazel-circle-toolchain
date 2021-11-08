# Copyright 2021 Jake Arkinstall
#
# Work based on efforts copyrighted 2018 The Bazel Authors.
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

load("//toolchain/internal:common.bzl", _python = "python")

# If a new Circle version is missing from this list, please add the details here
# and send a PR on github. To calculate the sha256, use
# ```
# curl -s https://www.circle-lang.org/linux/build_{X}.tgz | sha256sum
# ```

_circle_builds = {
    "141": struct(
        version = "141",
        url = "https://www.circle-lang.org/linux/build_141.tgz",
        sha256 = "90228ff369fb478bd4c0f86092725a22ec775924bdfff201cd4529ed9a969848",
    ),
    "142": struct(
        version = "142",
        url = "https://www.circle-lang.org/linux/build_142.tgz",
        sha256 = "fda3c2ea0f9bfb02e9627f1cb401e6f67a85a778c5ca26bd543101d51f274711",
    ),
}

def download_circle(rctx):
    circle_version = str(rctx.attr.circle_version)
    if circle_version not in _circle_builds:
        fail("Circle version %s has not been configured in toolchain/internal/circle_builds.bzl" % circle_version)

    spec = _circle_builds[circle_version]
    rctx.download_and_extract(
        spec.url,
        sha256 = spec.sha256,
    )
