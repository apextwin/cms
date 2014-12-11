<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="addrealm">
        <form name="addrealm" action="/panel/addrealm" method="post" enctype="multipart/form-data" role="form" class="form-horizontal">
            <xsl:variable name="parent" select="//PARAM[@name='parent']"/>
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Имя раздела</label>
                <div class="col-sm-8">
                    <xsl:choose>
                        <xsl:when test="$parent != '1000'">
                            <input type="text" id="name" name="name" value="{//SECTION[@realm=$parent]/@name}/" class="form-control input-sm"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <input type="text" id="name" name="name" class="form-control input-sm"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
            <div class="form-group">
                <label for="title" class="col-sm-4 control-label">Заголовок</label>
                <div class="col-sm-8">
                    <input type="text" name="title" id="title" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="weight" class="col-sm-4 control-label">Вес</label>
                <div class="col-sm-8">
                    <input type="text" name="weight" id="weight" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="realmpagesize" class="col-sm-4 control-label">Размер</label>
                <div class="col-sm-8">
                    <input type="text" name="realmpagesize" id="realmpagesize" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="parent" class="col-sm-4 control-label">Родитель</label>
                <div class="col-sm-8">
                    <select name="parent" id="parent" onchange="ChangeParent(form)" class="form-control input-sm">
                        <option value="0">
                            -none-
                        </option>
                        <xsl:for-each select="//SECTION">
                            <option value="{@realm}">
                                <xsl:if test="@realm = $parent">
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
                <label for="template" class="col-sm-4 control-label">Шаблон страницы</label>
                <div class="col-sm-8">
                    <select name="template" id="template" class="form-control input-sm">
                        <option value="template.xsl">
                            Русский
                        </option>
                        <option value="template_kz.xsl">
                            Қазақша
                        </option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="image" class="col-sm-4 control-label">Изображение</label>
                <div class="col-sm-8">
                    <input type="file" name="image" id="image" class="input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="descr" class="col-sm-4 control-label">Описание</label>
                <div class="col-sm-8">
                    <textarea name="descr" id="descr" class="form-control input-sm"></textarea>
                </div>
            </div>

            <div class="form-group">
                <label for="metadescr" class="col-sm-4 control-label">META Description</label>
                <div class="col-sm-8">
                    <textarea name="metadescr" id="metadescr" class="form-control input-sm"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label for="metakey" class="col-sm-4 control-label">META Keywords</label>
                <div class="col-sm-8">
                    <input type="text" name="metakey" id="metakey" class="form-control input-sm"/>
                </div>
            </div>

        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="addrealm.submit()">Добавить раздел</a>
            <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
        </div>
    </xsl:template>
    <xsl:template name="editrealm">
        <form name="editrealm" action="/panel/editrealm" method="post" enctype="multipart/form-data" role="form" class="form-horizontal">
            <xsl:variable name="realm" select="//PARAM[@name='realm']"/>
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Имя раздела</label>
                <div class="col-sm-8">
                    <input type="text" id="name" name="name" class="form-control input-sm" value="{//SECTION[@realm=$realm]/@name}"/>
                    <input type="hidden" name="realm" value="{$realm}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="title" class="col-sm-4 control-label">Заголовок</label>
                <div class="col-sm-8">
                    <input type="text" name="title" id="title" class="form-control input-sm" value="{//SECTION[@realm=$realm]/@title}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="weight" class="col-sm-4 control-label">Вес</label>
                <div class="col-sm-8">
                    <input type="text" name="weight" id="weight" class="form-control input-sm" value="{//SECTION[@realm=$realm]/@weight}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="realmpagesize" class="col-sm-4 control-label">Размер</label>
                <div class="col-sm-8">
                    <input type="text" name="realmpagesize" id="realmpagesize" class="form-control input-sm" value="{//SECTION[@realm=$realm]/@realmpagesize}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="parent" class="col-sm-4 control-label">Родитель</label>
                <div class="col-sm-8">
                    <input type="hidden" name="old_parent" value="{//SECTION[@realm=$realm]/@parent}"/>
                    <select name="parent" onchange="ChangeParent(form)" class="form-control input-sm">
                        <option value="0">
                            -none-
                        </option>
                        <xsl:for-each select="//SECTION[@realm != $realm]">
                            <option value="{@realm}">
                                <xsl:if test="@realm = //SECTION[@realm=$realm]/@parent">
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
                <label for="template" class="col-sm-4 control-label">Шаблон страницы</label>
                <div class="col-sm-8">
                    <select name="template" id="template" class="form-control input-sm">
                        <option value="template.xsl">
                            <xsl:if test="//SECTION[@realm=$realm]/@template = 'template.xsl'">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            Русский
                        </option>
                        <option value="template_kz.xsl">
                            <xsl:if test="//SECTION[@realm=$realm]/@template = 'template_kz.xsl'">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            Қазақша
                        </option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="image" class="col-sm-4 control-label">Изображение</label>
                <div class="col-sm-8">
                    <input type="hidden" name="old_image" value="{//SECTION[@realm=$realm]/@image}"/>
                    <input type="file" name="image" id="image" class="input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="image" class="col-sm-4 control-label">Текущее изображение</label>
                <div class="col-sm-8">
                    <xsl:if test="//SECTION[@realm=$realm]/@image != ''">
                        <img src="/{//SECTION[@realm=$realm]/@image}"/>
                    </xsl:if>
                </div>
            </div>
            <div class="form-group">
                <label for="descr" class="col-sm-4 control-label">Описание</label>
                <div class="col-sm-8">
                    <textarea name="descr" id="descr" class="form-control input-sm"><xsl:value-of select="//REALM_DESCR"/></textarea>
                </div>
            </div>

            <div class="form-group">
                <label for="metadescr" class="col-sm-4 control-label">META Description</label>
                <div class="col-sm-8">
                    <textarea name="metadescr" id="metadescr" class="form-control input-sm"><xsl:value-of select="//REALM_METADESCR"/></textarea>
                </div>
            </div>
            <div class="form-group">
                <label for="metakey" class="col-sm-4 control-label">META Keywords</label>
                <div class="col-sm-8">
                    <input type="text" name="metakey" id="metakey" class="form-control input-sm" value="{//REALM_METAKEY}"/>
                </div>
            </div>

        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="editrealm.submit()">Сохранить изменения</a>
            <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
        </div>
    </xsl:template>
</xsl:stylesheet>