<cfcomponent>


	<cfset variables.name = "mangoNewsMe">
	<cfset variables.id = "com.cftips.mangoNewsMe">
	<cfset variables.package = "com/cftips/mangoNewsMe"/>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset var blogid = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogid & "/" & variables.package />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.moderate = variables.preferencesManager.get(path,"enabled","0") />
			
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "mangoNewsMe plugin activated. <br />
				   Check the admin Overview section to view the Mango Blog news pod." />
	</cffunction>
	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "shareMe plugin de-activated"/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var eventName = arguments.event.name />
			<cfset var pod = "" />
			
			
			<!--- admin dashboard event --->
			<cfif eventName EQ "dashboardPod">		
				<!--- add a pod with Mango Blog News --->
				<cfset feedurl = "http://www.mangoblog.org/feeds/rss.cfm">
				<cffeed action="read" source="#feedurl#" properties="meta" query="entries">
                
				<cfsavecontent variable="content">
				<cfoutput>
                    <cfloop query="entries" startrow="1" endrow="5">
                    <p>
                    <b><a href="#rsslink#">#title#</a></b> <i>#LSDateFormat(CreateODBCDate(publisheddate), "mmmm d, yyyy")#</i><br /><br />
                    <strong>Category: #CATEGORYLABEL#</strong><br />
                    <br />
                    #Left(REReplaceNoCase(content,"<[^>]*>","","ALL"), 75)#>[...]
                    </p>
                    </cfloop>
				</cfoutput></cfsavecontent>			
				
				<cfset pod = structnew() />
				<cfset pod.title = "Mango Blog News" />
				<cfset pod.content = content />
				<cfset arguments.event.addPod(pod)>

			
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>