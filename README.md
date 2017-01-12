# MuraMailObfuscator
MuraMailObfuscator is a Mura CMS Plugin to obfuscate all email addresses in your source code.

## Installation
While installing the plugin, simply assign all SiteIDs you want the plugin to affect.

## Usage
That's all. The Plugin obfuscates all E-Mail Addresses for you.

## Dependencies
MuraMailObfuscator requires jQuery.

## Example
MuraMailObfuscator automatically changes your HTML source code from this:

```<a href="mailto:john.doe@foo.corp">John Doe</a>```

To this:

```<a href="urn:MB85C6598F691B32C4B513827EA48FD59O:{MB85C65970A276D8DE1935CA3D3C3EAC2O}{B85C65ACB003123ECB07B03459BC71BF}">John Doe</a>```

And renders the real Email-Address client side.
