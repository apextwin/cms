<?
	class Adds extends Module
	{
		function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'adds';
        }
         
		function GetXML()
		{
		    Global $DB, $Processor;
		    $view = new Viewer();
            $realm = $Processor->Realm;
            if($_GET[node])
            {
                $rs=$DB->Execute("SELECT * FROM T_REALM WHERE parent=?", Array($realm));
    		    while(!$rs->EOF)
    		    {
                    $subrealm = $rs->fields['realm'];
                    $xml .= "<SUBREALM realm=\"{$subrealm}\" type=\"articles\">";
                    $rss = $DB->Execute("SELECT * FROM T_NODE_REALM WHERE realm=? ORDER BY RAND() LIMIT 5", Array($subrealm));
                    while(!$rss->EOF)
                    {
                        $xml .= $view->LoadNodeData($rss->fields['node']);
                        $rss->MoveNext();
                    }
                    $xml .= "</SUBREALM>";
                    $rs->MoveNext();
                }
                $rs->close();
    			return $xml;
            }
		}
	}
?>