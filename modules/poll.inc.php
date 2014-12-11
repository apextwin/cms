<?
	class Poll extends Module
	{   
        function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'poll';
        } 
        function GetPanelXML()
        {
            Global $DB, $Processor, $CGI, $cfg, $Session;  
            $xml .= parent::GetPanelXML();
            $xml .= "<PANELXML ns=\"".$this->ns."\">";
            switch($_GET['action'])
            {
                case 'addpoll': 
                    $DB->Execute("UPDATE T_POLL SET active = 0 WHERE active = 1 AND lang=?", $_POST['lang']);
                    $DB->Execute("INSERT INTO T_POLL (question, active, lang) VALUES (?, ?, ?)", Array($_POST['question'], $_POST['active'], $_POST['lang']));
                    header("Location: /panel/module?module=".$_GET[module]."#settings");
                break;
                case 'addanswer':
                    $DB->Execute("INSERT INTO T_ANSWER (poll, title) VALUES (?, ?)", Array($_POST['poll'], $_POST['title']));
                    header("Location: /panel/module?module=".$_GET[module]."&poll=".$_POST[poll]."#settings");
                break;
                case 'deleteanswer':
                    $DB->Execute("DELETE FROM T_ANSWER WHERE answer=?", Array($_GET['answer']));
                    header("Location: /panel/module?module=".$_GET[module]."&poll=".$_GET[poll]."#settings");
                break;    
                case 'deletepoll':
                    $DB->Execute("DELETE FROM T_POLL WHERE poll=?", Array($_GET['poll']));
                    $DB->Execute("DELETE FROM T_ANSWER WHERE poll=?", Array($_GET['poll']));
                    header("Location: /panel/module?module=".$_GET[module]."#settings");
                break;
                default:
                    if($_GET[poll])
                    {
                        $rs = $DB->Execute("SELECT * FROM T_POLL WHERE poll=?", Array($_GET[poll]));
                        $xml .= "<POLLS>";
                        while(!$rs->EOF)
                        {
                            $xml .= "<ROW pk=\"{$rs->fields[poll]}\">";
                            foreach($rs->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                            $xml .= "</ROW>";
                            $rs->MoveNext();
                        }
                        $xml .= "</POLLS>";
                        $rs->close();
                        
                        $rs = $DB->Execute("SELECT * FROM T_ANSWER WHERE poll=?", Array($_GET[poll]));
                        $xml .= "<ANSWERS>";
                        while(!$rs->EOF)
                        {
                            $xml .= "<ROW pk=\"{$rs->fields[answer]}\">";
                            foreach($rs->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                            $xml .= "</ROW>";
                            $rs->MoveNext();
                        }
                        $xml .= "</ANSWERS>";
                        $rs->close();    
                    }
                    else
                    {
                        $rs = $DB->Execute("SELECT * FROM T_POLL");
                        $xml .= "<POLLS>";
                        while(!$rs->EOF)
                        {
                            $xml .= "<ROW pk=\"{$rs->fields[poll]}\">";
                            foreach($rs->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                            $xml .= "</ROW>";
                            $rs->MoveNext();
                        }
                        $xml .= "</POLLS>";
                        $rs->close();
                    }                                     
                break;
            }
            $xml .= "</PANELXML>";
            return $xml;     
        }
        
		function GetXML()
		{
		    Global $DB, $Processor, $CGI, $cfg, $Session;
            $uri = $Processor->Uri;
            $lang = substr($uri, 0, 2);
		    if($_POST['answer'])
            {
                if(settype($_POST['answer'], "integer"))
                {
                    $answer = $_POST['answer'];
                    $rs = $DB->Execute("SELECT * FROM T_ANSWER WHERE answer=\"$answer\"");
                    $poll = $rs->fields['poll'];
                    $rss = $DB->Execute("SELECT * FROM T_POLL WHERE poll=\"$poll\"");
                    $answer_count = $rs->fields['count'] + 1;
                    $poll_count = $rss->fields['total'] + 1;
                    $DB->Execute("UPDATE T_ANSWER SET count=\"$answer_count\" WHERE answer=\"$answer\"");
                    $DB->Execute("UPDATE T_POLL SET total=\"$poll_count\" WHERE poll=\"$poll\"");
                    setcookie("get_poll", $poll, time()+60*60*24*30);
                    header("Location: /".$this->Data);
                }
            }
            if($this->Cmd == 'poll')
            {
                $rs = $DB->Execute("SELECT * FROM T_POLL WHERE active = 0 AND lang=?", Array($this->Entity));
                $xml .= "<ALLPOLLS>";
                while(!$rs->EOF)
                {
                    $xml .= "<ROW pk=\"{$rs->fields[poll]}\">";
                    foreach($rs->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                    $total = $rs->fields['total'];
                    $rss = $DB->Execute("SELECT * FROM T_ANSWER WHERE poll=? ORDER BY answer DESC", Array($rs->fields[poll]));
                    $xml .= "<ANSWERS>";
                    while(!$rss->EOF)
                    {
                        $percent = round(($rss->fields['count'] / $total) * 100);
                        $xml .= "<ROW pk=\"{$rss->fields[answer]}\" percent=\"$percent\">";
                        foreach($rss->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                        $xml .= "</ROW>";
                        $rss->MoveNext();
                    }
                    $xml .= "</ANSWERS>";
                    $rss->close();
                    
                    $xml .= "</ROW>";
                    $rs->MoveNext();
                }
                $xml .= "</ALLPOLLS>";
                $rs->close();
            }
            $rs = $DB->Execute("SELECT * FROM T_POLL WHERE active = 1 AND lang=?", Array($this->Entity));
            $xml .= "<POLLS>";
            while(!$rs->EOF)
            {
                $poll = $rs->fields[poll];
                $xml .= "<ROW pk=\"{$rs->fields[poll]}\">";
                foreach($rs->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                
                $rss = $DB->Execute("SELECT * FROM T_ANSWER WHERE poll=? ORDER BY answer DESC", Array($poll));
                $xml .= "<ANSWERS>";
                while(!$rss->EOF)
                {
                    $xml .= "<ROW pk=\"{$rss->fields[answer]}\">";
                    foreach($rss->fields as $k => $v)if(!is_integer($k))$xml .= "<FIELD name=\"$k\">".$v."</FIELD>";
                    $xml .= "</ROW>";
                    $rss->MoveNext();
                }
                $xml .= "</ANSWERS>";
                $rss->close();
                
                $xml .= "</ROW>";
                $rs->MoveNext();
            }
            $xml .= "</POLLS>";
            $rs->close();
            return $xml;
		}
	}
?>