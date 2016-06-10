# Testing

## Background

Testing for this cookbook includes rspec (chefspec) as well as test-kitchen. The following environment variables must be set in order to test this cookbook using a real connection to Rackspace:

```
RACKSPACE_USERNAME
RACKSPACE_API_KEY
```

Additionally, you should configure test-kitchen to build a Rackspace cloud server in the region you'd like test. You may also set the environment variable `RACKSPACE_AGENT_CHANNEL` to whichever monitoring agent release channel you'd like to use (defaults to `stable`).
