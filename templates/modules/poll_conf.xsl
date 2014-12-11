<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
<xsl:template match="/DOCUMENT/MODULE/PANELXML">
    <xsl:choose>
        <xsl:when test="//PARAM[@name='poll']">
            <xsl:variable name="poll" select="//PARAM[@name='poll']"/>
            <h4>Вопрос: <xsl:value-of select="/DOCUMENT/PANELXML/POLLS/ROW[@pk=$poll]/FIELD[@name='question']"/></h4>
            <table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-hover">
                <thead>
                    <tr>
                       <td>Вариант ответа</td>
                       <td>Проголосовало</td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="//MODULE/PANELXML/ANSWERS/ROW">
                        <tr>
                        	<td><xsl:value-of select="FIELD[@name = 'title']"/></td>
                        	<td><xsl:value-of select="FIELD[@name = 'count']"/></td>
                        	<td>
                                <a href="/panel/module?module={//MODULE/@include}&amp;action=deleteanswer&amp;answer={@pk}&amp;poll={FIELD[@name = 'poll']}" class="btn btn-danger btn-xs"><i class="fa fa-times"/>&#xA0;Удалить</a>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
            <button class="btn btn-primary" data-toggle="modal" data-target="#addanswer">
                Добавить ответ
            </button>
            <div class="modal fade" id="addanswer" tabindex="-1" role="dialog" aria-labelledby="addanswerLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><i class="fa fa-times"/></button>
                            <h4 class="modal-title" id="addanswerLabel">Добавить ответ</h4>
                        </div>
                        <div class="modal-body">
                            <form method="post" name="addanswer" action="/panel/module?module={//MODULE/@include}&amp;action=addanswer" >
                                <div class="form-group">
                                    <label for="title" class="col-sm-4 control-label">
                                        Вариант ответа на вопрос
                                    </label>
                                    <div class="col-sm-8">
                                        <input type="text" name="title" id="title" class="form-control input-sm"/>
                                    </div>
                                </div>
                                <input type="hidden" name="poll" value="{$poll}"/>
                                <div style="clear: both"/>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="addanswer.submit()">Добавить вопрос</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
                        </div>
                    </div>
                </div>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <h4>Голосования</h4>
                <form method="post">
                	<input type="hidden" name="type" value="vote"/>
                	<table cellspacing="2" cellpadding="0" class="table table-striped table-hover">
                    <thead>
                    	<tr>
                    		<th align="right">#</th>
                    		<th>Заголовок</th>
                            <th>Язык</th>
                    		<th>Всего Голосов</th>
                    		<th></th>
                    	</tr>
                    </thead>
                    <tbody>
                	   <xsl:call-template name="POLLS"/>
                    </tbody>
                	</table>
                </form> 
                <button class="btn btn-primary" data-toggle="modal" data-target="#addpoll">
                    Добавить опрос
                </button>
                <div class="modal fade" id="addpoll" tabindex="-1" role="dialog" aria-labelledby="addanswerLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><i class="fa fa-times"/></button>
                                <h4 class="modal-title" id="addanswerLabel"><xsl:value-of select="//MODULE/@title"/></h4>
                            </div>
                            <div class="modal-body">
                                <form method="post" name="addpoll" action="/panel/module?module={//MODULE/@include}&amp;action=addpoll" class="form form-horizontal">
                                    <div class="form-group">
                                        <label for="question" class="col-sm-4 control-label">
                                            Вопрос голосования
                                        </label>
                                        <div class="col-sm-8">
                                            <input type="text" name="question" id="question" class="form-control input-sm"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="lang" class="col-sm-4 control-label">
                                            Язык голосования
                                        </label>
                                        <div class="col-sm-8">
                                            <select name="lang" id="lang" class="form-control input-sm">
                                                <option value="ru">русский</option>
                                                <option value="kz">казахский</option>
                                            </select>
                                        </div>
                                    </div>
                                    <input type="hidden" name="active" value="1"/>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" onclick="addpoll.submit()">Добавить опрос</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
                            </div>
                        </div>
                    </div>
                </div>    
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template name="POLLS">
    <xsl:for-each select="//MODULE/PANELXML/POLLS/ROW">
    <tr>
    	<td><a href="/panel/module?module={//MODULE/@include}&amp;poll={FIELD[@name = 'poll']}"><xsl:value-of select="FIELD[@name = 'vote']"/></a></td>
    	<td><a href="/panel/module?module={//MODULE/@include}&amp;poll={FIELD[@name = 'poll']}"><xsl:value-of select="FIELD[@name = 'question']"/></a></td>
        <td><xsl:value-of select="FIELD[@name = 'lang']"/></td>
    	<td><xsl:value-of select="FIELD[@name = 'total']"/></td>
        <td><a href="/panel/module?module={//MODULE/@include}&amp;action=deletepoll&amp;poll={FIELD[@name='poll']}" class="btn btn-danger btn-xs"><i class="fa fa-times"/>&#xA0;Удалить</a></td>
    </tr>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>