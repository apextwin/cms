<?
    class Lists extends Module
	{   
        function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'lists';
        } 
		function GetXML()
		{
            $view = new Viewer();
            $xml .= $view->LoadListData('1');
			return $xml;
		}
	}
?>
