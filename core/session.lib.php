<?
    #Session library. version 1.0
    #error code s_
	class xpSession
	{
		var $hash;
		var $login;
		var $su;
		var $params;
		var $group;
		var $root;
        var $CH;

		function xpSession()
		{
			global $DB, $Processor, $cfg;
			$this->login = 'nobody';
			$this->group = array();
			$this->root = $cfg[root];
			$this->Expire();
			// regexp Для проверки сессии /^([0-9A-Z]{16})?$/
            $rs = $DB->Execute("SELECT * FROM T_SESSION WHERE session_hash=? LIMIT 0, 1", Array($_COOKIE[session_hash]));
            //Если кука установлена, и имеется хеш в базе
            if(!$rs->EOF)
            {	
                $this->hash = $_COOKIE[session_hash];		
    		    $this->login = $rs->fields[login];
    		    $rss = $DB->Execute("SELECT su FROM T_LOGIN WHERE login=? LIMIT 1", Array($this->login));
    		    $this->su = $rss->fields['su'];
    		    $rss->close();
    		    if($this->login != 'nobody')
    		    {
                    $rss = $DB->Execute("SELECT * FROM T_LOGIN_GROUP as a LEFT JOIN T_GROUP as b ON a.gid = b.gid WHERE a.login=?", Array($this->login));
                    while(!$rss->EOF)
                    {
                        $this->group[$rss->fields[gid]] = $rss->fields[groupname];
                        $rss->MoveNext();
                    }
                    $rss->close();
                }
                $this->params = unserialize($rs->fields[params]);
                
                $chars = "1234567890";
    			$i = 0;
    			$captcha = "";
    			while($i < 5)
    			{
    				$num = rand(1,strlen($chars));
    				$char = substr($chars,$num,1);
    				$captcha .= $char;
    				$i++;
    			}
                $this->CH = md5($cfg['sault'].$captcha);
                $this->params[captcha] = $captcha;
                
    			$rs->close();
    			$this->Save();
    		}
            else $this->Create();
            
            /*if($_POST['token'])
            {       
                $s = file_get_contents('http://ulogin.ru/token.php?token=' . $_POST['token'] . '&host=' . $_SERVER['HTTP_HOST']);
                $user = json_decode($s, true);
                /*
                    $user['network'] - соц. сеть, через которую авторизовался пользователь
                    $user['identity'] - уникальная строка определяющая конкретного пользователя соц. сети
                    $user['first_name'] - имя пользователя
                    $user['last_name'] - фамилия пользователя 
                /
                unset($user['access_token']);
                $params = serialize($user);
                $email = $user['email'];
                $login = $user['last_name']."_".$user['first_name']."@".$user['network'];
                $password = md5($user['last_name']."_".$user['first_name']."passwordsault235674516785425678");
                $rs = $DB->Execute("SELECT * FROM T_LOGIN WHERE login=? LIMIT 0, 1", Array($login));
                if($rs->EOF)
                {
                    $DB->Execute("INSERT INTO T_LOGIN (login, hash) VALUES (?, ?)", Array($login, $password));
                    $DB->Execute("INSERT INTO T_USERS (login, email, name, params) VALUES (?, ?, ?, ?)", Array($login, $login, $user['last_name']."_".$user['first_name'], $params));
                    $DB->Execute("INSERT INTO T_LOGIN_GROUP (login, gid) VALUES (?, 0)", Array($login));
                    $DB->Execute("INSERT INTO T_LOGIN_GROUP (login, gid) VALUES (?, 1)", Array($login));                    
                }
                $rs->close;
                if($_GET['node']) $url = "/".$Processor->Uri."?node=".$_GET[node];
                else $url = "/".$Processor->Uri;
                $this->Auth($login, $user['last_name']."_".$user['first_name']."passwordsault235674516785425678", $url);
            } */
            
            if($_POST[login] && $_POST[password])
            {
                if($_GET['node']) $url = "/".$Processor->Uri."?node=".$_GET[node];
                else $url = "/".$Processor->Uri;
                $this->Auth($_POST[login], $_POST[password], $url);
            }
            if($_GET[logout])
            {
                $this->SetLogin("nobody");
                header("Location: /");
            } 		
		}

		function Create()
		{
			global $DB;
			$chars = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890";
			$i = 0;
			$string = "";
			while($i < 16)
			{
				$num = rand(0,strlen($chars));
				$char = substr($chars,$num,1);
				$string .= $char;
				$i++;
			}
			$time = time();
			$ip = $_SERVER[REMOTE_ADDR];
            
            $chars = "QWERTYUIOPASDFGHJKLZXCVBNM";
			$i = 0;
			$captcha = "";
			while($i < 5)
			{
				$num = rand(1,strlen($chars));
				$char = substr($chars,$num,1);
				$captcha .= $char;
				$i++;
			}
            $this->CH = md5($cfg['sault'].$captcha);
            $this->params[captcha] = $captcha;            
            $DB->Execute("INSERT INTO T_SESSION (session_hash, time, ip, login, params) VALUES (?, ?, ?, ?, ?)", Array($string, $time, $ip, $this->login, serialize($this->params)));
			$this->hash = $string;
			$time = time()+(3600*12);
			setcookie("session_hash",$this->hash, $time);
		}

        function Auth($l, $p, $url)
        {
            global $DB, $Error;
            //авторизация
            $rs = $DB->Execute("SELECT * FROM T_LOGIN WHERE login=? LIMIT 0, 1", Array($l));
            if(!$rs->EOF)
            {
                if($rs->fields['hash'] == md5($p))
                {
                    $this->SetLogin($l, $url);
                    $this->su = $rs->fields['su'];
                }
                else $Error->is_error('s_2', 'Password wrong!');
            }
            else $Error->is_error('s_1', 'Login not exists!');
            $rs->close;
        }
        
		function SetLogin($login)
		{
			global $DB;
			$DB->Execute("UPDATE T_SESSION SET login=? WHERE session_hash=?", Array($login, $this->hash));
			$this->login = $login;
			$this->group = array();
			$rss = $DB->Execute("SELECT * FROM T_LOGIN_GROUP as a LEFT JOIN T_GROUP as b ON a.gid = b.gid WHERE a.login=? AND b.url != ''", Array($this->login));
			$login_url = $rss->fields[url];
            while(!$rss->EOF)
            {
                $this->group[] = $rss->fields[gid];
                $rss->MoveNext();
            }
            $rss->close();
            if($login_url != '')$url = $login_url;
			header("Location: ".$url);
		}

        function Save()
		{
			global $DB;
			$time = time()+(3600*12);
			$rs = $DB->Execute("UPDATE T_SESSION SET time=?, params=? WHERE session_hash=?",Array($time, serialize($this->params), $this->hash));
		}

		function Expire()
		{
			global $DB;
			$time = time() - (3600*12);
			$rs = $DB->Execute("SELECT * FROM T_SESSION WHERE time < ?", Array($time));
			if($rs)
            {
                $DB->Execute("DELETE FROM T_SESSION WHERE time < ?", Array($time));
			    $rs->close();
			}
		}

		function GetXML()
		{
		    global $DB;
			$xml = "<SESSION hash=\"{$this->hash}\" ch=\"{$this->CH}\" login=\"{$this->login}\">";
			if($this->login != "nobody")
			{
                $rs = $DB->Execute("SELECT * FROM T_USERS WHERE login=? LIMIT 1", Array($this->login));
                while(!$rs->EOF)
                {   
                    $xml .= "<USER";
                    foreach($rs->fields as $k => $v)
                    {
                        if(!is_integer($k) && $k != 'params')$xml.=" $k =\"$v\"";
                    }
                    $rss = $DB->Execute("SELECT count(*) FROM T_ORDER WHERE login=?", Array($this->login));
                    $xml .= " course_count=\"".$rss->fields["count(*)"]."\"";
                    $xml.="/>";
                    $rs->MoveNext();
                }
                $rs->close();
            }
            foreach($this->group as $k=> $v)$xml .= "<GROUP gid=\"$k\" name=\"$v\"/>";
            $xml .= "</SESSION>";			
			return $xml;
		}

		function Close()
		{
			global $DB;
			$DB->Execute("UPDATE T_SESSION SET params=? WHERE session_hash=?", Array(serialize($this->params), $this->hash));
		}
        function ClearParams()
		{
			global $DB;
			$DB->Execute("UPDATE T_SESSION SET params=? WHERE session_hash=?", Array('', $this->hash));
		}
	}
?>