<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="html" indent="no" encoding="utf-8"/>
<xsl:template match="/DOCUMENT">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
	<link rel="stylesheet" type="text/css" href="/css/signin.css" />
    <link href="/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <div class="container">
      <form class="form-signin" role="form" method="POST">
        <h2 class="form-signin-heading" align="center">Авторизация</h2>
        <input type="login" name="login" class="form-control" placeholder="Имя пользователя" required="1" autofocus="1" style="margin-bottom: 10px"/>
        <input type="password" name="password" class="form-control" placeholder="Пароль" required="1" />
        <button class="btn btn-lg btn-primary btn-block" type="submit">Войти</button>
      </form>
      <xsl:value-of select="//ERROR"/>
    </div>
</body>
</html>
</xsl:template>
</xsl:stylesheet>