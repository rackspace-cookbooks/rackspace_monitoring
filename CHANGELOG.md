rackspace_monitoring CHANGELOG
==================

1.1.3
-----
- #46 - don't call an attribute on the resource when it shouldn't exist

1.1.2
-----
- #37 - updates to the agent.plugin template
- #33 - Adds a package_channel attribute to rackspace_monitoring_service to allow choosing the unstable channel. I deliberately left that out of the docs as I don't want to encourage use of unstable, but it's useful for testing the cookbook against upcoming agent releases. Prevents hanging the Chef run while the agent prompts for input if create_entity is false on a rackspace_monitoring_service resource. The --no-entity flag was added in version 2.2.10. Older versions will ignore the flag.
- #31 - update logic behind identifying best IP address

1.1.1
-----
- #29, #30 - fix the interpretation of plugin arguments, fix template escapes

1.1.0
-----
- #18 - add plugin_cookbook as alternate way to install agent plugins
- #21 - fix some rubocop and other style issues
- #6  - add plugin_cookbook as alternate way to install agent plugins
- #15 - fix agent.custom template yaml syntax
- #12 - Ensure templates correctly use int, not string

1.0.6
-----
- added support for agent_filename

1.0.5
-----
- Ensure a downloaded plugin is executable

1.0.4
-----
- Handle parsing filename even if type is not agent.plugin

1.0.3
-----
- Changed cookbook_name template variable to cookbook
- Fixed hard coded notification plan in remote.http check

1.0.2
-----
- fixed missing { in memory alarm

1.0.1
-----
- Updated some metadatas

1.0.0
-----
- Rename cookbook
- First stable release

0.0.7
-----
- more integration tests
- alarm criteria have their own templates

0.0.6
-----
- Updated default threshold for Network check

0.0.5
-----
- Fixed behavior on auto-target without alarm #10

0.0.4
-----
- No default alarm_criteria for agent.disk, disable alarm if automatic target detection and no alarm_criteria
