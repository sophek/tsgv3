<cfcomponent extends="org.cfcunit.framework.TestCase">

	<cffunction name="testComponent" output="false">
		<cfscript>
			var p = createObject("component","pagination").init();
			var data = queryNew("a,b,c");
			queryAddRow(data,123);

			p.setqueryToPaginate(data);
			assertEqualsQuery(data, p.getQuery());

			p.setItemsPerPage(19);
			assertEqualsNumber(19, p.getMaxRows());

			assertEqualsNumber(7, p.getTotalNumberOfPages());
			assertEqualsNumber(1, p.getCurrentPage());

		</cfscript>
	</cffunction>

</cfcomponent>