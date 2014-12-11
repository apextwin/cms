<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
<xsl:template name="config">
    <h4>Конфигурация "<xsl:value-of select="//MODULE/@title"/>"</h4>
	<table cellspacing="2" cellpadding="0" class="table table-striped table-hover">
    <thead>
    	<tr>
    		<th width="30%">Переменная</th>
            <th width="40%">Значение</th>
    		<th></th>
    	</tr>
    </thead>
    <tbody>
        <xsl:for-each select="//MODULE/VARS/VAR">
        <tr>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:value-of select="."/></td>
            <td>        
                <a href="#" class="btn btn-success btn-xs" data-toggle="modal" data-target="#editval{@name}">
                    <i class="fa fa-edit"/>&#xA0;Редактировать
                </a>&#xA0;
                <div class="modal fade" id="editval{@name}" tabindex="-1" role="dialog" aria-labelledby="addanswerLabelred" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><i class="fa fa-times"/></button>
                                <h4 class="modal-title" id="addanswerLabelred">Редактирование</h4>
                            </div>
                            <div class="modal-body">
                                <form method="post" name="editval" action="/panel/module?module={//MODULE/@include}&amp;action=editval" class="form form-horizontal">
                                    <div class="form-group">
                                        <label for="key" class="col-sm-4 control-label">
                                            Переменная
                                        </label>
                                        <div class="col-sm-8">
                                            <input type="text" name="key" id="key" class="form-control input-sm" value="{@name}"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="value" class="col-sm-4 control-label">
                                            Значение
                                        </label>
                                        <div class="col-sm-8">
                                            <input type="text" name="value" id="value" class="form-control input-sm" value="{.}"/>    
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" onclick="editval.submit()">Сохранить</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="/panel/module?module={//MODULE/@include}&amp;action=delval&amp;key={@name}" class="btn btn-danger btn-xs">
                    <i class="fa fa-times"/>&#xA0;Удалить
                </a>
            </td>
        </tr>
        </xsl:for-each>
    </tbody>
	</table>
    <a href="#" class="btn btn-primary" data-toggle="modal" data-target="#addval">
        Добавить переменную
    </a>
    <div class="modal fade" id="addval" tabindex="-1" role="dialog" aria-labelledby="addanswerLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><i class="fa fa-times"/></button>
                    <h4 class="modal-title" id="addanswerLabel"><xsl:value-of select="//MODULE/@title"/></h4>
                </div>
                <div class="modal-body">
                    <form method="post" name="addval" action="/panel/module?module={//MODULE/@include}&amp;action=addval" class="form form-horizontal">
                        <div class="form-group">
                            <label for="key" class="col-sm-4 control-label">
                                Переменная
                            </label>
                            <div class="col-sm-8">
                                <input type="text" name="key" id="key" class="form-control input-sm"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="value" class="col-sm-4 control-label">
                                Значение
                            </label>
                            <div class="col-sm-8">
                                <input type="text" name="value" id="value" class="form-control input-sm"/>    
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="addval.submit()">Добавить переменную</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
                </div>
            </div>
        </div>
    </div>    
</xsl:template>
</xsl:stylesheet>