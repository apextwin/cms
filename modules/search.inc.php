<?
    class Search extends Module
	{   
        function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'search';
        } 
		function GetXML()
		{
		    global $DB, $cfg;
		    if($_GET['searchstring'])
		    {
                $_GET['section'] = 'catalog';
                if($_GET['section'])
                {
                    if(count($_GET['section']) > 1)
                    {
                        $realms = array();
                        foreach($_GET['section'] as $k=>$v)
                        {
                            $rs = $DB->Execute("SELECT realm FROM T_REALM WHERE name=? LIMIT 1", Array($v));
                            $realm = $rs->fields['realm'];
                            $rs->close();
                            $curr_realms = $this->GetChildrenRealms($realm);
                            array_push($curr_realms, $realm);
                            $realms = array_merge($realms, $curr_realms);
                        }
                    }
                    else
                    {
                        $rs = $DB->Execute("SELECT realm FROM T_REALM WHERE name=? LIMIT 1", Array($_GET['section']));
                        $realm = $rs->fields['realm'];
                        $rs->close();
                        $realms = $this->GetChildrenRealms($realm);
                    }
                }
                $xml .= "<SEARCH searchstring=\"{$_GET['searchstring']}\">";
                $query = "SELECT node, textdata, MATCH(textdata) AGAINST('*".$_GET['searchstring']."*' IN BOOLEAN MODE) AS score FROM T_SEARCH WHERE MATCH(textdata) AGAINST('*".$_GET['searchstring']."*' IN BOOLEAN MODE)";
                //echo $query;
                $rs = $DB->Execute($query);
                while(!$rs->EOF)
                {
                    $rss = $DB->Execute("SELECT realm FROM T_NODE_REALM WHERE node=?", Array($rs->fields['node']));
                    
                    if( (sizeof($realms) && in_array($rss->fields['realm'], $realms) == TRUE) || sizeof($realms)==0 )
                    {
                        $xml .= "<RESULT score=\"{$rs->fields['score']}\" node=\"{$rs->fields['node']}\" realm=\"{$rss->fields['realm']}\">";
                        $stripped = strip_tags($rs->fields['textdata']);
                        if(mb_strlen($stripped)>250)
                        {
                            $position = mb_strpos($stripped, ' ', 240);
                            $text = mb_substr($stripped, 0, $position);
                        }
                        else $text = $stripped;

                        $xml .= "<![CDATA[".$text."]]>";
                        $xml .= "</RESULT>";
                    }
                    $rss->close();
                    $rs->MoveNext();
                }
                $xml .="</SEARCH>";
    		}
			return $xml;
		}
	}
?>