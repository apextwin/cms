<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="addgroup">
        <form name="addgroup" action="/panel/addgroup" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="groupname" class="col-sm-4 control-label">Имя группы</label>
                <div class="col-sm-8">
                    <input type="text" name="groupname" id="groupname" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="url" class="col-sm-4 control-label">Url</label>
                <div class="col-sm-8">
                    <input type="text" name="url" id="url" class="form-control input-sm" value="/"/>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="addgroup.submit(); window.reload()">Добавить</a>
            <a href="/panel/groups" class="btn btn-default" data-dismiss="modal">Отмена</a>
        </div>
    </xsl:template>
    <xsl:template name="editgroup">
        <xsl:variable name="gid" select="//PARAM[@name='gid']"/>
        <form name="editgroup" action="/panel/editgroup" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="groupname" class="col-sm-4 control-label">Имя группы</label>
                <div class="col-sm-8">
                    <input type="text" name="groupname" id="groupname" class="form-control input-sm" value="{//GROUPDATA[@gid=$gid]}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="url" class="col-sm-4 control-label">Url</label>
                <div class="col-sm-8">
                    <input type="text" name="url" id="url" class="form-control input-sm" value="{//GROUPDATA[@gid=$gid]/@url}"/>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="editgroup.submit(); window.reload()">Сохранить</a>
            <a href="/panel/groups" class="btn btn-default" data-dismiss="modal">Отмена</a>
        </div>
    </xsl:template>
    <xsl:template name="editusergroup">
        <xsl:variable name="login" select="//PARAM[@name='userlogin']"/>
        <form name="editusergroup" method="post">
            <input type="hidden" name="userlogin" value="{$login}"/>
            <xsl:for-each select="/DOCUMENT/GROUPS">
                <xsl:apply-templates />
            </xsl:for-each>
            <input type="submit"/>
        </form>
    </xsl:template>
    <xsl:template match="GROUPDATA">
        <div class="group">
            <input type="checkbox" name="group[]" value="{@gid}">
                <xsl:if test="@selected = '1'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
            </input>
            <xsl:value-of select="."/>(gid =<xsl:value-of select="@gid"/>)
        </div>
    </xsl:template>
</xsl:stylesheet>