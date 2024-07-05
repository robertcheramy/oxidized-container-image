# oxidized-container
Test to build slim oxidized-containers.
The actual container size is huge (1,16 GByte)

# Status
This is no productive repository. Do not use in production!

# Ideas
- use unbuntu pre compiled packages instead of building the gems.
- do not install exotic packages (aws-sdk) or provide a minimal container
  and a full one
- test CI/CD workflows of github before changing things in oxidized upstream
- generate on release (with release-number) vs. on commit (must be called something like dev-SHA)

The actual build produces 654 MBytes.


