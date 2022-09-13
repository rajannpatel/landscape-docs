Title: API Methods: Computers

# Computers

The methods available here give the ability to retrieve computers and to do basic operations on them, like tagging.

## GetComputers

Get a list of computers associated with the account used for authentication.

- `query`: A query string with space separated tokens used to filter the returned computers. Words provided as search parameters are treated as keywords, matching the hostname or the computer title. Selector prefixes can be used to further customize the search.
- `tag`: search for computers with the specified tag.
- `distribution`: search for computers running a specific Ubuntu release (can be code name like `lucid` or version number like `10.04`).
- `hostname`: search for computers with the exact hostname.
- `title`: search for computers with the exact title.
- `alert`: search for computers with a named alert being active, alerts can be one of `package-upgrades`, `security-upgrades`, `package-profiles`, `package-reporter`, `computer-offline`, `computer-reboot`.
- `access-group`: search for computers that belong to the access group with the specified name.
- `id`: select the specified numeric computer ID.
- `mac`: search for computers with the specified MAC address, which can be a substring of the full address.
- `ip`: search for computers with the specified IP address, which can be a substring of the full address. No network classing is done.
- `search`: select computers based on the result of the named search.
- `needs:reboot`: search for computers that have the reboot required flag set. Note that with this particular criteria, the only possible value for it is the text `reboot`.
- `license-id`: search for computers licensed to the specified `license-id`.
- `needs:license` OR `license-id:none`: search for computers that do not have a Landscape license, and, as a result, are not managed.
- `annotation`: search for computers which define the specified annotation key. Optionally specify `annotation:<key>:<string>` which will only return computers whose key matches and value also contains the `<string>` specified.
- `OR`: search for computers matching term A or term B. OR must be in all caps.
- `NOT`: search for computers not matching the next term. NOT must be in all caps.

If values following a prefix contains spaces or non-ASCII characters, it must be quoted.

These prefixes can be mixed and matched with keywords. For example, the following query would match computers with ‘appserver’ in their title or hostname, either with the tag ‘server’ or running the ‘hardy’ release of Ubuntu:

```text
appserver tag:server OR distribution:hardy
```

It also supports the following optional arguments:

- `limit`: The maximum number of results returned by the method. It defaults to 1000.
- `offset`: The offset inside the list of results.
- `with_network`: If true, include the details of all network devices attached to the computer.
- `with_hardware`: If true, include the details of all hardware information known.
- `with_annotations`: If true, include the details of all custom annotation information known.

For example, the following request looks for all computers with the tag ‘server’, includes their network devices, and with a limit of 20 machines:

```text
?action=GetComputers&query=tag:server&limit=20&with_network=true
```

The method returns a JSON serialized list of computers:

```json
[
    {
        "access_group": "global",
        "comment": "",
        "distribution": "12.04",
        "hostname": "a_comp.example.com",
        "id": 12345,
        "last_ping_time": "None",
        "last_exchange_time": "2011-06-3017:59Z",
        "title": "A Computer",
        "reboot_required_flag": false,
        "tags": [
            "server"
        ],
        "total_memory": "None",
        "total_swap": "None",
        "network_devices": [
            {
                "broadcast_address": "192.168.1.255",
                "interface": "eth0",
                "ip_address": "192.168.1.2",
                "mac_address": "00:1e:c9:6c:b8:de",
                "netmask": "255.255.255.0"
            }
        ]
    }
]
```

## AddAnnotationToComputers

Add a custom annotation to a selection of computers.

This method takes two mandatory arguments:

- `query`: A query string used to select the computers for which to add annotations. (See `query` under `GetComputers`, above, for additional details.)
- `key`: Annotation key to add to the selected computers.
- `value`: Annotation value associated with the provided key to add to the selected computers. (optional)

For example, the following request will add a custom annotation representing physical to all computers running Ubuntu 10.04 (Lucid):

```text
?action=AddAnnotationToComputers&query=distribution:10.04&key=location
    &value=BLDG3:FLR2:CAGE101A
```

## RemoveAnnotationFromComputers

Remove a custom annotation with the specified key from a selection of computers.

This method takes two mandatory arguments:

- `query`: A query string used to select the computers to remove annotations from. (See `query` under `GetComputers`, above, for additional details.)
- `key`: The annotation key to remove.

For example, the following request will remove the annotation key `location` from all computers with tag server:

```text
?action=RemoveAnnotationFromComputers&query=tag:server&key=location
```

## AddTagsToComputers

Add tags to a selection of computers.

This method takes two mandatory arguments:

- `query`: A query string used to select the computers to add tags to. (See `query` under `GetComputers`, above, for additional details.)
- `tags`: Tag name to be applied, this can have more than one Tag, by numbering the tags with `tags.1`, `tags.2`, `tags.3` etc.

For example, the following request will add tags “server” and “lucid” to all computers running Ubuntu 10.04 (Lucid):

```text
?action=AddTagsToComputers&query=distribution:10.04&tags.1=server
    &tags.2=lucid
```

## RemoveTagsFromComputers

Remove tags from a selection of computers.

This method takes two mandatory arguments:

- `query`: A query string used to select the computers to remove tags from. (See `query` under `GetComputers`, above, for additional details.)
- `tags`: Tag name to be remove, this can have more than one Tag, by numbering the tags with `tags.1`, `tags.2`, `tags.3` etc.

For example, the following request will remove tags “server” and “lucid” from all computers with tag server:

```text
?action=RemoveTagsFromComputers&query=tag:server&tags.1=server
    &tags.2=lucid
```

## ChangeComputersAccessGroup

Change the access group for a selection of computers.

This method takes two mandatory arguments:

- `query`: A query string used to select the computers to change access group for. (See `query` under `GetComputers`, above, for additional details.)
- `access_group`: The name of the access group to assign selected computers to.

This is an example of a valid request:

```text
action=ChangeComputersAccessGroup&query=tag:new-servers
    &access_group=server
```

The method returns a JSON serialized list of computers in the selection which have successfully changed access group:

```json
[
    {
        "access_group": "server",
        "id": 12345,
        "title": "A Computer",
        "comment": "",
        "total_memory": "None",
        "total_swap": "None",
        "reboot_required_flag": false,
        "hostname": "a_comp.example.com",
        "last_ping_time": "None",
        "last_exchange_time": "2011-06-3017:59Z",
        "tags": [
            "server"
        ],
        "network_devices": [
            {
                "broadcast_address": "192.168.1.255",
                "interface": "eth0",
                "ip_address": "192.168.1.2",
                "mac_address": "00:1e:c9:6c:b8:de",
                "netmask": "255.255.255.0"
            }
        ]
    }
]
```

The following errors may be raised:

- `InvalidQueryError`: If query format is invalid.

## RemoveComputers

Remove a list of computers by ID.

This method takes a mandatory argument:

- `computer_ids`: A list of computer IDs to remove.

This is an example of a valid request:

```text
?action=RemoveComputers&computer_ids.1=30&computer_ids.2=43
```

## GetPendingComputers

Get a list of pending computers associated with the account used for authentication:

```text
?action=GetPendingComputers
```

The method returns a JSON serialized list of pending computers:

```json
[
    {
        "id": 12345,
        "title": "My Server",
        "hostname": "server.london.company.com",
        "creation_time": "2011-06-3017:59Z",
        "vm_info": "xen",
        "client_tags": "['london'], ['server']"
    }
]
```

## AcceptPendingComputers

Accept a list of pending computers associated with the account used for authentication.

This method takes the following arguments:

- `computer_ids`: A list of pending computer IDs to accept.
- `access_group`: The name of the access group to accept the computers to. If not provided, they will be put into the global access group. (optional)

This is an example of a valid request:

```text
?action=AcceptPendingComputers?computer_ids.1=1&computer_ids.2=2
```

The method returns a JSON serialized list of accepted computers:

```json
[
    {
        "id": 12345,
        "title": "A Computer",
        "comment": "",
        "hostname": "a_comp.example.com",
        "last_exchange_time": "2011-06-3017:59Z"
    }
]
```

To replace existing computers, map the pending IDs to the existing ones:

```text
?action=AcceptPendingComputers?computer_ids.1=1&computer_ids.2=2
    &existing_ids.2=3
```

The following errors may be raised:

- `InsufficientLicenses`: Insufficient licenses available to accept new computers.
- `UnknownAccessGroup`: The access group is not known or the person is not authorized to accept pending computers into the access group.

## RejectPendingComputers

Reject a list of pending computers associated with the account used for authentication:

```text
?action=RejectPendingComputers?computer_ids.1=1&computer_ids.2=2
```

## CreateCloudOtps

Create one-time passwords used for registration of cloud instances:

```text
?action=CreateCloudOtps?count=3
```

The method returns a JSON serialized list of one-time passwords, one for each requested:

```json
["otp1", "otp2", "otp3"]
```

You can then use those OTPs in the client configuration, using cloud-init for example.

## RebootComputers

Reboot a list of computers.

This method takes a mandatory argument:

- `computer_ids`: A list of computer IDs to reboot.

It also supports an optional argument:

- `deliver_after`: Reboot the computer after the specified time. The time format is `YYYY-MM-DDTHH:MM:SSZ`.

This is an example of a valid request:

```text
?action=RebootComputers&computer_ids.1=30&computer_ids.2=43
```

The method returns a JSON serialized activity:

```json
{
    "computer_id": "None",
    "creation_time": "2012-11-19T18:11:51Z",
    "creator": {
        "email": "john@example.com",
        "id": 3,
        "name": "John Smith"
    },
    "id": 141,
    "parent_id": "None",
    "summary": "Restart computer",
    "type": "ActivityGroup"
}
```

## ShutdownComputers

Shut down a list of computers.

This method takes a mandatory argument:

- `computer_ids`: A list of computer IDs to shut down.

It also supports an optional argument:

- `deliver_after`: Shutdown the computer after the specified time. The time format is `YYYY-MM-DDTHH:MM:SSZ`.

This is an example of a valid request:

```text
?action=ShutdownComputers&computer_ids.1=30&computer_ids.2=43
```

The method returns a JSON serialized activity:

```json
{
    "computer_id": "None",
    "creation_time": "2012-11-19T18:14:19Z",
    "creator": {
        "email": "john@example.com",
        "id": 3,
        "name": "John Smith"
    },
    "id": 147,
    "parent_id": "None",
    "summary": "Shutdown computer",
    "type": "ActivityGroup"
}
```

## RenameComputers

Rename a set of computers.

This method takes a single mandataory argument:

- `computer_titles`: A mapping of computer IDs to titles to set.

This is an example of a valid request:

```text
?action=RenameComputers&computer_titles.30:newname
```