<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="addnode">
        <form name="addnode" action="/panel/addnode" method="post" enctype="multipart/form-data" role="form" class="form form-horizontal">
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Имя записи</label>
                <div class="col-sm-8">
                    <input type="text" name="name" id="name" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="classr" class="col-sm-4 control-label">Тип</label>
                <div class="col-sm-8">
                    <xsl:variable name="datatype" select="//PARAM[@name='datatype']"/>
                    <input type="hidden" name="class"  value="{//PARAM[@name='datatype']}"/>
                    <input type="text" name="classr" id="classr" class="form-control input-sm" disabled="1" value="{//DATATYPE[@name=$datatype]/@caption}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="disabled" class="col-sm-4 control-label">Скрытый?</label>
                <div class="col-sm-8">
                    <input type="checkbox" name="disabled" id="disabled" value="1" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="realm" class="col-sm-4 control-label">Раздел</label>
                <div class="col-sm-8">
                    <xsl:variable name="realm" id="realm" select="//PARAM[@name='parent']"/>
                    <select name="realm" class="field">
                        <option value="0">Без раздела</option>
                        <xsl:for-each select="//SECTION">
                            <option value="{@realm}">
                                <xsl:if test="@realm = $realm">
                                    <xsl:attribute name="selected">
                                        selected
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="@name"/>
                            </option>
                        </xsl:for-each>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Выделить до</label>
                <div class="col-sm-8">
                    <input type="text" name="highlight" id="datepicker" class="form-control input-sm"/>
                </div>
            </div>
            <xsl:variable name="datatype" select="//PARAM[@name='datatype']"/>
            <xsl:apply-templates select="/DOCUMENT/DATATYPES/DATATYPE[@name=$datatype]"/>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="submit_form('addnode')">Добавить запись</a>
            <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
        </div>
    </xsl:template>
    <xsl:template name="editnode">
        <xsl:for-each select="//NODE">
            <form name="editnode" action="/panel/editnode" method="post" enctype="multipart/form-data" role="form" class="form form-horizontal">
                <div class="form-group">
                    <label for="name" class="col-sm-4 control-label">Имя записи</label>
                    <div class="col-sm-8">
                        <input type="text" name="name" id="name" class="form-control input-sm" value="{NAME}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="classr" class="col-sm-4 control-label">Тип</label>
                    <div class="col-sm-8">
                        <xsl:variable name="datatype" select="@class"/>
                        <input type="hidden" name="class" value="{@class}"/>
                        <input type="hidden" name="node" value="{@node}"/>
                        <input type="hidden" name="old_realm" value="{@realm}"/>
                        <input type="text" name="classr" id="classr" class="form-control input-sm" disabled="1" value="{//DATATYPE[@name=$datatype]/@caption}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="disabled" class="col-sm-4 control-label">Скрытый?</label>
                    <div class="col-sm-8">
                        <xsl:choose>
                            <xsl:when test="@disabled = '0'">
                                <input type="checkbox" name="disabled" value="1" id="disabled" class="form-control input-sm"/>
                            </xsl:when>
                            <xsl:when test="@disabled = '1'">
                                <input type="checkbox" name="disabled" value="1" checked="checked" id="disabled" class="form-control input-sm"/>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </div>
                <div class="form-group">
                    <label for="realm" class="col-sm-4 control-label">Раздел</label>
                    <div class="col-sm-8">
                        <xsl:variable name="realm" id="realm" select="@realm"/>
                        <select name="realm" class="field">
                            <option value="0">Без раздела</option>
                            <xsl:for-each select="//SECTION">
                                <option value="{@realm}">
                                    <xsl:if test="@realm = $realm">
                                        <xsl:attribute name="selected">
                                            selected
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="@name"/>
                                </option>
                            </xsl:for-each>
                        </select>
                    </div>
                </div>
                <xsl:for-each select="//NODE/DATATYPE">
                    <div id="{@name}">
                        <xsl:apply-templates/>
                    </div>
                </xsl:for-each>
            </form>

            <xsl:if test="//ATREALMS">
                <div>
                    <xsl:for-each select="//ATREALMS/REALM">
                        <xsl:variable name="realm" select="@realm"/>
                        <xsl:value-of select="//SECTION[@realm=$realm]/@title"/>
                        <a href="/panel/editnode?atrealm={$realm}&amp;node={//PARAM[@name='node']}">удалить</a>
                    </xsl:for-each>
                </div>
            </xsl:if>

            <div class="form-group">
                <label for="realm" class="col-sm-4 control-label">Добавить раздел</label>
                <div class="col-sm-8">
                    <form name="addrealm" action="/panel/editnode" method="post">
                        <select name="atrealm" class="field">
                            <xsl:for-each select="//SECTION">
                                <option value="{@realm}">
                                    <xsl:value-of select="@name"/>
                                </option>
                            </xsl:for-each>
                        </select>
                        <input type="hidden" name="mode" value="1"/>
                        <input type="hidden" name="node" value="{//PARAM[@name='node']}"/>
                        <input type="submit"/>
                    </form>
                </div>
            </div>
            <div style="height: 40px"/>
            <div class="modal-footer">
                <a class="btn btn-info" href="/panel/editnode?upnode={@node}">Поднять в топ</a>
                <a href="#" class="btn btn-primary" onclick="submit_form('editnode')">Сохранить изменения</a>
                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="FIELD[@type='numeric']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
                <xsl:if test="@format">
                    (пример: <xsl:value-of select="@format"/>)
                </xsl:if>
            </label>
            <div class="col-sm-8">
                <input type="text" name="{../@name}[{@name}]" id="{../@name}[{@name}]" value="{DATA}" class="form-control input-sm"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='string']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
                <xsl:if test="@format">
                    (пример: <xsl:value-of select="@format"/>)
                </xsl:if>
            </label>
            <div class="col-sm-8">
                <input type="text" name="{../@name}[{@name}]" id="{../@name}[{@name}]" value="{DATA}" class="form-control input-sm"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='text']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
            </label>
            <div class="col-sm-12">
                <xsl:choose>
                    <xsl:when test="@editor = 'none'">
                        <div style="padding: 10px">
                            <textarea name="{../@name}[{@name}]" class="form-control input-sm"><xsl:value-of select="DATA/." disable-output-escaping="yes"/></textarea>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div style="padding: 10px">
                            <textarea name="{../@name}[{@name}]" id="{../@name}[{@name}]" class="editor form-control input-sm"><xsl:value-of select="DATA/." disable-output-escaping="yes"/></textarea>
                            <script>
                                CKEDITOR.replace('<xsl:value-of select="../@name"/>[<xsl:value-of select="@name"/>]',
                                {
                                    filebrowserBrowseUrl : '/elfinder/elfinder.html',
                                    height: '500px'
                                }
                                );
                            </script>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='datetime']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
                <xsl:if test="@format">
                    (пример: <xsl:value-of select="@format"/>)
                </xsl:if>
            </label>
            <div class="col-sm-8">
                <input type="text" name="{../@name}[{@name}]" id="{../@name}[{@name}]" value="{DATA}" class="form-control input-sm"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='image']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
            </label>
            <div class="col-sm-8">
                <input type="file" name="{../@name}[{@name}]" id="{../@name}[{@name}]" value="{DATA}" class="form-control input-sm"/>
                <xsl:if test="DATA != ''">
                    <div>
                        Текущее изображение:
                        <img src="{IMAGE}"/>
                        <input type="hidden" name="{../@name}[current_{@name}]" value="{DATA}"/>
                        <a>
                            <xsl:attribute name="href">
                                /panel/deletenode?node=<xsl:value-of select="//PARAM[@name='node']"/>&amp;field=<xsl:value-of select="@name"/>&amp;prefix=<xsl:for-each select="IMAGE"><xsl:value-of select="@prefix"/>;</xsl:for-each>
                            </xsl:attribute>
                            удалить
                        </a>
                    </div>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='file']">
        <div class="form-group">
            <label for="name" class="col-sm-4 control-label">
                <xsl:value-of select="@caption"/>
            </label>
            <div class="col-sm-8">
                <input type="file" name="{../@name}[{@name}]" id="{../@name}[{@name}]" value="{DATA}" class="form-control input-sm"/>
                <xsl:if test="DATA != ''">
                    <div>
                        <a href="/files/node/{//PARAM[@name='node']}/{DATA}">Текущий файл</a>
                        <input type="hidden" name="{../@name}[current_{@name}]" value="{DATA}"/>
                    </div>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='address']">
        <div class="datafield">
            <div>
                <div class="check-addr-btn">Проверить адрес</div>
                &#xA0;<input id="lat" type="text" name="{../@name}[{@name}][0]" value="{DATA[@id='0']}"/>
                &#xA0;<input id="lng" type="text" name="{../@name}[{@name}][1]" value="{DATA[@id='1']}"/>
                <div id="map_canvas" style="width: 900px; height: 500px;"></div>
            </div>
            <xsl:if test="DATA != ''">
             123
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="FIELD[@type='list']">
    <div class="form-group">
        <label for="name" class="col-sm-4 control-label">
            <xsl:value-of select="@caption"/>
        </label>
        <div class="col-sm-8">
            <xsl:variable name="root" select="@parent"/>
            <xsl:variable name="dataname" select="../@name"/>
            <xsl:variable name="name" select="@name"/>
            <xsl:variable name="parent" select="@parent"/>
            <xsl:variable name="current" select="DATA"/>
            <select id="id{$dataname}{$name}" name="{$dataname}[{$name}]">
                <option value="">...</option>
                <xsl:for-each select="//LIST[@id=$root]/LIST">
                    <option value="{@id}">
                        <xsl:if test="@id = $current">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@value"/>
                    </option>
                </xsl:for-each>
            </select>
        </div>
    </div>
</xsl:template>
</xsl:stylesheet>