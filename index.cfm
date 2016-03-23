<cfinclude template="plugin/config.cfm" />
<cfsavecontent variable="body">
	<cfoutput>
		<h2>Mura Mail Obfuscator</h2>
		<p>MuraMailObfuscator is a Mura CMS Plugin to obfuscate all email addresses in your source code.</p>

		<hr>

		<h3>Installation</h3>
		<p>While installing the plugin, simply assign all SiteIDs you want the plugin to affect.</p>
		
		<hr>

		<h3>Usage</h3>
		<p>That's all. The Plugin obfuscates all E-Mail Addresses for you.</p>
		
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#application.pluginManager.renderAdminTemplate(body=body,pageTitle=request.pluginConfig.getName())#
</cfoutput>

