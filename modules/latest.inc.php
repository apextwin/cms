<?
	class Latest extends Module
	{   
        function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'latest';
        } 
		function GetXML()
		{
		    Global $DB, $Processor;
		    $datatypes = Array('news'=>10, 'gallery'=>10);
		    $view = new Viewer();
		    $uri = $Processor->Uri;
		    $realm = $Processor->Realm;
		    switch($realm)
		    {
                case '1001':
                    $xml .= "<LATEST type=\"slider\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node = b.node WHERE b.realm=\"1001\" AND a.class=\"slider\" ORDER BY a.node ASC LIMIT 10";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                    $xml .= "<LATEST type=\"articles\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.class=\"article\" AND b.realm=\"1001\"";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                    $xml .= "<LATEST type=\"poleznoe\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.class=\"article\" AND b.realm=\"1006\" LIMIT 4";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                break;
                case '1002':
                    $xml .= "<LATEST type=\"slider\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node = b.node WHERE b.realm=\"1002\" AND a.class=\"slider\" ORDER BY a.node ASC LIMIT 10";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                    $xml .= "<LATEST type=\"articles\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.class=\"article\" AND b.realm=\"1002\"";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                    $xml .= "<LATEST type=\"poleznoe\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.class=\"article\" AND b.realm=\"1024\" LIMIT 4";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                break;
                default:
                    if($_GET[node])
                    {
                        $rs=$DB->Execute("SELECT realm FROM T_NODE_REALM WHERE node=?", Array($_GET[node]));
                        $rlm = $rs->fields['realm'];
                        $rs->close();
                        $xml .= "<LATEST type=\"same\">";
                        $rs = $DB->Execute("SELECT node FROM T_NODE_REALM WHERE realm=? ORDER BY node DESC LIMIT 4", Array($rlm));
                        while(!$rs->EOF)
                        {
                            $xml .= $view->LoadNodeData($rs->fields['node']);
                            $rs->MoveNext();
                        }
                        $xml .= "</LATEST>";
                        $rs->close();
                        
                    }
                    $xml .= "<LATEST type=\"articles\">";
                    $query = "SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.class=\"article\" AND b.realm=\"1001\"";
                    $rs = $DB->Execute($query);
                    while(!$rs->EOF)
                    {
                        $xml .= $view->LoadNodeData($rs->fields['node']);
                        $rs->MoveNext();
                    }
                    $xml .= "</LATEST>";
                break;
            }
			return $xml;
		}
	}
?>