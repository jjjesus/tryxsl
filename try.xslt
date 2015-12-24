<?xml version="1.0" encoding="UTF-8"?>
<!--
IMPORTANT

Notice that the default namespace is set to http://uas-c2-initiaive.mil

If you don't do that, the XPATH matches won't work

Use exclude-result-prefixes to prevent namespaces in the XML element output

 -->


<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	ns2:classification="U"
	ns2:ownerProducer="USA"
	xpath-default-namespace="http://uas-c2-initiative.mil/"
	exclude-result-prefixes="xsl xs fn"
	xmlns="http://uas-c2-initiative.mil/" 
	xmlns:ns2="urn:us:gov:ic:ism">

	<!-- Boilerplate for output format -->
	<xsl:output method="xml"
			version="1.0"
			encoding="UTF-8"
			indent="yes"/>

	<!-- Current Time -->
	<xsl:variable name="vCurrentTime"
                select="fn:current-dateTime()" />
                
	<!-- The minimum of the AllocateTask Begin Time -->
	<xsl:variable name="min_allocated_task_begin_time" as="xs:dateTime">
	  <xsl:value-of select="min(//MissionPlan/MessageData/Details/AllocatedTask[*]/RequiredExecutionTime/Begin/xs:dateTime(.))"/>
	</xsl:variable>

	<!-- Delta first task Begin time to now -->
	<xsl:variable name="delta_first_task_to_now" as="xs:dayTimeDuration">
	  <xsl:value-of select="xs:dayTimeDuration($vCurrentTime - $min_allocated_task_begin_time)"/>
	</xsl:variable>

	<!-- The identify template, copies everything, with exceptions below -->
	<xsl:template match="@*|node()">
	  <xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	  </xsl:copy>
	</xsl:template>

	<!-- Exception to the default copy rule, substitute Begin time -->
	<xsl:template match="MissionPlan/MessageData/Details/AllocatedTask[*]/RequiredExecutionTime/Begin">
		<xsl:variable name="begin-time" select="." as="xs:dateTime"/>
		<xsl:variable name="updated-time" select="xs:dateTime($begin-time + $delta_first_task_to_now)" />
		<xsl:for-each select="$begin-time">
			<Begin>
				<xsl:value-of select="format-dateTime($updated-time, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f001]Z' )" />
			</Begin>
		</xsl:for-each>
  </xsl:template>

	<!-- Exception to the default copy rule, substitute End time -->
	<xsl:template match="MissionPlan/MessageData/Details/AllocatedTask[*]/RequiredExecutionTime/End">
		<xsl:variable name="end-time" select="." as="xs:dateTime"/>
		<xsl:variable name="updated-time" select="xs:dateTime($end-time + $delta_first_task_to_now)" />
		<xsl:for-each select="$end-time">
			<End>
				<xsl:value-of select="format-dateTime($updated-time, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f001]Z' )" />
			</End>
		</xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
