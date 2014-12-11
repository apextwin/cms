<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="insertinclude">
        <form name="insertinclude" action="/panel/insertinclude" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="title" class="col-sm-4 control-label">Название</label>
                <div class="col-sm-8">
                    <input type="text" name="title" id="title" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="module" class="col-sm-4 control-label">Модуль</label>
                <div class="col-sm-8">
                    <input type="text" name="module" id="module" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="class" class="col-sm-4 control-label">Класс</label>
                <div class="col-sm-8">
                    <input type="text" name="class" id="class" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="xsl" class="col-sm-4 control-label">Шаблон</label>
                <div class="col-sm-8">
                    <input type="text" name="xsl" id="xsl" class="form-control input-sm"/>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="insertinclude.submit(); window.reload()">Сохранить</a>
            <a href="/panel/include" class="btn btn-default" data-dismiss="modal">Отмена</a>
        </div>
    </xsl:template>
    <xsl:template name="editinclude">
        <xsl:variable name="include" select="//PARAM[@name='include']"/>
        <form name="editinclude" action="/panel/editinclude" method="post">
            <table>
                <tr>
                    <td>Название</td>
                    <td>
                        <input type="hidden" name="include" value="{$include}"/>
                        <input type="text" name="title" value="{//INCLUDE[@include=$include]/@title}"/>
                    </td>
                </tr>
                <tr>
                    <td>Модуль</td>
                    <td><xsl:value-of select="//INCLUDE[@include=$include]/@module"/></td>
                </tr>
                <tr>
                    <td>Класс</td>
                    <td><xsl:value-of select="//INCLUDE[@include=$include]/@class"/></td>
                </tr>
                <tr>
                    <td>Шаблон</td>
                    <td><xsl:value-of select="//INCLUDE[@include=$include]/@xsl"/></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Изменить"/>
                    </td>
                </tr>
            </table>
        </form>
        <form name="editinclude" action="/panel/deleteinclude" method="post">
            <table class="table">
                <thead>
                    <tr>
                        <td><input type="checkbox" name="all" onclick="checkall(this.form.elements,this)"/></td>
                        <td>Раздел</td>
                        <td>Режим</td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="//INCLUDES/REALMS/REALM">
                        <tr>
                            <td><input type="checkbox" name="realm[]" value="{@realm}"/></td>
                            <td><a href="/panel?parent={@realm}"><xsl:value-of select="@name"/></a></td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="@mode = 0">
                                        Только к текущему
                                    </xsl:when>
                                    <xsl:when test="@mode = 1">
                                        К текущему и всем потомкам
                                    </xsl:when>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
            <input type="hidden" name="includerealm" value="{$include}"/>
            <input type="submit" value="Удалить выделенные разделы от модуля"/>
        </form>
        <form name="editinclude" action="/panel/editinclude" method="post">
            <table>
                <tr>
                    <td>
                        Добавить модуль к разделу:
                        <input type="hidden" name="include" value="{$include}"/>
                    </td>
                    <td>
                        <input type="hidden" name="addrealminc" value="1"/>
                        <select name="realm">
                            <xsl:for-each select="//SECTION">
                                <option value="{@realm}"><xsl:value-of select="@name"/></option>
                            </xsl:for-each>
                        </select>
                    </td>
                    <td>Режим:
                    </td>
                    <td>
                        <select name="mode">
                            <option value="0">Только к текущему</option>
                            <option value="1">К текущему и всем потомкам</option>
                        </select>
                    </td>
                    <td>
                        <input type="submit" value="Добавить"/>
                    </td>
                </tr>
            </table>
        </form>
    </xsl:template>
</xsl:stylesheet>