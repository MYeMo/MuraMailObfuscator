<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

	<cffunction name="onApplicationLoad">
		<cfargument name="$" />
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>


	<cffunction name="onRenderEnd">
		<cfargument name="$">
		<cfset request.jsBase64 				= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsInit 					= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsSetContent			= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsDecrypt 				= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsMails 					= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsMultiplicators = "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsIdentifier 		= "M#replace(createuuid(), '-', '', 'ALL')#O">
		<cfset request.jsScheme 				= "M#replace(createuuid(), '-', '', 'ALL')#O">

		<cfset writeJavaScript()>
		<cfset local.obfuscatedResponse = obfuscateMails($.event( "__MuraResponse__" ))>
		<cfset $.event( "__MuraResponse__", local.obfuscatedResponse ) />
	</cffunction>


	<cffunction name="obfuscateMails" returntype="string">
		<cfargument name="content" type="string" default="">

		<cftry>
			<!--- initialize content --->
			<cfset local.content = arguments.content>
			
			<!--- initialize javascript --->
			<cfset local.script = "<script type='text/javascript'>window.#request.jsMails#=window.#request.jsMails#||{};window.#request.jsMultiplicators#=window.#request.jsMultiplicators#||{};">

			<!--- initialize regular expressions to find email addresses --->
			<cfset local.mailRegEx = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}">

			<!--- search for emails in "foundmails" and group them into "groupedmails"--->
			<cfset local.foundMails = ReMatchNoCase(local.mailRegEx, local.content)>
			<cfset local.groupedMails = {}>
			<cfloop array="#local.foundMails#" index="local.foundMail">
				<cfset local.foundMailExists = false>
				<cfloop collection="#local.groupedMails#" item="local.checkMail">
					<cfif local.foundMail EQ local.groupedMails[local.checkMail]>
						<cfset local.foundMailExists = true>
						<cfbreak>
					</cfif>
				</cfloop>
				<!--- if the mail doesn't exist in "groupedmails" yet, we'll add it --->
				<cfif NOT local.foundMailExists AND NOT listFindNoCase('png,jpg,jpeg,gif', listLast(local.foundMail, '.'))>
					<cfset local.groupedMails[replace(createUUID(), "-", "", "ALL")] = local.foundMail>
				</cfif>
			</cfloop>

			<!--- replace all "mailto:" strings with "urn:<request.jsScheme>:" for source code obfuscation --->
			<cfset local.content = replaceNoCase(local.content, "mailto:", "urn:#request.jsScheme#:", "ALL")>

			<!--- write all mail adresses to javascript (using encryptmailaddress(mail, multiplicator)) --->
			<!--- replace all email adresses with {uuid} in the html --->
			<cfloop collection="#local.groupedMails#" item="local.ident">
				<cfset local.i = randRange(334,781)>
				<cfset local.script = local.script & "window.#request.jsMails#['#local.ident#']='#encryptMailAddress(local.groupedMails[local.ident], local.i)#';">
				<cfset local.script = local.script & "window.#request.jsMultiplicators#['#local.ident#']=#local.i#;">
				<cfset local.content = replaceNoCase(local.content, local.groupedMails[local.ident], "{#request.jsIdentifier#}{#local.ident#}", "ALL")>
			</cfloop>

			<cfcatch type="any">
				<!--- if any error occures, we'll return the original content without modifications --->
				<cfreturn arguments.content>
			</cfcatch>
		</cftry>
		
		<!--- write script to html head --->
		<cfhtmlhead text="#local.script#</script>">

		<!--- return manipulated content --->
		<cfreturn local.content>
	</cffunction>


	<cffunction name="encryptMailAddress" returntype="string">
		<cfargument name="mail" type="string" default="bad@mail.ch">
		<cfargument name="multiplicator" type="numeric" required="true">

		<!--- initialize mail --->
		<cfset local.mail = "">

		<!--- convert mail to array of chars --->
		<cfset arguments.mail = listToArray(arguments.mail, "")>

		<!--- Encode Mail to a List of Decimal-Values for the ASCII-Table and multiply the Value with [arguments.multiplicator] for Obfuscation --->
		<cfloop from="1" to="#arrayLen(arguments.mail)#" index="i">
			<cfset local.mail = listAppend(local.mail, ASC(arguments.mail[i])*arguments.multiplicator)>
		</cfloop>

		<!--- convert string into base64 --->
		<cfreturn toBase64(local.mail)>
	</cffunction>


	<cffunction name="writeJavaScript" returntype="string">
		<!--- write css and script to the html head --->
		<cfset local.i = randRange(334,781)>
		<cfsavecontent variable="mmCSSHead">
			<cfoutput>
				<style type="text/css">a[href*='#request.jsScheme#:']{font-size:1px;opacity:0;}</style>
				<script type="text/javascript">
					<!--- use coldfusion comments here. js comments can be read in the source code --->
					<!--- all function an variable names are replaced with a random string following this pattern: "m<uui>o".
								so instead of using mailobfuscatorinit('body'), we'll use a random value i.e. m42e42360a99099f286e5da826cf9fc18o('body') --->
					(function($) {/*[EMO]BOS*/
						var key = 'M#replace(createuuid(), '-', '', 'ALL')#O';<!--- this is for disconcertment only --->
						var salt = 'M#replace(createuuid(), '-', '', 'ALL')#O';<!--- this is for disconcertment only --->
						<!--- Object: 			jsBase64 --->
						<!--- Information: 	https://gist.github.com/ncerminara/11257943 --->
						var #request.jsBase64#={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=#request.jsBase64#._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=#request.jsBase64#._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
						<!--- Function: 		request.jsInit --->
						<!--- Arguments: 		s = Selector; jquery selector, e.g. 'body' or '.content-wrapper' --->
						function #request.jsInit#(s) {
							window.#request.jsMails#=window.#request.jsMails#||{};window.#request.jsMultiplicators#=window.#request.jsMultiplicators#||{};
							setTimeout(function() {
								<!--- get all nodes, that contain the value of "jsidentifier", but ONLY text nodes (noteType==3) --->
								var $e=$(s).find(":not(iframe, script)").contents().filter(function() {
									if (this.nodeType == 3) {return $(this).text().indexOf('{#request.jsIdentifier#}')>(-1);} else {return false;}
								});
								$e=$e.parent();
								<!--- replace html and href for each found element --->
								$.each($e, function(i,v) {
									var $v=$(v);
									$v.html(function() {
										return #request.jsSetContent#($v.html());
									}).attr('href', function() {
										return #request.jsSetContent#($v.attr('href'));
									});
								});
							}, 300);<!--- setTimeout is to keep away a bit more bots --->
						}
						<!--- Function: 		request.jsSetContent --->
						<!--- Arguments: 		h = Html; string value --->
						function #request.jsSetContent#(h) {
							var h=h, t='';
							<!--- create the string "mailto:" and save it into variable "t" (for "to") --->
							<!--- 109,97,105,108,116,111 are the ASCII values for "mailto"... for obfuscation we'll multiply them with a random integer --->
							for (var i=0; i<[#109*local.i#,#97*local.i#,#105*local.i#,#108*local.i#,#116*local.i#,#111*local.i#].length; i++) {
								t=t+'%'+(parseInt([#109*local.i#,#97*local.i#,#105*local.i#,#108*local.i#,#116*local.i#,#111*local.i#][i])/#local.i#).toString(16);
							};
							<!--- remove the request.jsIdentifier that is used to identify email containing elements --->
							h=h.replace(new RegExp('{#request.jsIdentifier#}', 'g'), '');
							<!--- replace the "urn:<request.jsScheme>:" with "mailto:" --->
							h=h.replace(new RegExp('urn:#request.jsScheme#:', 'g'), decodeURI(t+':'));
							<!--- replace all mail-uuids with the original mail address again --->
							for (var m in window.#request.jsMails#) {
								if (window.#request.jsMails#.hasOwnProperty(m)) {
									h=h.replace(new RegExp('{'+m+'}', 'g'), #request.jsDecrypt#(window.#request.jsMails#[m],window.#request.jsMultiplicators#[m]));
								}
							}
							return h;
						}
						<!--- Function: 		request.jsDecrypt --->
						<!--- Arguments: 		m = Mail; base64 encrypted string that contains a list of decimals (ASCII values for each letter, multiplied with the corresponding multiplicator) --->
						<!--- 							d = Decimal; from "request.jsMultiplicators" --->
						function #request.jsDecrypt#(m,d) {
							<!--- decode the base64 string, split it into an array of decimals --->
							var m=#request.jsBase64#.decode(m).split(','), e='';
							<!--- divide each decimal with the corresponding multiplicator to get the original ASCII value and get the corresponding ASCII character (e.g. "%40" for "@") --->
							for (var i = 0; i < m.length; i++) {
								e=e+'%'+(parseInt(m[i])/parseInt(d)).toString(16);
							}
							<!--- decode the url encoded string into a normal string --->
							return decodeURIComponent(e);
						}
						<!--- onload method, invoke request.jsInit --->
						$(function(){#request.jsInit#('body');});
					})(jQuery);
				</script>
			</cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#trim(mmCSSHead)#">
	</cffunction>


</cfcomponent>