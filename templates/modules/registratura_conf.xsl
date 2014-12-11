<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template match="/DOCUMENT/MODULE/PANELXML">
        <xsl:variable name="url">
            /panel/module?module=<xsl:value-of select="//PARAM[@name='module']"/>
        </xsl:variable>
        <div>
            <a href="{$url}&amp;action=registratura/patients/report"><div class="reg-btn">Отчеты</div></a>
            <a href="{$url}&amp;action=registratura/templates"><div class="reg-btn">Шаблоны</div></a>
            <a href="{$url}&amp;action=registratura/schedule"><div class="reg-btn">Расписания</div></a>
            <a href="{$url}&amp;action=registratura/patients"><div class="reg-btn">Пациенты</div></a>
            <a href="{$url}&amp;action=registratura/patients/add"><div class="reg-btn">Записать на прием</div></a>
            <div style="clear: both"/>
        </div>
        <xsl:choose>
            <xsl:when test="//PARAM[@name='action']='registratura/templates'">
                <a href="/panel/registratura/templates/add">Добавить шаблон</a>
                <table cellpadidng="0px" cellspacing="0px" border="0px" width="100%">
                    <tr>
                        <td class="header" align="center">№</td>
                        <td class="header">Врач</td>
                        <td class="header">Специальность</td>
                        <td class="header" align="center">пн.</td>
                        <td class="header" align="center">вт.</td>
                        <td class="header" align="center">ср.</td>
                        <td class="header" align="center">чт.</td>
                        <td class="header" align="center">пт.</td>
                        <td class="header" align="center">сб.</td>
                        <td class="header" align="center">вс.</td>
                        <td class="header" align="center">Четность</td>
                        <td class="header" align="center">Тип</td>
                        <td class="header">Время раб.</td>
                        <td class="header">Время приема</td>
                        <td class="header">Время жур.</td>
                        <td class="header">Т.</td>
                        <td class="header">Онлайн-т.</td>
                        <td class="header">Действ.</td>
                    </tr>
                    <xsl:for-each select="//TEMPLATE">
                        <tr class="table">
                            <td><xsl:value-of select="@template"/></td>
                            <td><xsl:value-of select="DOCTOR/@name"/></td>
                            <td>
                                <xsl:variable name="spec" select="@spec"/>
                                <xsl:value-of select="//LIST[@id=$spec]/@value"/>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd; border-left: 1px solid #ddd">
                                <xsl:if test="@n1=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n2=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n3=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n4=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n5=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n6=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:if test="@n7=1">
                                    <img src="/i/dot.png"/>
                                </xsl:if>
                            </td>
                            <td align="center" style="border-right: 1px solid #ddd">
                                <xsl:choose>
                                    <xsl:when test="@mod = '1'">
                                        Нечетн.
                                    </xsl:when>
                                    <xsl:when test="@mod = '2'">
                                        Четн.
                                    </xsl:when>
                                    <xsl:when test="@mod = '0'">

                                    </xsl:when>
                                </xsl:choose>
                            </td>
                            <td align="center">
                                <xsl:choose>
                                    <xsl:when test="@in_time">
                                        По времени
                                    </xsl:when>
                                    <xsl:otherwise>
                                        По номеру
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td align="center">
                                <div>с:&#xA0;<xsl:value-of select="WORKTIME/@from"/></div>
                                <div>по:&#xA0;<xsl:value-of select="WORKTIME/@to"/></div>
                            </td>
                            <td align="center">
                                <div>с:&#xA0;<xsl:value-of select="RECIPIENTTIME/@from"/></div>
                                <div>по:&#xA0;<xsl:value-of select="RECIPIENTTIME/@to"/></div>
                            </td>
                            <td align="center">
                                <div>с:&#xA0;<xsl:value-of select="JORNALTIME/@from"/></div>
                                <div>по:&#xA0;<xsl:value-of select="JORNALTIME/@to"/></div>
                            </td>
                            <td align="center"><xsl:value-of select="RECIPIENTTIME/@talons"/></td>
                            <td align="center"><xsl:value-of select="RECIPIENTTIME/@onlinetalons"/></td>
                            <td align="center">
                                <a href="/panel/registratura/templates/edit?template={@template}"><img src="/i/edit.png" width="16px"/></a>&#xA0;
                                <a href="/panel/registratura/templates/delete?template={@template}"><img src="/i/delete.png" width="16px"/></a>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/templates/add'">
                <xsl:if test="/DOCUMENT/ERROR">
                    <div class="error">
                        <xsl:value-of select="/DOCUMENT/ERROR"/>
                    </div>
                </xsl:if>
                <form method="post" action="/panel/registratura/templates/add">
                    <table cellpadding="5px" cellspacing="0px" border="0px">
                        <tr style="background-color: #eee;">
                            <td>Врач:</td>
                            <td>
                                <select name="doctor">
                                    <xsl:for-each select="//DOCTORS/DOCTOR">
                                        <option value="{@login}"><xsl:value-of select="@name"/></option>
                                    </xsl:for-each>
                                </select>
                            </td>
                            <td class="info">
                                Выберите врача, для которого вы составляете шаблон расписания
                            </td>
                        </tr>
                        <tr>
                            <td>Специальность:</td>
                            <td>
                                <select name="spec">
                                    <xsl:for-each select="//LIST[@id='2']/LIST">
                                        <option value="{@id}"><xsl:value-of select="@value"/></option>
                                    </xsl:for-each>
                                </select>
                            </td>
                            <td></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Кабинет:</td>
                            <td>
                                <input type="text" name="cab" value="{//PARAM[@name='cab']}"/>
                            </td>
                            <td class="info">
                                Кабинет, в котором будет проходить прием
                            </td>
                        </tr>
                        <tr>
                            <td><input id="workyes" type="radio" name="work" value="yes" checked="checked"/>Работает</td>
                            <td><input id="workno" type="radio" name="work" value="no"/>Не работает</td>
                            <td class="info" rowspan="2">
                                Если врач "не работает" то заполните графу "Пометка"
                            </td>
                        </tr>
                        <tr>
                            <td>Пометка</td>
                            <td><input type="text" name="remark" style="width: 300px"/></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Дни недели:</td>
                            <td>
                                <input type="checkbox" name="wday[1]"/>пн.
                                <input type="checkbox" name="wday[2]"/>вт.
                                <input type="checkbox" name="wday[3]"/>ср.
                                <input type="checkbox" name="wday[4]"/>чт.
                                <input type="checkbox" name="wday[5]"/>пт.
                                <input type="checkbox" name="wday[6]"/>сб.
                                <input type="checkbox" name="wday[7]"/>вс.
                            </td>
                            <td class="info" rowspan="2">
                                Дни недели по которым действует шаблон
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Четность:</td>
                            <td>
                                <input type="radio" name="mod" value="2"/>Четные дни
                                <input type="radio" name="mod" value="1"/>Нечетные дни
                            </td>
                        </tr>
                        <tr>
                            <td>Со скольки (чч:мм):</td>
                            <td><input type="text" name="wfrom" class="wfrom" value="8:00"/></td>
                            <td class="info" rowspan="2">
                                Время присутствия врача в поликлинике, в расчетах времени талонов не применяется, время приема должно входить в это время.
                            </td>
                        </tr>
                        <tr>
                            <td>До скольки (чч:мм):</td>
                            <td><input type="text" name="wto" class="wto" value="18:00"/></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием с (чч:мм):</td>
                            <td><input type="text" name="pfrom" class="pfrom" value="8:00"/></td>
                            <td class="info" rowspan="2">
                                Время приема пациентов врачом. При расчете времени талонов этот интервал времени делится на количество талонов.
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием до (чч:мм):</td>
                            <td><input type="text" name="pto" class="pto" value="18:00"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Прием по журналу с(чч:мм):</td>
                            <td><input type="text" name="jfrom" class="jfrom"/></td>
                            <td class="info" rowspan="2">
                                Этот интервал времени исключается из времени приема по талонам.
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Прием по журналу до(чч:мм):
                            </td>
                            <td>
                                <input type="text" name="jto" class="jto"/>
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием по времени?</td>
                            <td>
                                <input type="radio" name="in_time" value="1" checked="checked"/>Да
                                <input type="radio" name="in_time" value="0"/>Нет
                            </td>
                            <td class="info">
                                Выберите "Да" если пациенты должны входить на прием в точно установленное время.
                                Если прием ведется по порядку номеров талонов, выберите "Нет"
                            </td>
                        </tr>
                        <tr>
                            <td>Количество талонов</td>
                            <td>
                                <input type="text" name="talonstotal"/>
                            </td>
                            <td class="info">
                                Общее количество талонов, которые врач примет за время приема.
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>
                                Кол-во талонов онлайн
                            </td>
                            <td>
                                <input type="text" name="talons"/>
                            </td>
                            <td class="info">
                                Количество талонов доступных для записи через сайт пользователями.
                            </td>
                        </tr>
                    </table>
                    <input type="submit"/>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/templates/edit'">
                <xsl:if test="/DOCUMENT/ERROR">
                    <div class="error">
                        <xsl:value-of select="/DOCUMENT/ERROR"/>
                    </div>
                </xsl:if>
                <form method="post" action="/panel/registratura/templates/edit">
                    <input type="hidden" name="template" value="{//PARAM[@name='template']}"/>
                    <table cellpadding="5px" cellspacing="0px" border="0px">
                        <tr style="background-color: #eee;">
                            <td>Врач:</td>
                            <td>
                                <select name="doctor">
                                    <xsl:for-each select="//DOCTORS/DOCTOR">
                                        <option value="{@login}">
                                            <xsl:if test="@login = //TEMPLATE/@login">
                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="@name"/>
                                        </option>
                                    </xsl:for-each>
                                </select>
                            </td>
                            <td class="info">
                                Выберите врача, для которого вы составляете шаблон расписания
                            </td>
                        </tr>
                        <tr>
                            <td>Специальность:</td>
                            <td>
                                <select name="spec">
                                    <xsl:for-each select="//LIST[@id='2']/LIST">
                                        <option value="{@id}">
                                            <xsl:if test="@id = //TEMPLATE/@spec">
                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="@value"/>
                                        </option>
                                    </xsl:for-each>
                                </select>
                            </td>
                            <td></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Кабинет:</td>
                            <td>
                                <input type="text" name="cab" value="{//PARAM[@name='cab']}"/>
                            </td>
                            <td class="info">
                                Кабинет, в котором будет проходить прием
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input id="workyes" type="radio" name="work" value="yes" checked="checked">
                                    <xsl:if test="//TEMPLATE/@remark = ''">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Работает</td>
                            <td><input id="workno" type="radio" name="work" value="no">
                                <xsl:if test="//TEMPLATE/@remark != ''">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </input>Не работает</td>
                            <td class="info" rowspan="2">
                                Если врач "не работает" то заполните графу "Пометка"
                            </td>
                        </tr>
                        <tr>
                            <td>Пометка</td>
                            <td><input type="text" name="remark" style="width: 500px"  value="{//TEMPLATE/@remark}"/></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Дни недели:</td>
                            <td>
                                <input type="checkbox" name="wday[1]"><xsl:if test="//TEMPLATE/@n1='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>пн.
                                <input type="checkbox" name="wday[2]"><xsl:if test="//TEMPLATE/@n2='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>вт.
                                <input type="checkbox" name="wday[3]"><xsl:if test="//TEMPLATE/@n3='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>ср.
                                <input type="checkbox" name="wday[4]"><xsl:if test="//TEMPLATE/@n4='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>чт.
                                <input type="checkbox" name="wday[5]"><xsl:if test="//TEMPLATE/@n5='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>пт.
                                <input type="checkbox" name="wday[6]"><xsl:if test="//TEMPLATE/@n6='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>сб.
                                <input type="checkbox" name="wday[7]"><xsl:if test="//TEMPLATE/@n7='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>вс.
                            </td>
                            <td class="info">
                                Дни недели по которым действует шаблон
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Четность:</td>
                            <td>
                                <input type="radio" name="mod" value="2"><xsl:if test="//TEMPLATE/@mod='2'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>Четные дни
                                <input type="radio" name="mod" value="1"><xsl:if test="//TEMPLATE/@mod='1'"><xsl:attribute name='checked'>checked</xsl:attribute></xsl:if></input>Нечетные дни
                            </td>
                        </tr>
                        <tr>
                            <td>Со скольки (чч:мм):</td>
                            <td><input type="text" name="wfrom" class="wfrom" value="{//TEMPLATE/@wfrom}"/></td>
                            <td class="info" rowspan="2">
                                Время присутствия врача в поликлинике, в расчетах времени талонов не применяется, время приема должно входить в это время.
                            </td>
                        </tr>
                        <tr>
                            <td>До скольки (чч:мм):</td>
                            <td><input type="text" name="wto" class="wto" value="{//TEMPLATE/@wto}"/></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием с (чч:мм):</td>
                            <td><input type="text" name="pfrom" class="pfrom" value="{//TEMPLATE/@pfrom}"/></td>
                            <td class="info" rowspan="2">
                                Время приема пациентов врачом. При расчете времени талонов этот интервал времени делится на количество талонов.
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием до (чч:мм):</td>
                            <td><input type="text" name="pto" class="pto" value="{//TEMPLATE/@pto}"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Прием по журналу с(чч:мм):</td>
                            <td><input type="text" name="jfrom" class="jfrom" value="{//TEMPLATE/@jfrom}"/></td>
                            <td class="info" rowspan="2">
                                Этот интервал времени исключается из времени приема по талонам.
                            </td>
                        </tr>
                        <tr>
                            <td>Прием по журналу до(чч:мм):</td>
                            <td><input type="text" name="jto" class="jto" value="{//TEMPLATE/@jto}"/></td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Прием по времени?</td>
                            <td>
                                <input type="radio" name="in_time" value="1">
                                    <xsl:if test="//TEMPLATE/@in_time='1'">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>Да
                                <input type="radio" name="in_time" value="0">
                                    <xsl:if test="//TEMPLATE/@in_time='0'">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>Нет
                            </td>
                            <td class="info">
                                Выберите "Да" если пациенты должны входить на прием в точно установленное время.
                                Если прием ведется по порядку номеров талонов, выберите "Нет"
                            </td>
                        </tr>
                        <tr>
                            <td>Количество талонов</td>
                            <td><input type="text" name="talonstotal" value="{//TEMPLATE/@talonstotal}"/></td>
                            <td class="info">
                                Общее количество талонов, которые врач примет за время приема.
                            </td>
                        </tr>
                        <tr style="background-color: #eee;">
                            <td>Кол-во талонов онлайн</td>
                            <td><input type="text" name="talons" value="{//TEMPLATE/@talons}"/></td>
                            <td class="info">
                                Количество талонов доступных для записи через сайт пользователями.
                            </td>
                        </tr>
                    </table>
                    <input type="submit" value="Изменить шаблон"/>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/patients/add'">
                <xsl:if test="//ERROR">
                    <div class="error"><xsl:value-of select="//ERROR"/></div>
                </xsl:if>
                <form name="talonset" method="post">
                    <xsl:if test="/DOCUMENT/DOCTOR/SCHEDULE">
                        <input type="hidden" name="schedule" value="{/DOCUMENT/DOCTOR/SCHEDULE/@schedule}"/>
                    </xsl:if>
                    <table>
                        <tr>
                            <td valign="top">
                                Выберите дату:
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="//PARAM[@name='day']">
                                        <input type="text" name="day" value="{//PARAM[@name='day']}" id="datepicker" class="patient-add-date" data-login="{//PARAM[@name='login']}" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <input type="text" name="day" value="{//DATE[@is_current='yes']/@fulldate}" id="datepicker" class="patient-add-date" data-login="{//PARAM[@name='login']}"  style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                Выберите врача:
                            </td>
                            <td>
                                <div>
                                    <select name="login" id="doctor" class="patient-add-doctor">
                                        <xsl:for-each select="//DOCTOR">
                                            <xsl:sort select="@name" data-type="text" order="ascending"/>
                                            <xsl:variable name="login" select="@login"/>
                                            <option value="{$login}">
                                                <xsl:if test="//PARAM[@name='login'] = $login">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="@name"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <xsl:if test="//TIMESET">
                        на время:
                        <div>
                            <xsl:for-each select="/DOCUMENT/TIMESET/TIME">
                                <div>
                                    <xsl:choose>
                                        <xsl:when test="/DOCUMENT/TIMESET/@in_time='1'">
                                            <xsl:choose>
                                                <xsl:when test="@close='yes'">
                                                    <B><xsl:value-of select="."/> - №<xsl:value-of select="@tnum"/></B>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <input type="radio" name="time" value="{@id}" class="timeselect"/>
                                                    <xsl:value-of select="."/> - №<xsl:value-of select="@tnum"/>
                                                    <input type="radio" id="{@id}" name="tnum" value="{@tnum}" style="display: none"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="@close='yes'">
                                                    <B>№<xsl:value-of select="@tnum"/></B>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <input type="radio" name="time" value="{@id}" class="timeselect"/>
                                                    №<xsl:value-of select="@tnum"/>
                                                    <input type="radio" id="{@id}" name="tnum" value="{@tnum}" style="display: none"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </xsl:for-each>
                        </div>
                        <input type="submit" value="Записать"/>
                    </xsl:if>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/patients/edit'">
                <form name="talonadd" method="post" action="">
                    <input type="hidden" name="id" value="{//PARAM[@name='id']}"/>
                    <table cellspacing="5px">
                        <tr>
                            <td>Номер талона</td>
                            <td><input type="text" name="tnum" style="width: 300px" value="{//TALON/@tnum}"/></td>
                        </tr>
                        <tr>
                            <td>ФИО</td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="//TALON/@f != ''">
                                        <input type="text" name="fio" style="width: 300px" value="{//TALON/@f} {//TALON/@i} {//TALON/@o}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <input type="text" name="fio" style="width: 300px"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>Дата рождения</td>
                            <td><input type="text" name="birth" style="width: 300px" value="{//TALON/@birth}"/></td>
                        </tr>
                        <tr>
                            <td>Адрес</td>
                            <td><input type="text" name="addr" style="width: 300px" value="{//TALON/@addr}"/></td>
                        </tr>
                        <tr>
                            <td>Телефон</td>
                            <td><input type="text" name="phone" style="width: 300px" value="{//TALON/@phone}"/></td>
                        </tr>
                        <tr>
                            <td>№ медкарты</td>
                            <td><input type="text" name="cartnum" style="width: 300px" value="{//TALON/@cartnum}"/></td>
                        </tr>
                        <tr>
                            <td>Дата приема</td>
                            <td>
                                <div><xsl:value-of select="//TALON/@dday"/></div>
                            </td>
                        </tr>
                        <tr>
                            <td>Время приема</td>
                            <td>
                                <div><xsl:value-of select="//TALON/@daytime"/></div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Врач</td>
                            <td style="padding-bottom: 10px">
                                <xsl:value-of select="/DOCUMENT/DOCTOR/@name"/>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Специальность</td>
                            <td style="padding-bottom: 10px">
                                <xsl:variable name="spec" select="/DOCUMENT/SCHEDULE/@spec"/>
                                <xsl:value-of select="//LIST[@id=$spec]/@value"/>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Возраст</td>
                            <td style="padding-bottom: 10px">
                                <input type="radio" name="age" value="1">
                                    <xsl:if test="//TALON/@age = 1">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Ребенок(0-14 лет)<BR/>
                                <input type="radio" name="age" value="2">
                                    <xsl:if test="//TALON/@age = 2">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Подросток(от 15 до 17)<BR/>
                                <input type="radio" name="age" value="3">
                                    <xsl:if test="//TALON/@age = 3">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Взрослый(от 18)<BR/>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Повод обращения</td>
                            <td>
                                <input type="radio" name="povod" value="1">
                                    <xsl:if test="//TALON/@povod = 1">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Заболевание<BR/>
                                <input type="radio" name="povod" value="2">
                                    <xsl:if test="//TALON/@povod = 2">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Профилактический осмотр<BR/>
                                <input type="radio" name="povod" value="3">
                                    <xsl:if test="//TALON/@povod = 3">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Прививка<BR/>
                                <input type="radio" name="povod" value="4">
                                    <xsl:if test="//TALON/@povod = 4">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                За справкой<BR/>
                                <input type="radio" name="povod" value="5">
                                    <xsl:if test="//TALON/@povod = 5">
                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                    </xsl:if>
                                </input>
                                Другие причины<BR/>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Пояснение</td>
                            <td><input type="text" name="text" value="{//TALON/@text}" style="width: 300px"/></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="submit" value="Записать"/>
                            </td>
                        </tr>
                    </table>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/schedule'">
                <a href="{$url}&amp;action=registratura/schedule/add">Добавить расписание</a>&#xA0;
                <div align="left" valign="top" style="padding: 2px 6px 0px 0px; font-family: Verdana; font-size: 14px;">
                    День работы:
                </div>
                <div>
                    <form name="cal" action="" method="get">
                        <xsl:choose>
                            <xsl:when test="//PARAM[@name='day']">
                                <input type="text" name="day" value="{//PARAM[@name='day']}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <input type="text" name="day" value="{//DATE[@is_current='yes']/@fulldate}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </form>
                </div>
                <table border="1px" cellpadding="0px" cellspacing="0px" width="100%">
                    <tr>
                        <td class="header" valign="top">
                            Доктор
                        </td>
                        <xsl:for-each select="//CALENDAR/MONTH/WEEK[DATE[@is_current='yes']]/DATE">
                            <td class="header" align="center" width="12%">
                                <xsl:variable name="weekday" select="@weekday"/>
                                <div style="font-size: 22px;"><xsl:value-of select="."/></div>
                                <div>
                                    <xsl:variable name="month" select="@month"/>
                                    <xsl:value-of select="//MONTHNAME[@num=$month]"/>
                                </div>
                                <div style="font-size: 10px;"><xsl:value-of select="//CALENDAR/WEEKDAY[@weekday=$weekday]"/></div>
                            </td>
                        </xsl:for-each>
                    </tr>
                    <xsl:for-each select="/DOCUMENT/DOCTOR">
                        <xsl:variable name="login" select="@login"/>
                        <tr>
                            <td valign="top">
                                <a href="/panel/registratura/doctors?login={$login}"><xsl:value-of select="@name"/></a>
                                <a href="#" class="doctor-options"><img src="/i/lists.png" width="12px;"/></a>
                                <div class="doctor-menu">
                                    <xsl:choose>
                                        <xsl:when test="//PARAM[@name='date']">
                                            <xsl:variable name="cdate" select="//PARAM[@name='date']"/>
                                            <a href="/panel/registratura/schedule/auto?login={$login}&amp;day={$cdate}&amp;type=weekly">Автозаполнение</a>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:variable name="cdate" select="//DATE[@is_current='yes']/@fulldate"/>
                                            <a href="/panel/registratura/schedule/auto?login={$login}&amp;day={$cdate}&amp;type=weekly">Автозаполнение</a>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </td>
                            <xsl:for-each select="//CALENDAR//WEEK[DATE[@is_current='yes']]/DATE">
                                <td valign="top">
                                    <xsl:variable name="cday" select="@fulldate"/>
                                    <xsl:for-each select="//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]">
                                        <div class="worktime">
                                            <xsl:choose>
                                                <xsl:when test="MESSAGE">
                                                    <div><xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/MESSAGE"/></div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/patients/add?login={$login}&amp;day={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@day}&amp;id={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@id}"><img src="/i/add.png" width="14px"/></a></div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/schedule/edit?id={@id}"><img src="/i/edit.png" width="14px"/></a></div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/schedule/delete?id={@id}&amp;day={$cday}"><img src="/i/delete.png" width="14px"/></a></div>
                                                </xsl:when>
                                                <xsl:when test="WORKTIME">
                                                    <div>
                                                        <xsl:value-of select="RECIPIENTTIME/@from"/>-<xsl:value-of select="RECIPIENTTIME/@to"/>
                                                        &#xA0;<xsl:variable name="spec" select="@spec"/><xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                                    </div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/patients/add?login={$login}&amp;day={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@day}&amp;id={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@id}"><img src="/i/add.png" width="14px"/></a></div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/schedule/edit?id={@id}"><img src="/i/edit.png" width="14px"/></a></div>
                                                    <div style="display: inline-block; margin: 0px 2px"><a href="/panel/registratura/schedule/delete?id={@id}&amp;day={$cday}"><img src="/i/delete.png" width="14px"/></a></div>

                                                    <!--
                                                    <Время работы:&#xA0;<xsl:value-of select="WORKTIME/@from"/>-<xsl:value-of select="WORKTIME/@to"/>
                                                    <Время приема:&#xA0;><xsl:value-of select="RECIPIENTTIME/@from"/>-<xsl:value-of select="RECIPIENTTIME/@to"/>
                                                    <xsl:if test="JORNALTIME">
                                                        Время приема по журналу:&#xA0;<xsl:value-of select="JORNALTIME/@from"/>-<xsl:value-of select="JORNALTIME/@to"/>
                                                    </xsl:if>
                                                    <Специальность:&#xA0;><xsl:variable name="spec" select="@spec"/><xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                                    <div style="display: inline-block"><a href="/panel/registratura/patients/add?login={$login}&amp;day={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@day}&amp;id={//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]/@id}">записать на прием</a></div>
                                                    <div style="display: inline-block; margin: 0px 4px"><a href="/panel/registratura/schedule/edit?id={@id}"><img src="/i/edit.png" width="14px"/></a></div>
                                                    <div style="display: inline-block; margin: 0px 4px"><a href="/panel/registratura/schedule/delete?id={@id}&amp;day={$cday}"><img src="/i/delete.png" width="14px"/></a></div>
                                                    -->
                                                </xsl:when>
                                            </xsl:choose>
                                        </div>
                                    </xsl:for-each>
                                    <xsl:if test="count(//DOCTOR[@login=$login]/SCHEDULE[@day=$cday]) = 0">
                                        <div class="worktime">
                                            нет расписания
                                        </div>
                                    </xsl:if>
                                    <div class="worktime1"><a href="/panel/registratura/schedule/auto?login={$login}&amp;day={$cday}&amp;type=daily">Добавить расписание</a></div>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/schedule/add'">
                <xsl:if test="/DOCUMENT/ERROR">
                    <div class="error">
                        <xsl:value-of select="/DOCUMENT/ERROR"/>
                    </div>
                </xsl:if>
                <form method="post" action="/panel/registratura/schedule/add">
                    <table>
                        <tr>
                            <td>День:</td>
                            <td>
                                <input type="text" name="day" value="{//PARAM[@name='day']}" id="datepicker"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Врач:</td>
                            <td>
                                <select name="doctor">
                                    <xsl:for-each select="//DOCTORS/DOCTOR">
                                        <option value="{@login}"><xsl:value-of select="@name"/></option>
                                    </xsl:for-each>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Специальность:</td>
                            <td>
                                <select name="spec">
                                    <xsl:for-each select="//LIST[@id='2']/LIST">
                                        <option value="{@id}"><xsl:value-of select="@value"/></option>
                                    </xsl:for-each>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Кабинет:</td>
                            <td>
                                <input type="text" name="cab" value="{//PARAM[@name='cab']}"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input id="workyes" type="radio" name="work" value="yes" checked="checked"/>Работает
                            </td>
                            <td>
                                <input id="workno" type="radio" name="work" value="no"/>Не работает
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="workfields">
                                    <table cellpadding="0px" cellspacing="0px" border="0px" width="500px">
                                        <tr>
                                            <td>
                                                Со скольки (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="wfrom" class="wfrom" value="8:00"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                До скольки (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="wto" class="wto" value="18:00"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием с (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="pfrom" class="pfrom" value="8:00"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием до (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="pto" class="pto" value="18:00"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием по журналу с(чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="jfrom" class="jfrom"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием по журналу до(чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="jto" class="jto"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Прием по времени?</td>
                                            <td>
                                                <input type="radio" name="in_time" value="1" checked="checked"/>Да
                                                <input type="radio" name="in_time" value="0"/>Нет
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Количество талонов</td>
                                            <td>
                                                <input type="text" name="talonstotal"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Кол-во талонов онлайн
                                            </td>
                                            <td>
                                                <input type="text" name="talons"/>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="remark">
                                    <div>Пометка</div>
                                    <input type="text" name="remark" style="width: 500px"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <input type="submit"/>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/schedule/edit'">
                <xsl:if test="/DOCUMENT/ERROR">
                    <div class="error">
                        <xsl:value-of select="/DOCUMENT/ERROR"/>
                    </div>
                </xsl:if>
                <form method="post" action="/panel/registratura/schedule/edit">
                    <input type="hidden" name="id" value="{//PARAM[@name='id']}"/>
                    <table cellspacing="5px">
                        <tr>
                            <td>Врач:</td>
                            <td>
                                <xsl:value-of select="//DOCTORS/DOCTOR[@login=//SCHEDULE/@login]/@name"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Специальность:</td>
                            <td>
                                <select name="spec">
                                    <xsl:for-each select="//LIST[@id='2']/LIST">
                                        <option value="{@id}">
                                            <xsl:if test="@id = //SCHEDULE/@spec">
                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="@value"/>
                                        </option>
                                    </xsl:for-each>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Кабинет:</td>
                            <td>
                                <input type="text" name="cab" value="{//SCHEDULE/@cab}"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Дата</td>
                            <td>
                                <xsl:value-of select="//SCHEDULE/@day"/>
                                <input type="hidden" name="day" value="{//SCHEDULE/@day}"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input id="workyes" type="radio" name="work" value="yes" checked="checked"/>Работает
                            </td>
                            <td>
                                <input id="workno" type="radio" name="work" value="no"/>Не работает
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="workfields">
                                    <table cellpadding="0px" cellspacing="5px" border="0px" width="500px">
                                        <tr>
                                            <td>
                                                Со скольки (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="wfrom" class="wfrom" value="{//SCHEDULE/@from}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                До скольки (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="wto" class="wto" value="{//SCHEDULE/@to}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием с (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="pfrom" class="pfrom" value="{//SCHEDULE/@pfrom}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием до (чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="pto" class="pto" value="{//SCHEDULE/@pto}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием по журналу с(чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="jfrom" class="jfrom" value="{//SCHEDULE/@jfrom}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Прием по журналу до(чч:мм):
                                            </td>
                                            <td>
                                                <input type="text" name="jto" class="jto" value="{//SCHEDULE/@jto}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Прием по времени?</td>
                                            <td>
                                                <input type="radio" name="in_time" value="1">
                                                    <xsl:if test="//SCHEDULE/@in_time='1'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </input>Да
                                                <input type="radio" name="in_time" value="0">
                                                    <xsl:if test="//SCHEDULE/@in_time='0'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </input>Нет
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Количество талонов</td>
                                            <td>
                                                <input type="text" name="talonstotal" value="{//SCHEDULE/@talonstotal}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Кол-во талонов онлайн
                                            </td>
                                            <td>
                                                <input type="text" name="talons" value="{//SCHEDULE/@talons}"/>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="remark">
                                    <div>Пометка</div>
                                    <input type="text" name="remark" style="width: 500px"  value="{//SCHEDULE/@remark}"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="5px" cellspacing="0px" border="0px" width="100%">
                        <!--tr>
                            <td class="header" style="padding-left: 6px; width: 28px">№ п/п</td>
                            <td class="header" style="padding-left: 6px;">Дата оказания государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">ФИО получателя государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">Дата рождения получателя государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">Домашний адрес получателя государственных услуг</td>

                        </tr-->
                        <xsl:for-each select="//SCHEDULE/TIMESET/TIME">
                            <xsl:choose>
                                <xsl:when test="TALON">
                                    <xsl:variable name="schedule" select="TALON/FIELD[@name='schedule']"/>
                                    <tr class="table">
                                        <td>
                                            <xsl:value-of select="@id"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="@time"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="TALON/FIELD[@name='tnum']"/>&#xA0;[<xsl:value-of select="$schedule"/>]<xsl:value-of select="TALON/FIELD[@name='online']"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="TALON/FIELD[@name='time']"/>
                                            <div><xsl:value-of select="TALON/FIELD[@name='dday']"/></div>
                                        </td>
                                        <td>
                                            <xsl:value-of select="TALON/FIELD[@name='f']"/>&#xA0;
                                            <xsl:value-of select="TALON/FIELD[@name='i']"/>&#xA0;
                                            <xsl:value-of select="TALON/FIELD[@name='o']"/>&#xA0;
                                        </td>
                                        <td><xsl:value-of select="TALON/FIELD[@name='birth']"/></td>
                                        <td>
                                            <xsl:value-of select="TALON/FIELD[@name='addr']"/>
                                            <xsl:if test="TALON/FIELD[@name='phone'] != ''">
                                                (тел. <xsl:value-of select="TALON/FIELD[@name='phone']"/>)
                                            </xsl:if>
                                        </td>
                                        <td><a href="#" onclick="window.open('/panel/registratura/printable?talon={TALON/@id}', 'Версия для печати')">Посмотреть талон</a></td>
                                    </tr>
                                </xsl:when>
                                <xsl:otherwise>
                                    <tr class="table">
                                        <td>
                                            <xsl:value-of select="@id"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="@time"/>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>




                        <xsl:for-each select="//SCHEDULE/TIMESET/TALON">
                            <xsl:variable name="schedule" select="FIELD[@name='schedule']"/>
                            <tr class="table">
                                <td colspan="2">
                                    <select name="tt" data-talon="{@id}" data-schedule="{$schedule}" class="talon-move">
                                        <option>---</option>
                                        <xsl:for-each select="//SCHEDULE/TIMESET/TIME[not(TALON)]">
                                            <option value="{@id}"><xsl:value-of select="@time"/></option>
                                        </xsl:for-each>
                                    </select>
                                </td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='tnum']"/>&#xA0;[<xsl:value-of select="$schedule"/>]<xsl:value-of select="FIELD[@name='online']"/>
                                </td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='time']"/>
                                    <div><xsl:value-of select="FIELD[@name='dday']"/></div>
                                </td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='f']"/>&#xA0;
                                    <xsl:value-of select="FIELD[@name='i']"/>&#xA0;
                                    <xsl:value-of select="FIELD[@name='o']"/>&#xA0;
                                </td>
                                <td><xsl:value-of select="FIELD[@name='birth']"/></td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='addr']"/>
                                    <xsl:if test="FIELD[@name='phone'] != ''">
                                        (тел. <xsl:value-of select="FIELD[@name='phone']"/>)
                                    </xsl:if>
                                </td>
                                <td><a href="#" onclick="window.open('/panel/registratura/printable?talon={@id}', 'Версия для печати')">Посмотреть талон</a></td>
                            </tr>
                        </xsl:for-each>






                    </table>
                    <input type="submit" value="Сохранить изменения"/>
                </form>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/schedule/auto'">
                <xsl:choose>
                    <xsl:when test="//PARAM[@name='type'] = 'daily' and not(//PARAM[@name='login'])">

                    </xsl:when>
                    <xsl:when test="//PARAM[@name='type'] = 'daily'">
                        <div style="float: left; padding-right: 30px;">Автозаполнение расписания на день: <xsl:value-of select="//PARAM[@name='day']"/></div>
                        <div style="float: left">Доктор: <xsl:value-of select="//DOCTOR/@name"/></div>
                        <div style="clear: both">Введите <a href="#" class="showform">вручную расписание</a> или <a href="#" class="showtemplate">выберите шаблон</a></div>
                        <div class="templates-wrapper">
                            <form method="post" action="/panel/registratura/schedule/auto">
                                <input type="hidden" name="login" value="{//PARAM[@name='login']}"/>
                                <input type="hidden" name="day" value="{//PARAM[@name='day']}"/>
                                <table cellpadidng="0px" cellspacing="0px" border="0px" width="100%">
                                    <tr>
                                        <td class="header" align="center">№</td>
                                        <td class="header">Врач</td>
                                        <td class="header">Специальность</td>
                                        <td class="header" align="center">пн.</td>
                                        <td class="header" align="center">вт.</td>
                                        <td class="header" align="center">ср.</td>
                                        <td class="header" align="center">чт.</td>
                                        <td class="header" align="center">пт.</td>
                                        <td class="header" align="center">сб.</td>
                                        <td class="header" align="center">вс.</td>
                                        <td class="header" align="center">Четность</td>
                                        <td class="header" align="center">Тип</td>
                                        <td class="header">Время раб.</td>
                                        <td class="header">Время приема</td>
                                        <td class="header">Время жур.</td>
                                        <td class="header">Т.</td>
                                        <td class="header">Онлайн-т.</td>
                                        <td class="header">Действ.</td>
                                    </tr>
                                    <xsl:for-each select="//TEMPLATE">
                                        <tr class="table">
                                            <td>
                                                <xsl:value-of select="@template"/>
                                                <input type="checkbox" name="template" value="{@template}"/>
                                            </td>
                                            <td><xsl:value-of select="DOCTOR/@name"/></td>
                                            <td>
                                                <xsl:variable name="spec" select="@spec"/>
                                                <xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd; border-left: 1px solid #ddd">
                                                <xsl:if test="@n1=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n2=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n3=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n4=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n5=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n6=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:if test="@n7=1">
                                                    <img src="/i/dot.png"/>
                                                </xsl:if>
                                            </td>
                                            <td align="center" style="border-right: 1px solid #ddd">
                                                <xsl:choose>
                                                    <xsl:when test="@mod = '1'">
                                                        Нечетн.
                                                    </xsl:when>
                                                    <xsl:when test="@mod = '2'">
                                                        Четн.
                                                    </xsl:when>
                                                    <xsl:when test="@mod = '0'">

                                                    </xsl:when>
                                                </xsl:choose>
                                            </td>
                                            <td align="center">
                                                <xsl:choose>
                                                    <xsl:when test="@in_time">
                                                        По времени
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        По номеру
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </td>
                                            <td align="center">
                                                <div>с:&#xA0;<xsl:value-of select="WORKTIME/@from"/></div>
                                                <div>по:&#xA0;<xsl:value-of select="WORKTIME/@to"/></div>
                                            </td>
                                            <td align="center">
                                                <div>с:&#xA0;<xsl:value-of select="RECIPIENTTIME/@from"/></div>
                                                <div>по:&#xA0;<xsl:value-of select="RECIPIENTTIME/@to"/></div>
                                            </td>
                                            <td align="center">
                                                <div>с:&#xA0;<xsl:value-of select="JORNALTIME/@from"/></div>
                                                <div>по:&#xA0;<xsl:value-of select="JORNALTIME/@to"/></div>
                                            </td>
                                            <td align="center"><xsl:value-of select="RECIPIENTTIME/@talons"/></td>
                                            <td align="center"><xsl:value-of select="RECIPIENTTIME/@onlinetalons"/></td>
                                            <td align="center">
                                                <a href="/panel/registratura/templates/edit?template={@template}"><img src="/i/edit.png" width="16px"/></a>&#xA0;
                                                <a href="/panel/registratura/templates/delete?template={@template}"><img src="/i/delete.png" width="16px"/></a>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </table>
                                <input type="submit" value="Заполнить"/>
                            </form>
                        </div>
                        <div class="form-wrapper">
                            <form method="post" action="/panel/registratura/schedule/add">
                                <input type="hidden" name="doctor" value="{//PARAM[@name='login']}"/>
                                <input type="hidden" name="day" value="{//PARAM[@name='day']}"/>
                                <table>
                                    <tr>
                                        <td>Специальность:</td>
                                        <td>
                                            <select name="spec">
                                                <xsl:for-each select="//LIST[@id='2']/LIST">
                                                    <option value="{@id}"><xsl:value-of select="@value"/></option>
                                                </xsl:for-each>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Кабинет:</td>
                                        <td>
                                            <input type="text" name="cab" value="{//PARAM[@name='cab']}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="workyes" type="radio" name="work" value="yes" checked="checked"/>Работает
                                        </td>
                                        <td>
                                            <input id="workno" type="radio" name="work" value="no"/>Не работает
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div class="workfields">
                                                <table cellpadding="0px" cellspacing="0px" border="0px" width="500px">
                                                    <tr>
                                                        <td>
                                                            Со скольки (чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="wfrom" class="wfrom" value="8:00"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            До скольки (чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="wto" class="wto" value="18:00"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Прием с (чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="pfrom" class="pfrom" value="8:00"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Прием до (чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="pto" class="pto" value="18:00"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Прием по журналу с(чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="jfrom" class="jfrom"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Прием по журналу до(чч:мм):
                                                        </td>
                                                        <td>
                                                            <input type="text" name="jto" class="jto"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Прием по времени?</td>
                                                        <td>
                                                            <input type="radio" name="in_time" value="1" checked="checked"/>Да
                                                            <input type="radio" name="in_time" value="0"/>Нет
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Количество талонов</td>
                                                        <td>
                                                            <input type="text" name="talonstotal"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Кол-во талонов онлайн
                                                        </td>
                                                        <td>
                                                            <input type="text" name="talons"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="remark">
                                                <div>Пометка</div>
                                                <input type="text" name="remark" style="width: 500px"/>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <input type="submit"/>
                            </form>
                        </div>
                    </xsl:when>
                    <xsl:when test="//PARAM[@name='type'] = 'weekly' and not(//PARAM[@name='login'])">

                    </xsl:when>
                    <xsl:when test="//PARAM[@name='type'] = 'weekly'">
                        <form method="post" action="/panel/registratura/schedule/auto">
                            <div>Автозаполнение расписания на неделю.</div>
                            <div>С: <input type="text" name="start" value="{//WEEKLY/@start}" id="datepicker"/>&#xA0;По: <input type="text" name="end" value="{//WEEKLY/@end}" id="datepicker2"/></div>
                            <div>Доктор: <xsl:value-of select="//DOCTOR/@name"/></div>
                            <div>Выберите шаблон</div>
                            <input type="hidden" name="login" value="{//PARAM[@name='login']}"/>
                            <table cellpadidng="0px" cellspacing="0px" border="0px" width="100%">
                                <tr>
                                    <td class="header" align="center">№</td>
                                    <td class="header">Врач</td>
                                    <td class="header">Специальность</td>
                                    <td class="header" align="center">пн.</td>
                                    <td class="header" align="center">вт.</td>
                                    <td class="header" align="center">ср.</td>
                                    <td class="header" align="center">чт.</td>
                                    <td class="header" align="center">пт.</td>
                                    <td class="header" align="center">сб.</td>
                                    <td class="header" align="center">вс.</td>
                                    <td class="header" align="center">Четность</td>
                                    <td class="header" align="center">Тип</td>
                                    <td class="header">Время раб.</td>
                                    <td class="header">Время приема</td>
                                    <td class="header">Время жур.</td>
                                    <td class="header">Т.</td>
                                    <td class="header">Онлайн-т.</td>
                                    <td class="header">Действ.</td>
                                </tr>
                                <xsl:for-each select="//TEMPLATE">
                                    <tr class="table">
                                        <td>
                                            <xsl:value-of select="@template"/>
                                            <input type="checkbox" name="template[]" value="{@template}"/>
                                        </td>
                                        <td><xsl:value-of select="DOCTOR/@name"/></td>
                                        <td>
                                            <xsl:variable name="spec" select="@spec"/>
                                            <xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd; border-left: 1px solid #ddd">
                                            <xsl:if test="@n1=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n2=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n3=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n4=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n5=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n6=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:if test="@n7=1">
                                                <img src="/i/dot.png"/>
                                            </xsl:if>
                                        </td>
                                        <td align="center" style="border-right: 1px solid #ddd">
                                            <xsl:choose>
                                                <xsl:when test="@mod = '1'">
                                                    Нечетн.
                                                </xsl:when>
                                                <xsl:when test="@mod = '2'">
                                                    Четн.
                                                </xsl:when>
                                                <xsl:when test="@mod = '0'">

                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td align="center">
                                            <xsl:choose>
                                                <xsl:when test="@in_time">
                                                    По времени
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    По номеру
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td align="center">
                                            <div>с:&#xA0;<xsl:value-of select="WORKTIME/@from"/></div>
                                            <div>по:&#xA0;<xsl:value-of select="WORKTIME/@to"/></div>
                                        </td>
                                        <td align="center">
                                            <div>с:&#xA0;<xsl:value-of select="RECIPIENTTIME/@from"/></div>
                                            <div>по:&#xA0;<xsl:value-of select="RECIPIENTTIME/@to"/></div>
                                        </td>
                                        <td align="center">
                                            <div>с:&#xA0;<xsl:value-of select="JORNALTIME/@from"/></div>
                                            <div>по:&#xA0;<xsl:value-of select="JORNALTIME/@to"/></div>
                                        </td>
                                        <td align="center"><xsl:value-of select="RECIPIENTTIME/@talons"/></td>
                                        <td align="center"><xsl:value-of select="RECIPIENTTIME/@onlinetalons"/></td>
                                        <td align="center">
                                            <a href="/panel/registratura/templates/edit?template={@template}"><img src="/i/edit.png" width="16px"/></a>&#xA0;
                                            <a href="/panel/registratura/templates/delete?template={@template}"><img src="/i/delete.png" width="16px"/></a>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                            <input type="submit" value="Заполнить"/>
                        </form>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/doctors'">
                <a href="/panel/registratura/doctors">Все доктора</a>
                <div align="left" valign="top" style="padding: 2px 6px 0px 0px; font-family: Verdana; font-size: 14px;">
                    День работы:
                </div>
                <div>
                    <form name="cal" action="" method="get">
                        <input type="hidden" name="login" value="{//PARAM[@name='login']}"/>
                        <xsl:choose>
                            <xsl:when test="//PARAM[@name='day']">
                                <input type="text" name="day" value="{//PARAM[@name='day']}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <input type="text" name="day" value="{//DATE[@is_current='yes']/@fulldate}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </form>
                </div>
                <table border="1px" cellpadding="0px" cellspacing="0px" width="100%">
                    <tr>
                        <td class="header" valign="top">Доктор</td>
                        <xsl:for-each select="//CALENDAR/MONTH/WEEK[DATE[@is_current='yes']]/DATE">
                            <td class="header" align="center" width="12%">
                                <xsl:variable name="weekday" select="@weekday"/>
                                <div style="font-size: 22px;"><xsl:value-of select="."/></div>
                                <div><xsl:value-of select="//CALENDAR/MONTH/@name"/></div>
                                <div style="font-size: 10px;"><xsl:value-of select="//CALENDAR/WEEKDAY[@weekday=$weekday]"/></div>
                            </td>
                        </xsl:for-each>
                    </tr>
                    <xsl:for-each select="/DOCUMENT/DOCTOR">
                        <xsl:variable name="login" select="@login"/>
                        <tr>
                            <td>
                                <a href="/panel/registratura/doctors?login={$login}"><xsl:value-of select="@name"/></a>
                            </td>
                            <xsl:for-each select="//CALENDAR/WEEKDAY">
                                <td valign="top">
                                    <xsl:variable name="weekday" select="@weekday"/>
                                    <div class="worktime">
                                        <xsl:choose>
                                            <xsl:when test="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/MESSAGE">
                                                <xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/MESSAGE"/>
                                            </xsl:when>
                                            <xsl:when test="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/WORKTIME">
                                                Время работы:&#xA0;<xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/WORKTIME/@from"/>-<xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/WORKTIME/@to"/>
                                                Время приема:&#xA0;<xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/RECIPIENTTIME/@from"/>-<xsl:value-of select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/RECIPIENTTIME/@to"/>
                                                Специальность:&#xA0;<xsl:variable name="spec" select="//DOCTOR[@login=$login]/SCHEDULE[@weekday=$weekday]/@spec"/><xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                                <div>
                                                    <a href="/panel/registratura/patients?login={$login}&amp;dday={//DOCTOR[@login=$login]/SCHEDULE/@day}">Посмотреть запись</a>
                                                </div>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                нет расписания
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/patients'">
                <xsl:if test="//PARAM[@name='talon']">
                    <div class="talon" id="{//PARAM[@name='talon']}"/>
                </xsl:if>
                <form name="cal" action="" method="get">
                    <table>
                        <tr>
                            <td>
                                <div align="left" valign="top" style="padding: 3px 6px 0px 0px; font-family: Verdana; font-size: 14px;">
                                    День работы:
                                </div>
                            </td>
                            <td>
                                <div style="padding-top: 4px">
                                    <xsl:choose>
                                        <xsl:when test="//PARAM[@name='day']">
                                            <input type="text" name="day" value="{//PARAM[@name='day']}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <input type="text" name="day" value="{//DATE[@is_current='yes']/@fulldate}" id="datepicker" onchange="cal.submit()" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </td>
                            <td>
                                <div style="padding-top: 5px">
                                    <select name="doctor" onchange="cal.submit()">
                                        <option value="">Все доктора</option>
                                        <xsl:for-each select="//DOCTOR">
                                            <option value="{@login}">
                                                <xsl:if test="//PARAM[@name='doctor'] = @login">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="@name"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding: 3px 6px 0px 0px; font-family: Verdana; font-size: 14px;">
                                Фильтр по фамилии пациента
                            </td>
                            <td>
                                <input type="text" name="f"/>
                                <input type="submit" value="Фильтровать"/>
                            </td>
                        </tr>
                    </table>
                </form>
                <div>
                    <table cellpadding="5px" cellspacing="0px" border="0px" width="100%">
                        <tr>
                            <td class="header" style="padding-left: 6px; width: 28px">№ п/п</td>
                            <td class="header" style="padding-left: 6px;">Доктор</td>
                            <td class="header" style="padding-left: 6px;">ФИО получателя государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">Дата рождения получателя государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">Домашний адрес получателя государственных услуг</td>
                            <td class="header" style="padding-left: 6px;">Дата оказания государственных услуг</td>
                        </tr>
                        <xsl:for-each select="//TALON">
                            <xsl:variable name="schedule" select="FIELD[@name='schedule']"/>
                            <tr class="table">
                                <td>
                                    <xsl:value-of select="FIELD[@name='tnum']"/>&#xA0;[<xsl:value-of select="$schedule"/>]<xsl:value-of select="FIELD[@name='online']"/>
                                </td>
                                <td>
                                    <xsl:variable name="doctor" select="FIELD[@name='login']"/>
                                    <a href="?doctor={$doctor}"><xsl:value-of select="//DOCTOR[@login=$doctor]/@name"/></a><BR/>
                                    Специальность:&#xA0;<xsl:variable name="spec" select="SCHEDULE/@spec"/><xsl:value-of select="//LIST[@id=$spec]/@value"/>
                                </td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='f']"/>&#xA0;
                                    <xsl:value-of select="FIELD[@name='i']"/>&#xA0;
                                    <xsl:value-of select="FIELD[@name='o']"/>&#xA0;
                                </td>
                                <td><xsl:value-of select="FIELD[@name='birth']"/></td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='addr']"/>
                                    <xsl:if test="FIELD[@name='phone'] != ''">
                                        (тел. <xsl:value-of select="FIELD[@name='phone']"/>)
                                    </xsl:if>
                                </td>
                                <td>
                                    <xsl:value-of select="FIELD[@name='time']"/>
                                    <div><xsl:value-of select="FIELD[@name='dday']"/></div>
                                </td>
                                <td><a href="#" onclick="window.open('/panel/registratura/printable?talon={@id}', 'Версия для печати')">Посмотреть талон</a></td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </div>
            </xsl:when>
            <xsl:when test="//PARAM[@name='action']='registratura/patients/report'">
                <form name="cal" action="" method="post">
                    <table>
                        <tr>
                            <td colspan="2">Количество записавшихся в текущем месяце:</td>
                        </tr>
                        <tr>
                            <td>В регистратуре: <xsl:value-of select="//STAT/@reg"/></td>
                            <td>Через сайт: <xsl:value-of select="//STAT/@online"/></td>
                        </tr>
                        <tr>
                            <td>
                                <div align="left" valign="top" style="padding: 3px 6px 0px 0px; font-family: Verdana; font-size: 14px;">
                                    Месяц работы:
                                </div>
                            </td>
                            <td>
                                <div style="padding-top: 4px">
                                    <xsl:choose>
                                        <xsl:when test="//PARAM[@name='month']">
                                            <input type="text" name="month" value="{//PARAM[@name='month']}" id="datepicker" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <input type="text" name="month" value="{//DATE[@is_current='yes']/@fulldate}" id="datepicker" style="height: 24px; width: 120px; border: 0px; font-size: 22px; color: #C01618"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </td>
                            <td>
                                <input type="submit" value="Сформировать"/>
                                <!--div style="padding-top: 5px">
                                    <select name="doctor" onchange="cal.submit()">
                                        <option value="">Все доктора</option>
                                        <xsl:for-each select="//DOCTOR">
                                            <option value="{@login}">
                                                <xsl:if test="//PARAM[@name='doctor'] = @login">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="@name"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>
                                </div-->
                            </td>
                        </tr>
                    </table>
                </form>
                <div>
                    <xsl:for-each select="//FILES/FILE">
                        <div>
                            <a href="{.}"><xsl:value-of select="."/></a>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>