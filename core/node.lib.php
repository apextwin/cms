<?
    #Node library. version 1.0
	class xpNode
	{
        var $uri;
        
		function xpNode($uri)
		{
			$this->uri = $uri;			
		}
		function GetXML($curr_realm, $realmpagesize=NULL)
		{
            global $DB, $cfg, $Processor, $Cache;
            $view = new Viewer();
            if($_GET[node])
            {
                $xml .= $view->LoadNodeData($_GET[node]);
                $DB->Execute("UPDATE T_NODE SET viewcounter=viewcounter+1 WHERE node=?", Array($_GET['node']));
            }
            else
            {
                if(!$_GET['page'])$_GET['page'] = 1;
                $order = NULL;
                if($_GET['order'])
                {
                    $order[0] = $_GET['order'];
                    if($_GET['dir'] == 'ASC')$order[1] = "ASC";
                    else $order[1] = "DESC";
                }
                else
                {
                    $order[0] = 'topcounter';
                    $order[1] = 'DESC';
                }
                if($_GET[fieldorder])
                {
                    $fieldsorder[0] = $_GET[fieldorder];
                    $fieldsorder[1] = $_GET[dir];
                }   
                if($_GET[ps])$pagesize=$_GET[ps];
                else $pagesize=NULL;
                $params = array('realm'=>$curr_realm, 'page'=>$_GET['page'], 'disabled'=>1, 'order'=>$order, 'pagesize'=>$pagesize);
                //print_r($params);
                //$nodeparams = array('cost'=>array('from'=>'0', 'to'=>'200000'));
                if($curr_realm == '1520')
                {
                    $params = array('page'=>$_GET['page'], 'disabled'=>1, 'order'=>$order, 'pagesize'=>20);    
                }
                if($_GET[datatype])
                {
                    $nodeparams = $_GET;
                    $xml .= $view->LoadNodeSet($params, $nodeparams, $fieldsorder);
                }
                else $xml .= $view->LoadNodeSet($params, NULL, $fieldsorder);
            }
			return $xml;
		}
	}
?>