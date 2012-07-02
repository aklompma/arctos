<cfinclude template="/includes/_header.cfm">
<cfoutput>
        <cfquery name="findIDs" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
                select 
                        media.media_id,
                        media.media_uri,
                        media.mime_type,
                        media.media_type,
                        media.preview_uri,
                        ctmedia_license.uri,
                        ctmedia_license.display
                from 
                        media,
                        ctmedia_license
                where 
                        media.media_license_id=ctmedia_license.media_license_id (+) and 
                        media.media_id = #media_id#
        </cfquery>
        <cfif isdefined("session.roles") and listcontainsnocase(session.roles,"manage_media")>
            <cfset h="/media.cfm?action=newMedia">
                <cfif isdefined("url.relationship__1") and isdefined("url.related_primary_key__1")>
                        <cfif url.relationship__1 is "cataloged_item">
                                <cfset h=h & '&collection_object_id=#url.related_primary_key__1#'>
                                ( find Media and pick an item to link to existing Media )
                                <br>
                        </cfif>
                </cfif>
                <a href="#h#">[ Create media ]</a>
        </cfif>
        

        <cfquery name="labels_raw"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
                select
                        media_label,
                        label_value,
                        agent_name
                from
                        media_labels,
                        preferred_agent_name
                where
                        media_labels.assigned_by_agent_id=preferred_agent_name.agent_id (+) and
                        media_id=#media_id#
        </cfquery>
        <cfquery name="labels" dbtype="query">
                select media_label,label_value from labels_raw where media_label != 'description'
        </cfquery>
        <cfquery name="desc" dbtype="query">
                select label_value from labels_raw where media_label='description'
        </cfquery>
        <cfset alt="#findIDs.media_uri#">
        <cfif desc.recordcount is 1 and findIDs.recordcount is 1>
                        <cfset title = desc.label_value>
                        <cfset alt=desc.label_value>
        </cfif>
                                <cfset mp=getMediaPreview(findIDs.preview_uri,findIDs.media_type)>

        <table>
                <tr>
                        <td align="middle">
                                <a href="#findIDs.media_uri#" target="_blank"><img src="#mp#" alt="#alt#" style="max-width:250px;max-height:250px;"></a>
                                <br><span style='font-size:small'>#findIDs.media_type#&nbsp;(#findIDs.mime_type#)</span>
                                <cfif len(findIDs.display) gt 0>
                                        <br><span style='font-size:small'>License: <a href="#findIDs.uri#" target="_blank" class="external">#findIDs.display#</a></span>
                                <cfelse>
                                        <br><span style='font-size:small'>unlicensed</span>
                                </cfif>
                        </td>
                        <cfquery name="coord"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
                                select coordinates from media_flat where coordinates is not null and media_id=#media_id#
                        </cfquery>
                        <td>
							<cfif coord.recordcount is 1>
								<cfinvoke component="component.functions" method="getMap" returnvariable="contents">
									<cfinvokeargument name="media_id" value="#media_id#">
									<cfinvokeargument name="size" value="100x100">
								</cfinvoke>
								<!----
									<cfset iu="http://maps.google.com/maps/api/staticmap?center=#coord.coordinates#">
                                    <cfset iu=iu & "&markers=color:red|size:tiny|#coord.coordinates#&sensor=false&size=100x100&zoom=2">
                                    <cfset iu=iu & "&maptype=roadmap">
                                    <a href="http://maps.google.com/maps?q=#coord.coordinates#" target="_blank"><img src="#iu#" alt="Google Map"></a>
									--->
									#contents#
                                </cfif>
                        </td>
                        <td>
                                <cfif len(desc.label_value) gt 0>
                                        <ul><li>#desc.label_value#</li></ul>
                                </cfif>
                                <cfif labels.recordcount gt 0>
                                        <ul>
                                            <cfloop query="labels">
                                                    <li>
                                                            #media_label#: #label_value#
                                                    </li>
                                            </cfloop>
                                        </ul>
                                </cfif>
                                <cfset mrel=getMediaRelations(#findIDs.media_id#)>
                                <cfif mrel.recordcount gt 0>
                                        <ul>
                                        <cfloop query="mrel">
                                                <li>#media_relationship#  
                                    <cfif len(#link#) gt 0>
                                        <a href="#link#" target="_blank">#summary#</a>
                                    <cfelse>
                                                                #summary#
                                                        </cfif>
                                </li>
                                        </cfloop>
                                        </ul>
                                </cfif>
                        </td>
                </tr>
                <tr>
                        <td colspan="3" align="center">
                                <cfquery name="tag" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
                                        select count(*) n from tag where media_id=#media_id#
                                </cfquery>
                                <cfif findIDs.media_type is "multi-page document">
                                        <a href="/document.cfm?media_id=#findIDs.media_id#">[ view as document ]</a>
                                </cfif>
                                <cfif isdefined("session.roles") and listcontainsnocase(session.roles,"manage_media")>
                                <a href="/media.cfm?action=edit&media_id=#media_id#">[ edit media ]</a>
                                <a href="/TAG.cfm?media_id=#media_id#">[ add or edit TAGs ]</a>
                            </cfif>
                            <cfif tag.n gt 0>
                                        <a href="/showTAG.cfm?media_id=#media_id#">[ View #tag.n# TAGs ]</a>
                                </cfif>
                        </td>
                </tr>
                        <cfquery name="relM" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
                                select 
                                        media.media_id, 
                                        media.media_type, 
                                        media.mime_type, 
                                        media.preview_uri, 
                                        media.media_uri 
                                from 
                                        media, 
                                        media_relations 
                                where 
                                        media.media_id=media_relations.related_primary_key and
                                        media_relationship like '% media' 
                                        and media_relations.media_id =#media_id#
                                        and media.media_id != #media_id#
                                UNION
                                select media.media_id, media.media_type,
                                        media.mime_type, media.preview_uri, media.media_uri 
                                from media, media_relations 
                                where 
                                        media.media_id=media_relations.media_id and
                                        media_relationship like '% media' and 
                                        media_relations.related_primary_key=#media_id#
                                         and media.media_id != #media_id#
                        </cfquery>
                <tr>
                        <td colspan="3">
                                <cfif relM.recordcount gt 0>
                                        <br>Related Media
                                        <div class="thumbs">
                                                <div class="thumb_spcr">&nbsp;</div>
                                                <cfloop query="relM">
                                                        <cfset puri=getMediaPreview(preview_uri,media_type)>
                                        <cfquery name="labels"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
                                                                select
                                                                        media_label,
                                                                        label_value
                                                                from
                                                                        media_labels
                                                                where
                                                                        media_id=#media_id#
                                                        </cfquery>
                                                        <cfquery name="desc" dbtype="query">
                                                                select label_value from labels where media_label='description'
                                                        </cfquery>
                                                        <cfset alt="Media Preview Image">
                                                        <cfif desc.recordcount is 1>
                                                                <cfset alt=desc.label_value>
                                                        </cfif>
                                       <div class="one_thumb">
                                               <a href="#media_uri#" target="_blank"><img src="#getMediaPreview(preview_uri,media_type)#" alt="#alt#" class="theThumb"></a>
                                                <p>
                                                                        #media_type# (#mime_type#)
                                                        <br><a href="/media/#media_id#">Media Details</a>
                                                                        <br>#alt#
                                                                </p>
                                                        </div>
                                                </cfloop>
                                                <div class="thumb_spcr">&nbsp;</div>
                                        </div>
                                </cfif>
                        </td>
                </tr>
        </table>
</cfoutput>
<cfinclude template="/includes/_footer.cfm">