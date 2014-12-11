<?php
    #Tree library. version 1.0
	class xpTree
	{
        var $root;
        
		function xpTree($root=NULL)
		{
		    global $cfg;
		    if($root!=NULL)$this->root=$root;
		    else $this->root = $cfg['root'];
		}
		
        function GetXML()
        {
            global $DB, $cfg;
            
            switch($cfg['cache'])
            {
                case 'file':
                    $cache = $cfg[cachedir]."/tree".$this->root.".xml";
                    if(!is_file($cache))
                    {    
                        $innerxml .= $this->GetRealm($this->root);
                        file_put_contents($cache,$innerxml);
                        $xml .= $innerxml;
                    }
                    else $xml .= file_get_contents($cache);    
                break;
                case 'apc':
                    $cache = apc_fetch('tree'.$this->root, $res);
                    if($res)$xml .= $cache; 
                    else
                    {
                        $innerxml = $this->GetRealm($this->root);
                        apc_store('tree'.$this->root, $innerxml, 43200);
                        $xml .= $innerxml;  
                    }
                break;
                case '0':
                    $xml .= $this->GetRealm($this->root);
                break;    
            }      
            return $xml;
        }
        
        function GetRealm($realm)
        {
            global $DB;
            //$rs = $DB->Execute("SELECT COUNT(*) FROM T_NODE_REALM WHERE realm=?", Array($realm));
            $rs = $DB->Execute("SELECT COUNT(a.node) FROM T_NODE_REALM as a LEFT JOIN T_NODE as b ON a.node=b.node WHERE a.realm=? AND b.disabled=?", Array($realm, '0'));
            $count = $rs->fields['COUNT(a.node)'];
            $rs->close();
            $DB->Execute("UPDATE T_REALM SET nodecount=? WHERE realm=?", Array($count, $realm));
            $rs = $DB->Execute("SELECT * FROM T_REALM WHERE realm=?", Array($realm));
            while(!$rs->EOF)
			{
    			$out .= "<SECTION";
    			foreach($rs->fields as $k => $v)if(!is_integer($k) && $k!='descr')$out.=" $k =\"$v\"";
    			$out.=">";
    			if($rs->fields['descr'] != '')$out.="<DATA><![CDATA[".stripslashes(htmlspecialchars_decode($rs->fields['descr']))."]]></DATA>";
    			$rss = $DB->Execute("SELECT * FROM T_REALM WHERE parent=? ORDER BY weight", Array($realm));
    			while(!$rss->EOF)
    			{
    				$out .= $this->GetRealm($rss->fields[realm]);
    				$rss->MoveNext();
    			}
    			$rss->close();
    			$out .= '</SECTION>';
    			$rs->MoveNext();
			}
			$rs->close();
			return $out;
        }
	}
?>