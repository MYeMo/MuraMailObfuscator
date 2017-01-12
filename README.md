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

```<a href="noscheme:{B56EA301155D001001BD633AF0965731}">John Doe</a>```

And renders the real Email-Address client side.
