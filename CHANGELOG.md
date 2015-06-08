rackspace_monitoring CHANGELOG
==================

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
