<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="addlist">
        <form name="addlist" action="/panel/addlist" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="value" class="col-sm-4 control-label">Название элемента</label>
                <div class="col-sm-8">
                    <input type="text" name="value" id="value" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="parent" class="col-sm-4 control-label">Родитель</label>
                <div class="col-sm-8">
                    <select name="parent" id="parent" class="form-control input-sm">
                        <xsl:for-each select="//LIST">
                            <option value="{@id}"><xsl:value-of select="@value"/></option>
                        </xsl:for-each>
                    </select>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="addlist.submit(); window.reload()">Добавить список</a>
            <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
        </div>
    </xsl:template>
</xsl:stylesheet>