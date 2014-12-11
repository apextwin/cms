<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output encoding="utf-8" cdata-section-elements="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template name="adduser">
        <form name="adduser" action="/panel/adduser" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="userlogin" class="col-sm-4 control-label">Логин</label>
                <div class="col-sm-8">
                    <input type="text" name="userlogin" id="userlogin" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="pass" class="col-sm-4 control-label">Пароль</label>
                <div class="col-sm-8">
                    <input type="password" name="pass" id="pass" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="pass2" class="col-sm-4 control-label">Повторить пароль</label>
                <div class="col-sm-8">
                    <input type="password" name="pass2" id="pass2" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Отображаемое имя</label>
                <div class="col-sm-8">
                    <input type="text" name="name" id="name" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="email" class="col-sm-4 control-label">email</label>
                <div class="col-sm-8">
                    <input type="text" name="email" id="email" class="form-control input-sm"/>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="adduser.submit(); window.reload()">Добавить</a>
            <a href="/panel/users" class="btn btn-default" data-dismiss="modal">Отмена</a>
        </div>
    </xsl:template>
    <xsl:template name="edituser">
        <form name="edituser" action="/panel/edituser" method="post" role="form" class="form-horizontal">
            <div class="form-group">
                <label for="userlogin" class="col-sm-4 control-label">Логин</label>
                <div class="col-sm-8">
                    <input type="text" name="userlogin" id="userlogin" class="form-control input-sm" disabled="disabled" value="{//USER/@login}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="pass" class="col-sm-4 control-label">Пароль</label>
                <div class="col-sm-8">
                    <input type="password" name="pass" id="pass" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="pass2" class="col-sm-4 control-label">Повторить пароль</label>
                <div class="col-sm-8">
                    <input type="password" name="pass2" id="pass2" class="form-control input-sm"/>
                </div>
            </div>
            <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Отображаемое имя</label>
                <div class="col-sm-8">
                    <input type="text" name="name" id="name" class="form-control input-sm" value="{//USER/@name}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="email" class="col-sm-4 control-label">email</label>
                <div class="col-sm-8">
                    <input type="text" name="email" id="email" class="form-control input-sm" value="{//USER/@email}"/>
                </div>
            </div>
        </form>
        <div class="modal-footer">
            <a href="#" class="btn btn-primary" onclick="edituser.submit(); window.reload()">Сохранить</a>
            <a href="/panel/users" class="btn btn-default" data-dismiss="modal">Отмена</a>
        </div>
    </xsl:template>
</xsl:stylesheet>