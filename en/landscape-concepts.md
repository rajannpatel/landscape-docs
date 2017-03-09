Title: Concepts

# Concepts

## Tags

Landscape lets you group multiple computers by applying tags to them. You can
group computers using any set of characteristics; architecture and location
might be two logical tagging schemes. Tag names may use any combination of
letters, numbers, and dashes. Each computer can be associated with multiple
tags. There is no menu choice for tags; rather, you can select multiple
computers under the COMPUTERS menu and apply or remove one or more tags to all
the ones you select on the INFO screen. If you want to specify more than one
tag at a time for your selected computers, separate the tags by spaces.

## Packages

In Linux, a package is a group of related files for an application that make it
easy to install, upgrade, and remove the application. You can manage packages
from the PACKAGES menu under COMPUTERS.

## Repositories

Linux distributions like Ubuntu use repositories to hold packages you can
install on managed computers. While Ubuntu has [several
repositories][repositories] that anyone can access, you can also maintain your
own repositories on your network.  This can be useful when you want to maintain
packages with different versions from those in the community repositories, or
if you've packages in- house software for installation. Landscape's [12.09
release notes][releasenotes] contain a quick tutorial about repository
management.

## Upgrade profiles

An upgrade profile defines a schedule for the times when upgrades are to be
automatically installed on the machines associated with a specific access
group. You can associate zero or more computers with each upgrade profile via
tags to install packages on those computers. You can also associate an upgrade
profile with an access group, which limits its use to only computers within
the specified access group. You can manage upgrade profiles from the UPGRADE
PROFILES link in the PROFILES choice under your account.

## Package profiles

A package profile, or meta-package, comprises a set of one or more packages,
including their dependencies and conflicts (generally called constraints),
that you can manage as a group. Package profiles specify sets of packages that
associated systems should always get, or never get. You can associate zero or
more computers with each package profile via tags to install packages on those
computers. You can also associate a package profile with an access group,
which limits its use to only computers within the specified access group. You
can manage package profiles from the Package Profiles link in the PROFILES
menu under your account.

## Removal profiles

A removal profile defines a maximum number of days that a computer can go
without exchanging data with the Landscape server before it is automatically
removed. If more days pass than the profile's "Days without exchange", that
computer will automatically be removed and the license seat it held will be
released. This helps Landscape keep license seats open and ensure Landscape is
not tracking stale or retired computer data for long periods of time. You can
associate zero or more computers with each removal profile via tags to ensure
those computers are governed by this removal profile. You can also associate a
removal profile with an access group, which limits its use to only computers
within the specified access group. You can manage removal profiles from the
REMOVAL PROFILES link in the PROFILES choice under your account.

## Scripts

Landscape lets you run scripts on the computers you manage in your account.
The scripts may be in any language, as long as an interpreter for that
language is present on the computers on which they are to run. You can
maintain a library of scripts for common tasks. You can manage scripts from
the STORED SCRIPTS menu under your account, and run them against computers
from the SCRIPTS menu under COMPUTERS.

## Administrators

Administrators are people who are authorized to manage computers using
Landscape. You can manage administrators from the ADMINISTRATORS menu under
your account.

## Access Groups

Landscape lets administrators limit administrative rights on computers by
assigning them to logical groupings called access groups. Each computer can be
in only one access group. Typical access groups might be constructed around
organizational units or departments, locations, or hardware architecture. You
can manage access groups from the ACCESS GROUPS menu under your account; read
about [how to create access groups][createaccess], [add computers to access
groups][addcomputers], and [associate administrators with access
groups][admins].  It is good policy to come up with and document a naming
convention for access groups before you deploy Landscape, so that all
administrators understand what constitutes an acceptable logical grouping for
your organization.

## Roles

For each access group, you can assign management privileges to administrators
via the use of roles. Administrators may be associated with multiple roles, and
roles may be associated with many access groups. You can manage roles from the
ROLES menu under your account.

## Alerts

Landscape uses alerts to notify administrators of conditions that require
attention. You can manage alerts from the ALERTS menu under your account.

[repositories]: https://help.ubuntu.com/community/Repositories/Ubuntu
[releasenotes]: ./release-notes.md#repository-management-getting-started
[createaccess]: ./landscape-access-groups.md#creating-access-groups
[addcomputers]: ./landscape-access-groups.md#adding-computers-to-access-groups
[admins]: ./landscape-access-groups.md#associating-roles-with-access-group
