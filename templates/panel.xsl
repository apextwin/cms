<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
<xsl:template match="/DOCUMENT">
<html>
<head>
	<title>панель управления</title>
        <xsl:text disable-output-escaping="yes"><![CDATA[
            <script src="/js/jquery.js" type="text/javascript" charset="utf-8"></script>
            <script src="/js/jquery.history.js" type="text/javascript" charset="utf-8"></script>
            <script src="/js/jquery-ui-1.10.4.custom.min.js" type="text/javascript" charset="utf-8"></script>
            <script src="/ckeditor/ckeditor.js" type="text/javascript" charset="utf-8"></script>
            
            <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <link href="/css/bootstrap.min.css" rel="stylesheet" />
            <script type="text/javascript" src="/js/bootstrap.min.js"></script>
            <link href="/css/font-awesome.min.css" rel="stylesheet" />
            
            <link rel="stylesheet" type="text/css" href="/css/panel.css" />
            <script src="/js/panel.js" type="text/javascript" charset="utf-8"></script>
            ]]>
        </xsl:text>
        <script language="javascript">
        	var sections = new Array();
        	sections[0] = '';
        	<xsl:for-each select="//SECTION">sections[<xsl:value-of select="@realm"/>] = '<xsl:value-of select="@name"/>';</xsl:for-each>
        	function ChangeParent(f)
        	{
        		var parent = f.parent.value;
                if(f.name.value != '')
        		{
                    fullname = f.name.value;
                    pos = fullname.lastIndexOf("/");
                    rname = fullname.substr(pos+1);
                    if(parent == 1000) f.name.value = rname;
                    else f.name.value = sections[parent]+'/'+rname;

                }
                else
                {
            		if(parent == 1000)f.name.value = '';
            		else f.name.value = sections[parent]+'/';
            	}
        	}  
            
            
        </script>
</head>
<body>
<xsl:choose>
    <xsl:when test="//ERROR">
        <xsl:if test="//ERROR">
            <xsl:for-each select="//ERRORS">
                <xsl:apply-templates />
            </xsl:for-each>
        </xsl:if>
    </xsl:when>
    <xsl:otherwise>
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
          <div class="container-fluid">
            <div class="navbar-header" style="padding-top: 5px">            
                <a href="/panel"><img src="/i/logo.jpg" height="40px"/></a>
            </div>
            <div class="navbar-collapse collapse">
              <ul class="nav navbar-nav navbar-right">
                <li><a href="/" target="blank"><i class="fa fa-home fa-lg"/>&#xA0;Просмотр</a></li>
                <li><a href="#"><i class="fa fa-user fa-lg"/>&#xA0;<xsl:value-of select="//SESSION/@login"/></a></li>
                <li>
                    <div class="dropdown dropdown-inverse" style="margin-top: 8px">
                        <a class="btn btn-link dropdown-toggle dropdown-inverse" type="button" id="dropdownMenu1" data-toggle="dropdown">
                            <i class="fa fa-cogs fa-lg"/>&#xA0;Возможности
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                            <li role="presentation"><a href="/panel/constructor"><i class="fa fa-wrench fa-lg"/>&#xA0;Конструктор</a></li> 
                            <li role="presentation"><a href="/panel/lists"><i class="fa fa-list-alt fa-lg"/>&#xA0;Списки</a></li>
                            <li role="presentation"><a href="/panel/users"><i class="fa fa-group fa-lg"/>&#xA0;Пользователи</a></li>
                            <li role="presentation"><a href="/panel/groups"><i class="fa fa-key fa-lg"/>&#xA0;Группы доступа</a></li>
                            <li role="presentation"><a href="/panel/clear_cache"><i class="fa fa-trash-o fa-lg"/>&#xA0;Очистить кеш</a></li>
                            <li role="presentation"><a href="/panel/include"><i class="fa fa-puzzle-piece fa-lg"/>&#xA0;Модули</a></li>
                            <li role="presentation"><a href="/panel/config"><i class="fa fa-gear fa-lg"/>&#xA0;Настройка</a></li>
                        </ul>
                    </div>
                </li>
                <li>
                    <div class="dropdown dropdown-inverse" style="margin-top: 8px">
                        <a class="btn btn-link dropdown-toggle dropdown-inverse" type="button" id="dropdownMenu1" data-toggle="dropdown">
                            <i class="fa fa-puzzle-piece fa-lg"/>&#xA0;Модули
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                            <xsl:for-each select="/DOCUMENT/INCLUDES/INCLUDE">
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="/panel/module?module={@include}"><xsl:value-of select="@title"/></a></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </li>
                <li><a href="?logout=1"><i class="fa fa-sign-out fa-lg"/>&#xA0;Выход</a></li>
              </ul>
            </div>
          </div>
        </nav>
        <div class="container-fluid">
            <div class="row">           
                <div class="col-sm-3 col-md-3 sidebar">
                    <h4>Разделы сайта</h4>
                    <div id="tree">
                    </div>
                    <xsl:apply-templates select="/DOCUMENT/SECTION"/>
                </div>
            </div>
        </div>
        <div class="col-sm-9 col-sm-offset-0 col-md-9 col-md-offset-3 main">
            <xsl:choose>
                <xsl:when test="//REALM/@name='panel/addrealm'">
                    <xsl:call-template name="addrealm"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editrealm'">
                    <xsl:call-template name="editrealm"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/adduser'">
                    <xsl:call-template name="adduser"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/edituser'">
                    <xsl:call-template name="edituser"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/addnode'">
                    <xsl:call-template name="addnode"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editnode'">
                    <xsl:call-template name="editnode"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/insertinclude'">
                    <xsl:call-template name="insertinclude"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editinclude'">
                    <xsl:call-template name="editinclude"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/addlist'">
                    <xsl:call-template name="addlist"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/addgroup'">
                    <xsl:call-template name="addgroup"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editgroup'">
                    <xsl:call-template name="editgroup"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editusergroup'">
                    <xsl:call-template name="editusergroup"/>
                </xsl:when>
                <xsl:when test="//REALM[@name='panel'] and //PARAM[@name='parent']">
                    <xsl:variable name="parent" select="//PARAM[@name='parent']"/>
                    <div class="well well-sm">
                        <div class="alert alert-info">
                        Раздел:&#xA0;<b><xsl:value-of select="//SECTION[@realm=$parent]/@name"/></b>&#xA0;(<xsl:value-of select="//SECTION[@realm=$parent]/@title"/>)
                        ID:&#xA0;<b><xsl:value-of select="$parent"/></b>
                        </div>
                        <a href="/panel/editrealm?realm={$parent}" class="btn btn-info openModal"><i class="fa fa-pencil-square-o fa-lg"/>&#xA0;Редактировать</a>&#xA0;
                        <xsl:for-each select="//INCLUDES_REALM/INCLUDE">
                            <xsl:choose>
                                <xsl:when test="@realm = $parent">
                                    <a href="/panel/include?include={@include}" class="btn btn-success"><i class="fa fa-puzzle-piece fa-lg"/>&#xA0;<xsl:value-of select="@title"/></a>&#xA0;
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="/panel/include?include={@include}" class="btn btn-warning"><i class="fa fa-puzzle-piece fa-lg"/>&#xA0;<xsl:value-of select="@title"/></a>&#xA0;
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </div>
                    <div class="realms">
                        <div style="margin: 10px 0px">
                            <a href="/panel/addrealm?parent={$parent}" class="btn btn-primary openModal">
                                <i class="fa fa-plus fa-lg"/>&#xA0;Добавить раздел
                            </a>&#xA0;
                            <div id="hide" style="display: inline-block">
                                <a href="#" class="btn" id="hide"><i class="fa fa-arrow-up fa-lg"/>&#xA0;Скрыть разделы</a>
                            </div>
                        </div>
                        <div id="realms">
                            <form name="realm" action="/panel/deleterealm" method="post">
                            <input type="hidden" name="parent" value="{$parent}"/>
                                <table width="100%" border="0px" cellpadding="0px" cellspacing="0px" class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th width="32px" align="center">
                                                <input type="checkbox" name="all" onclick="checkall(this.form.elements,this)"/>
                                            </th>
                                            <th width="64px">id</th>
                                            <th>Заголовок раздела</th>
                                            <th>Имя раздела</th>
                                            <th>Вес</th>
                                            <th>Действия</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <xsl:for-each select="//SECTION[@parent=$parent]">
                                        <tr>
                                            <td align="center">
                                                <input type="checkbox" name="realm[]" value="{@realm}"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="@realm"/>
                                            </td>
                                            <td>
                                                <a href="/panel?parent={@realm}"><xsl:value-of select="@title"/></a>
                                            </td>
                                            <td>
                                                <a href="/panel/editrealm?realm={@realm}"><xsl:value-of select="@name"/></a>
                                            </td>
                                            <td>
                                                <xsl:value-of select="@weight"/>
                                            </td>
                                            <td>
                                                <a href="/panel/editrealm?realm={@realm}" class="openModal"><i class="fa fa-pencil-square-o"/>&#xA0;Редактировать</a>&#xA0;&#xA0;
                                                <a href="/panel/editrealmgroup?realm={@realm}"><i class="fa fa-key"/>&#xA0;Доступ</a>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                    </tbody>
                                </table>
                                <div style="margin: 10px 0px">
                                    <a href="#" class="btn btn-danger" id="hide" onclick="realm.submit()"><i class="fa fa-trash-o fa-lg"/>&#xA0;Удалить</a>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="nodes">
                        <div class="dropdown">
                            <button class="btn btn-default dropdown-toggle" type="button" id="addnode" data-toggle="dropdown">
                                <i class="fa fa-plus fa-lg"/>&#xA0;Добавить документ
                            </button>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="addnode">                          
                                <xsl:for-each select="//DATATYPES/DATATYPE">
                                    <li role="presentation">
                                        <a href="/panel/addnode?parent={$parent}&amp;datatype={@name}" class="openModal-lg" role="menuitem" tabindex="-1" modal-title="Добавить '{@caption}'"><i class="fa {@icon}"/>&#xA0;<xsl:value-of select="@caption"/></a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                        <form name="node" action="panel/deletenode" method="post">
                            <input type="hidden" name="parent" value="{$parent}"/>
                            <table width="100%" border="0px" cellpadding="0px" cellspacing="0px" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th><input type="checkbox" name="all" onclick="checkall(this.form.elements,this)"/></th>
                                        <th>id</th>
                                        <th>Дата добавления</th>
                                        <th>Имя элемента</th>
                                        <th>Заголовок</th>
                                        <th>Тип</th>
                                        <th width="150px">Действия</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <xsl:for-each select="//NODE">
                                    <tr>
                                        <xsl:if test="@disabled=1">
                                            <xsl:attribute name="class">error</xsl:attribute>
                                        </xsl:if>
                                        <td>
                                            <input type="checkbox" name="node[]" value="{@node}"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="@node"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="DATATYPE/FIELD[@name='datetime']/DATA"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="NAME"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="DATATYPE/FIELD[@name='title']/DATA"/>
                                        </td>
                                        <td>
                                            <i class="fa {DATATYPE/@icon}"/>
                                            <xsl:value-of select="DATATYPE/@caption"/>
                                        </td>
                                        <td>
                                            <a href="/panel/editnode?node={@node}" class="openModal-lg"><i class="fa fa-pencil-square-o"/>&#xA0;Редактировать</a>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                                </tbody>
                            </table>
                            <div style="margin: 10px 0px">
                                <a href="#" class="btn btn-danger" id="hide" onclick="node.submit()"><i class="fa fa-trash-o fa-lg"/>&#xA0;Удалить</a>
                            </div>
                            <div>
                                <xsl:apply-templates select="//CONTENT/PAGING"/>
                            </div>
                        </form>
                    </div>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/lists'">
                    <h4><xsl:value-of select="//REALM/TITLE"/></h4>
                    <a href="/panel/addlist" class="btn btn-primary openModal"><i class="fa fa-plus-square-o"/>&#xA0;Добавить список</a>
                    <xsl:for-each select="/DOCUMENT/LIST">
                        <xsl:apply-templates />
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/users'">
                    <h4><xsl:value-of select="//REALM/TITLE"/></h4>
                    <a href="/panel/adduser" class="btn btn-primary openModal"><i class="fa fa-plus fa-lg"/>&#xA0;Добавить пользователя</a>
                    <table width="100%" border="0px" cellpadding="0px" cellspacing="0px" class="table table table-striped table-hover" style="margin-top: 20px">
                        <thead>
                        <tr>
                            <th>Id</th>
                            <th>Login</th>
                            <th>Отображаемое имя</th>
                            <th>Email</th>
                            <th>Действия</th>
                        </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//USERS/USER">
                                <tr>
                                    <td><xsl:value-of select="@user"/></td>
                                    <td><xsl:value-of select="@login"/></td>
                                    <td><xsl:value-of select="@name"/></td>
                                    <td><xsl:value-of select="@email"/></td>
                                    <td>
                                        <a href="/panel/edituser?userlogin={@login}" class="openModal" modal-title="Пользователь {@login}"><i class="fa fa-edit"/></a>&#xA0;
                                        <a href="/panel/editusergroup?userlogin={@login}" class="openModal" modal-title="Группы пользователя {@login}"><i class="fa fa-key"/></a>&#xA0;
                                        <a href="/panel/deleteuser?userlogin={@login}"><i class="fa fa-trash-o"/>&#xA0;</a>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/groups'">
                    <a href="/panel/addgroup" class="btn btn-primary openModal"><i class="fa fa-plus-square-o"/>&#xA0;Добавить группу</a>
                    <table width="100%" border="0px" cellpadding="0px" cellspacing="0px" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th width="32px" align="center">
                                    <input type="checkbox" name="all" onclick="checkall(this.form.elements,this)"/>
                                </th>
                                <th width="64px">gid</th>
                                <th>Имя группы</th>
                                <th>Url</th>
                                <th>Действия</th>
                            </tr>
                        </thead>
                        <tbody>
                        <xsl:for-each select="/DOCUMENT/GROUPS/GROUPDATA">
                            <tr>
                                <td align="center">
                                    <input type="checkbox" name="gid[]" value="{@gid}"/>
                                </td>
                                <td>
                                    <xsl:value-of select="@gid"/>
                                </td>
                                <td>
                                    <xsl:value-of select="."/>
                                </td>
                                <td>
                                    <xsl:value-of select="@url"/>
                                </td>
                                <td>
                                    <a href="/panel/editgroup?gid={@gid}" class="openModal"><i class="fa fa-pencil-square-o"/>&#xA0;Редактировать</a>&#xA0;
                                    <a href="/panel/deletegroup?gid={@gid}"><i class="fa fa-times"/>&#xA0;Удалить</a>
                                </td>
                            </tr>
                        </xsl:for-each>
                        </tbody>
                    </table>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/editrealmgroup'">
                    <xsl:variable name="realm" select="//PARAM[@name='realm']"/>
                    <div class="realm_descr">
                        <h2>Редактирование групп доступа</h2>
                        Раздел:&#xA0;<b><xsl:value-of select="//SECTION[@realm=$realm]/@name"/></b>&#xA0;(<xsl:value-of select="//SECTION[@realm=$realm]/@title"/>)
                        <br/><br/>
                        ID:&#xA0;<b><xsl:value-of select="$realm"/></b>
                        <br/><br/>
                        <a href="/panel/editrealm?realm={$realm}"><img src="/i/edit.png" width="16" height="16"/>&#xA0;Редактировать</a>
                    </div>
                    <form name="/editrealmgroup" method="post">
                        <input type="hidden" name="realm" value="{$realm}"/>
                        <xsl:for-each select="/DOCUMENT/GROUPS">
                            <xsl:apply-templates />
                        </xsl:for-each>
                        <input type="submit"/>
                    </form>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/config'">
                    <h4><xsl:value-of select="//REALM/TITLE"/></h4>
                	<table cellspacing="2" cellpadding="0" class="table table-striped table-hover">
                    <thead>
                    	<tr>
                    		<th width="30%">Переменная</th>
                            <th width="40%">Значение</th>
                    		<th></th>
                    	</tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//VARS/VAR">
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
                                                <form method="post" name="editval" action="/panel/config?action=editval" class="form form-horizontal">
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
                                <a href="/panel/config?action=delval&amp;key={@name}" class="btn btn-danger btn-xs">
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
                                    <h4 class="modal-title" id="addanswerLabel"><xsl:value-of select="//REALM/TITLE"/></h4>
                                </div>
                                <div class="modal-body">
                                    <form method="post" name="addval" action="/panel/config?action=addval" class="form form-horizontal">
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
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/include'">
                    <h4>Модули сайта</h4>
                    <a href="/panel/insertinclude" class="btn btn-success openModal"><i class="fa fa-plus"/>&#xA0;Добавить модуль</a>
                    <form name="node" action="panel/deleteinclude" method="post">
                    <table width="100%" class="table table-striped table-hover">
                        <thead>
                        <tr>
                            <th width="32px">
                                <input type="checkbox" name="all" onclick="checkall(this.form.elements,this)"/>
                            </th>
                            <th width="30px">id</th>
                            <th>Название</th>
                            <th>Модуль</th>
                            <th>Класс</th>
                            <th>Действия</th>
                        </tr>
                        </thead>
                        <tbody>
                        <xsl:for-each select="//INCLUDE">
                            <tr>
                                <td>
                                    <input type="checkbox" name="include[]" value="{@include}"/>
                                </td>
                                <td>
                                    <xsl:value-of select="@include"/>
                                </td>
                                <td>
                                    <a href="/panel/editinclude?include={@include}" class="openModal" modal-title="Редактировать модуль {@title}"><xsl:value-of select="@title"/></a>
                                </td>
                                <td>
                                    <a href="/panel/editinclude?include={@include}" class="openModal" modal-title="Редактировать модуль {@title}"><xsl:value-of select="@module"/></a>
                                </td>
                                <td>
                                    <xsl:value-of select="@class"/>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </xsl:for-each>
                        </tbody>
                    </table>
                    <input type="submit" class="btn btn-danger" value="Удалить выделенные модули"/>
                    </form>
                </xsl:when>
                <!--xsl:when test="//REALM/@name='panel/module'"-->
                <xsl:when test="contains(REALM/@name, 'panel/module')">
                    <xsl:if test="//PARAM[@name='module']">
                        <xsl:choose>
                            <xsl:when test="/DOCUMENT/MODULE/PANELXML">
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="active"><a href="#settings" role="tab" data-toggle="tab">Управление</a></li>
                                    <li><a href="#vars" role="tab" data-toggle="tab">Переменные</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div id="vars" class="tab-pane">
                                        <xsl:call-template name="config"/>
                                    </div>
                                    <div id="settings" class="tab-pane active">
                                        <xsl:apply-templates select="/DOCUMENT/MODULE/PANELXML"/>
                                    </div>
                                </div>
                            </xsl:when>
                            <xsl:otherwise>
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="active"><a href="#vars" role="tab" data-toggle="tab">Переменные</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div id="vars" class="tab-pane active">
                                        <xsl:call-template name="config"/>
                                    </div>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/constructor'">
                    <div class="row">
                        <div class="col-md-6 workzone" style="height: 500px">
                        </div>
                        <div class="col-md-6">
                            <div class="fields">
                                <div class="item original" id="string">
                                    <div class="type">string</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="string" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Строка" class="attr"/></div>           
                                </div>
                                <div class="item original" id="text">
                                    <div class="type">text</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="text" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Длинный текст" class="attr"/></div>           
                                </div>
                                <div class="item original" id="datetime">
                                    <div class="type">datetime</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="datetime" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Дата" class="attr"/></div>
                                    <div class="name">Формат: <input type="text" name="caption" value="d.m.Y" class="attr"/></div>           
                                </div>
                                <div class="item original" id="numeric">
                                    <div class="type">numeric</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="numeric" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Число" class="attr"/></div>
                                    <div class="name">Единица измерения: <input type="text" name="unit" value="" class="attr"/></div>           
                                </div>
                                <div class="item original" id="image">
                                    <div class="type">image</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="image" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Изображение" class="attr"/></div>           
                                </div>
                                <div class="item original" id="file">
                                    <div class="type">file</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="file" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Файл" class="attr"/></div>           
                                </div>
                                <div class="item original" id="list">
                                    <div class="type">list</div>
                                    <div class="name">Имя поля: <input type="text" name="name" value="list" class="attr"/></div>
                                    <div class="name">Заголовок: <input type="text" name="caption" value="Список выбора" class="attr"/></div>
                                    <div class="name">Корень списка: <input type="text" name="root" value="1" class="attr"/></div>           
                                </div>
                            </div>
                        </div>
                    </div>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/price'">
                    <a href="/panel/loadprice">Загрузить прайс</a>
                    <table cellpadding="0px" cellspacing="0px" border="1px">
                        <tr>
                            <td class="header">#</td>
                            <td class="header" width="260px">Заголовок</td>
                            <td class="header">Внешний ключ</td>
                            <td class="header">Раздел</td>
                            <td class="header" width="80px">Кол-во</td>
                            <td class="header" width="80px">Цена1</td>
                            <!--td class="header" width="80px">Цена2</td>
                            <td class="header" width="80px">Цена3</td-->
                            <td class="header" width="40px"></td>
                        </tr>
                        <xsl:for-each select="//PRICELIST/PRICE">
                            <tr class="price-string" data-id="{@node}-{@field}">
                                <td style="padding: 5px 0px"><xsl:value-of select="@node"/></td>
                                <td><xsl:value-of select="."/></td>
                                <td width="80px" class="extkey"><xsl:value-of select="@extkey"/></td>
                                <td>
                                    <xsl:variable name="rlm" select="@realm"/>
                                    <a href="/{//SECTION[@realm=$rlm]/@name}"><xsl:value-of select="//SECTION[@realm=$rlm]/@title"/></a>
                                </td>
                                <td class="count"><xsl:value-of select="@count"/></td>
                                <td class="price1"><xsl:value-of select="@price1"/></td>
                                <!--td class="price2"><xsl:value-of select="@price2"/></td>
                                <td class="price3"><xsl:value-of select="@price3"/></td-->
                                <td></td>
                            </tr>
                            <tr class="price-edit" id="{@node}-{@field}">
                                <td>
                                    <xsl:value-of select="@node"/>
                                    <input type="hidden" name="node" value="{@node}"/>
                                    <input type="hidden" name="field" value="{@field}"/>
                                </td>
                                <td><xsl:value-of select="."/></td>
                                <td>
                                    <input type="text" name="extkey" value="{@extkey}"/>
                                </td>
                                <td>
                                    <xsl:variable name="rlm" select="@realm"/>
                                    <a href="/{//SECTION[@realm=$rlm]/@name}"><xsl:value-of select="//SECTION[@realm=$rlm]/@title"/></a>
                                </td>
                                <td><input type="text" name="count" value="{@count}"/></td>
                                <td><input type="text" name="price1" value="{@price1}"/></td>
                                <!--td><input type="text" name="price2" value="{@price2}"/></td>
                                <td><input type="text" name="price3" value="{@price3}"/></td-->
                                <td align="center">
                                    <img src="/i/check.png" width="16px" class="save-form" data-id="{@node}-{@field}"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                    <xsl:apply-templates select="//PRICELIST/PAGING"/>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel/loadprice'">
                    <form name="loadprice" class="nodeform" action="/panel/loadprice" method="post" enctype="multipart/form-data">
                        <input type="file" name="price"/>
                        <input type="submit"/>
                    </form>
                </xsl:when>
                <xsl:when test="//REALM/@name='panel'">
                    <a class="btn btn-default btn-lg col-md-2" href="/panel?parent=1000" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-list-alt fa-lg" style="font-size: 62px;"/></div>Разделы сайта
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/constructor" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-wrench fa-lg" style="font-size: 62px;"/></div>Конструктор
                    </a> 
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/lists" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-list-alt fa-lg" style="font-size: 62px;"/></div>Списки
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/users" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-group fa-lg" style="font-size: 62px;"/></div>Пользователи
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/groups" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-key fa-lg" style="font-size: 62px;"/></div>Группы доступа
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/clear_cache" style="margin: 0px 10px 10px 0px">
                        <div style="margin: 10px 0px"><i class="fa fa-trash-o fa-lg" style="font-size: 62px;"/></div>Очистить кеш
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/include" style="margin: 0px 10px 10px 0px">    
                        <div style="margin: 10px 0px"><i class="fa fa-puzzle-piece fa-lg" style="font-size: 62px;"/></div>Модули
                    </a>
                    <a class="btn btn-default btn-lg col-md-2" href="/panel/config" style="margin: 0px 10px 10px 0px"> 
                        <div style="margin: 10px 0px"><i class="fa fa-gear fa-lg" style="font-size: 62px;"/></div>Настройка
                    </a>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:otherwise>
</xsl:choose>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"><i class="fa fa-times"/></button>
        <h4 class="modal-title" id="myModalLabel"></h4>
      </div>
      <div class="modal-body"></div>
      <!--
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
      -->
    </div>
  </div>
</div>
</body>
</html>
</xsl:template>
<xsl:template match="GROUP">
    <div class="group">
        <input type="checkbox" name="group[]" value="{@gid}">
            <xsl:if test="@selected = '1'">
                <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
        </input>
        <xsl:value-of select="."/>(gid =<xsl:value-of select="@gid"/>)
    </div>
</xsl:template>
<xsl:template match="ERROR">
    <div class="error">
        <xsl:value-of select="."/>(error code <xsl:value-of select="@code"/>)
    </div>
</xsl:template>
<xsl:template match="SECTION">
    <xsl:variable name="cr" select="//PARAM[@name='parent']"/>    
    <xsl:choose>
        <xsl:when test="SECTION">
            <xsl:choose>
                <xsl:when test="contains(//SECTION[@realm=$cr]/@name, @name) or @realm='1000'">
                    <i class="fa fa-minus-square fa-lg arrow" data-target="{@realm}"/>
                </xsl:when>
                <xsl:otherwise>
                    <i class="fa fa-plus-square fa-lg arrow" data-target="{@realm}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <div class="arrow"/>
        </xsl:otherwise>
    </xsl:choose>
    <a href="/panel?parent={@realm}">
        <xsl:value-of select="@title"/>
    </a>
    <br/>
    <xsl:if test="SECTION">
        <div id="{@realm}" style="padding-left: 12px">
            <xsl:choose>
                <xsl:when test="contains(//SECTION[@realm=$cr]/@name, @name) or @realm='1000'">
                    <xsl:attribute name="class"></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">cl</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="SECTION" />
        </div>
    </xsl:if>
</xsl:template>
<xsl:template match="LIST">
    <div style="padding: 10px 20px">
        <xsl:choose>
            <xsl:when test="LIST">
                <i class="fa fa-plus-square fa-lg arrow" data-target="{@id}"/>
            </xsl:when>
            <xsl:otherwise>
                <i class="fa" data-target="{@id}"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="@value"/>(<xsl:value-of select="@id"/>)&#xA0;<a href="/panel/addlist?list={@id}" class="openModal" modal-title="Добавить список"><i class="fa fa-plus-square-o"/></a>&#xA0;
        <xsl:if test="not(LIST/LIST)">
            <a href="/panel/deletelist?list={@id}"><i class="fa fa-times"/></a>
        </xsl:if>
        <xsl:if test="LIST">
            <div id="{@id}" style="padding-left: 12px" class="cl">
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </div>
</xsl:template>
<xsl:template match="PAGING">
	<xsl:variable name="page" select="@page"/>
	<xsl:variable name="realm" select="//REALM/@name"/>
	<xsl:variable name="params" select="count(//PARAM)"/>
	<xsl:variable name="param">&amp;<xsl:for-each select="//PARAM[@name != 'page']"><xsl:value-of select="@name"/>=<xsl:value-of select="."/><xsl:if test="not(position() = $params)">&amp;</xsl:if></xsl:for-each></xsl:variable>
	<!--br/>
	&#xA0;<div onclick="window.location.href='{$href}?page={FIRST/@page}{$param}';" class="button">
		<xsl:if test="not(FIRST)"><xsl:attribute name="style">display: none</xsl:attribute></xsl:if>
		первая
	</div>
	&#xA0;<div onclick="window.location.href='{$href}?page={PREV/@page}{$param}';" class="button">
		<xsl:if test="not(PREV)"><xsl:attribute name="style">display: none</xsl:attribute></xsl:if>
		&lt;&lt;
	</div-->
        Страницы:
    	<xsl:for-each select="PAGE">
    		<xsl:if test="@number = $page">&#xA0;<b class="page"><xsl:value-of select="@number"/></b>&#xA0;</xsl:if>
    		<xsl:if test="not(@number = $page)">&#xA0;<a class="page" href="/{$realm}?page={@number}{$param}"><xsl:value-of select="@number"/></a>&#xA0;</xsl:if>
    	</xsl:for-each>
	<!--&#xA0;из&#xA0;<xsl:value-of select="@pages"/->

	&#xA0;<div onclick="window.location.href='{$href}?page={NEXT/@page}{$param}';" class="button">
		<xsl:if test="not(NEXT)"><xsl:attribute name="style">display: none</xsl:attribute></xsl:if>
		&gt;&gt;
	</div>
	&#xA0;<div onclick="window.location.href='{$href}?page={LAST/@page}{$param}';" class="button">
		<xsl:if test="not(LAST)"><xsl:attribute name="style">display: none</xsl:attribute></xsl:if>
		последняя
	</div-->
</xsl:template>
</xsl:stylesheet>