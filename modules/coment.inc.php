<?
	class Coment extends Module
	{
		function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->Prefix = 'coment';
        } 
        
        function mail($type) {
            Global $cfg;
            $subject = "Новый комментарий на сайте ".$cfg[name];
			$headers = "From: Robot <robot@".$cfg[name].">\r\n";
			$headers.= "Content-Type: text/html; charset=utf-8; ";
			$headers .= "MIME-Version: 1.0 ";
            $msg = "Пользователь ".$_POST[name]."(".$type.") добавил новый комментарий (".$_POST[text]."), перейдите по ссылке: <a href='http://".$cfg[name]."/panel/coments'>http://".$cfg[name]."/panel/coments</a> (вы должны быть авторизованы) и нажмите на значок 'замка' для одобрения комментария.";
			$letter ="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body leftmargin=\"10\" topmargin=\"10\">".$msg."</body></html>";
			mail($cfg[email], $subject, $letter, $headers);
        }
        
		function GetXML()
		{
		    Global $DB, $Session, $cfg;
		    if($_POST[text])
		    {
                if($Session->login == 'nobody')
                {
                    if(md5($cfg['sault'].strtoupper($_POST[cc])) != $_POST[cchash])
                    {
                        //echo $_POST[cchash]."=====".;
                    	$xml .= "<MSG>Введён некорректный код проверки</MSG>";
                    }
                    else
                    {
                        $date = time();
                        $query = "INSERT INTO T_COMENT (node, name, email, date, text, moderated, ip, type) VALUES ('{$_POST[node]}', '{$_POST[name]}', '{$_POST[email]}', '{$date}', '{$_POST[text]}', '0', '{$_SERVER['REMOTE_ADDR']}', 'anonim')";
                        $DB->Execute($query); 
                        $xml .= "<MSG type='coment'>Благодарим Вас! После проверки администрацией Ваш комментарий станет доступен.</MSG>";  
                        $this->mail("anonim");                  
                    }
                }
                else
                {
    		        $date = time();
                    $query = "INSERT INTO T_COMENT (node, login, date, text, moderated, ip, type) VALUES ('{$_POST[node]}', '{$Session->login}', '{$date}', '{$_POST[text]}', '0', '{$_SERVER['REMOTE_ADDR']}', 'reg')";
                    $DB->Execute($query); 
                    $xml .= "<MSG type='coment'>Благодарим Вас! После проверки администрацией Ваш комментарий станет доступен.</MSG>";
                    $this->mail("reg");
                }   
            }
            if($_GET[node])
            {
                $node = $_GET[node];
                $query = "SELECT a.coment as coment, a.node as node, a.date as date, a.text as text, a.name as comentname, a.type as type,
                b.login as login, b.name as username 
                FROM T_COMENT as a LEFT JOIN T_USERS as b ON a.login = b.login WHERE a.moderated = 1 and a.node = ".$node." ORDER BY a.date ASC";
                $rs = $DB->Execute($query);
                $xml .= "<COMENTS node='{$node}'>";
                while(!$rs->EOF)
                {
                    $date = date("d.m.Y в H:i:s", $rs->fields[date]);
                    /*$xml .= "<COMENT coment='{$rs->fields[coment]}' node='{$rs->fields[node]}' login='{$rs->fields[login]}' name='{$rs->fields[comentname]}' email='{$rs->fields[email]}' date='{$date}'>";
                    $xml .= $rs->fields[text];
                    $xml .= "</COMENT>";*/
                    $xml .= "<COMENT ";
                    foreach($rs->fields as $k=>$v)if($k!='text')$k == 'date' ? $xml .= $k."=\"".$date."\" " : $xml .= $k."=\"".$v."\" ";
                    $xml .= ">";
                    $xml .= $rs->fields[text];
                    $xml .= "</COMENT>";
                    $rs->MoveNext();
                }
                $xml .= "</COMENTS>";
            }
			return $xml;
		}
	}
?>