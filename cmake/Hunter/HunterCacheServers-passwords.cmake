# Cable: CMake Bootstrap Library.
# Copyright 2018 Pawel Bylica.
# Licensed under the Apache License, Version 2.0. See the LICENSE file.

# Hunter passwords file used by HunterCacheServers.cmake.
# Do not include directly.

hunter_upload_password(
    # REPO_OWNER + REPO = https://github.com/letheanVPN/hunter-cache
    REPO_OWNER letheanVPN
    REPO hunter-cache

    # USERNAME = https://github.com/snider
    USERNAME snider

    # PASSWORD = GitHub token saved as a secure environment variable
    PASSWORD "$ENV{HUNTER_CACHE_TOKEN}"
)
