function setInit(groupID) {
    setDefaultStyles();
    _root.groupID = groupID;
    ProductCategories.setStyle("marginLeft", 0);
    ProductCategories.setStyle("marginTop", 0);  
    
    
    contactlist.dragEnabled=true;
    contactlist.multipleSelection = true;     
    contactlist.addEventListener('dragEnter', doDragEnterSource);
    contactlist.addEventListener('dragOver', doDragOverSource);
    contactlist.addEventListener('dragExit', doDragExitSource);
    contactlist.addEventListener('dragDrop', doDragDropDGSource);
    contactlist.addEventListener('dragComplete', doDragCompleteDGSource);    
    
    usergroups.dragEnabled=true;
    usergroups.multipleSelection = true;      
    usergroups.addEventListener('dragEnter', doDragEnterSource);
    usergroups.addEventListener('dragOver', doDragOverSource);
    usergroups.addEventListener('dragExit', doDragExitSource);
    usergroups.addEventListener('dragDrop', doDragDropDGSource);
    usergroups.addEventListener('dragComplete', doDragCompleteDGSource);        
    
    ChildGroupAndContacts.dragEnabled=true;
    ChildGroupAndContacts.multipleSelection = true;           
    ChildGroupAndContacts.addEventListener('dragEnter', doDragEnterDest);
    ChildGroupAndContacts.addEventListener('dragOver', doDragOverDest);
    ChildGroupAndContacts.addEventListener('dragExit', doDragExitDest);
    ChildGroupAndContacts.addEventListener('dragDrop', doDragDropDGDest);
    ChildGroupAndContacts.addEventListener('dragComplete', doDragCompleteDGDest);
    

    _global.listOrig = '';  
    var grdDestListener:Object = {};  
    grdDestListener.mouseDown = function() {
      _global.listOrig = 'contactlist'; 
    }
    ChildGroupAndContacts.addEventListener("mouseDown", grdDestListener); 
    
    
    var grdSourceListener:Object = {};
    grdSourceListener.mouseDown = function() {
      _global.listOrig = 'ChildGroupAndContacts'; 
    }
    contactlist.addEventListener("mouseDown", grdSourceListener); 
    
    
    //Reference the grids
    var listSource:Object = {};
    var listDestination:Object = {};
    
    //destination grid focus listener
    var grdDestListener:Object = {};
    var grdSourceListener:Object = {};
    
    //destination select focus listener
    
    //Specify source and target flags
    var overSourceItem:Boolean = false;
    var overTargetItem:Boolean = false;
    
    var alreadyDraggedOver:Boolean = false;
    var alreadyEnter:Boolean = false; 
    var currentGrid:String = "";

    //functions declared in formOnload to avoid _root prefix    
    function doDragEnterSource(event) {
      alreadyEnter = true;
      listSource = event.target;
      event.handled = true; 
    }
      
    function doDragEnterDest(event) {
      alreadyEnter = true;
      listDestination = event.target; 
      event.handled = true; 
    } 
          
    function doDragExitSource(event) {
      listSource = event.target;
      overSourceItem = false;
      event.target.hideDropFeedback();
    }
    
    function doDragExitDest(event) {
      listDestination = event.target; 
      overTargetItem = false;
      event.target.hideDropFeedback();
    }
    
    function doDragOverSource(event) {
      listSource = event.target;        
      currentGrid = String(listSource);
      var gridArray:Array = currentGrid.split(".");
      currentGrid = gridArray[gridArray.length - 1];
      
      if (listDestination.dataProvider.length > 0)   
      {
        overSourceItem = true;
        event.target.showDropFeedback();
        if (Key.isDown(Key.CONTROL))
          event.action = mx.managers.DragManager.COPY;
        else if (Key.isDown(Key.SHIFT))
          event.action = mx.managers.DragManager.LINK;
        else
          event.action = mx.managers.DragManager.MOVE;
      } 
      
    }
    
    function doDragOverDest(event) {
      listDestination = event.target; 
      alreadyDraggedOver = true;                
      currentGrid = String(listDestination);
      var gridArray:Array = currentGrid.split(".");
      currentGrid = gridArray[gridArray.length - 1];
      
      var itemAlreadyExists:Boolean = false;
      //handle grid actions
      if (currentGrid == "ChildGroupAndContacts")
      {
        //loop based on greater/lesser lengths
        if(listDestination.length > listSource.selectedItems.length)
        {
          for (var i = 0; i < listDestination.length; i++)
          {
            if (!itemAlreadyExists)
            {
              for (var x = 0; x < listSource.selectedItems.length; x++)
              { 
                if (listSource.selectedItems.getItemAt(x).id == listDestination.getItemAt(i).id)
                {
                   itemAlreadyExists = true;
                   break;
                }
              }
            } 
            else
            {
              break;
            }
          }
        }
        else
        {
          for (var i = 0; i < listSource.selectedItems.length; i++)
          {
            if (!itemAlreadyExists)
            {           
              for (var x = 0; x < listDestination.length; x++)
              {                 
                if (listDestination.getItemAt(x).id == listSource.selectedItems.getItemAt(i).id)
                {
                   itemAlreadyExists = true;
                   break;
                }
              }
            } 
            else
            {
              break;
            } 
          }   
        } 
        
        if (alreadyDraggedOver && alreadyEnter)
        {                                       
          if (itemAlreadyExists && _global.listOrig == 'ChildGroupAndContacts')
          {
            alert('Item already added check selection.', "Warning");
          } 
        } 
      }
      
      //handle select box actions
      else if(currentGrid == "selDestination")
      {       
        for (var i = 0; i < listDestination.length; i++)
        {
          if (!itemAlreadyExists)
          {
            for (var x = 0; x < listSource.selectedItems.length; x++)
            {               
              //Could use ".data" instead of ".label" here if you like
              if (listDestination.getItemAt(i).data == listSource.selectedItems.getItemAt(x).data)
              { 
                 itemAlreadyExists = true;
                 break;
              }
            }
          }
          else
          {
            break;
          }
        } 
        if (alreadyDraggedOver && alreadyEnter)
        {
          if (itemAlreadyExists && _global.listOrig == 'selDestination')
          {
            alert('Item already added check selection.', "Warning");
          }
        } 
                  
      }         
        
      if (listSource.length > 0 and !itemAlreadyExists)
      {
        overTargetItem = true;
        event.target.showDropFeedback();
        if (Key.isDown(Key.CONTROL))
          event.action = mx.managers.DragManager.COPY;
        else if (Key.isDown(Key.SHIFT))
          event.action = mx.managers.DragManager.LINK;
        else
        event.action = mx.managers.DragManager.MOVE;
      }
      alreadyEnter = false;           
    }
        
    function doDragDropDGSource(event) {
      doDragExitDest(event);
      var dragItems = event.dragSource.dataForFormat('items');
      var dest = event.target;
      var dropLoc = dest.getDropLocation();
      dest.addItemsAt(dropLoc,dragItems);     
    }
    
    function doDragDropDGDest(event) {      
      doDragExitSource(event);
      var dragItems = event.dragSource.dataForFormat('items');
      var dest = event.target;
      var dropLoc = dest.getDropLocation();
      dest.addItemsAt(dropLoc,dragItems);       
    }
    
    function doDragCompleteDGSource(event){
      var dest = event.target;
      var action = event.action;
      var dropLoc = dest.getDropLocation();
      var selectedIn:Array = event.target.selectedIndices;
      
      //descending sort to remove items that have been dropped into target grid
      selectedIn.sort(16|2);
      
      if (overTargetItem)
      {
        for(var i = 0; i < selectedIn.length; i++){
          //add the selected items
          listDestination.dataProvider.addItem(event.target.selectedItems[i]);
          listDestination.selectedIndex = -1;
        }
        if (action == "move") {
          for(var i = 0; i < selectedIn.lengt; i++){
            //remove this item
            event.target.dataProvider.removeItemAt(selectedIn[i]);
          }
        }
        
        if (event.target.dataProvider.length == 0)
        {
          event.target.dataProvider.removeAll();          
        }
        event.target.selectedIndex = 0;
        listDestination.selectedIndex = 0;
      } 
      overTargetItem = false;
      listDestination.hideDropFeedback();
      listSource = event.target;  
      _root.updateGroupRelationships();
      
    }
    
    function doDragCompleteDGDest(event){
      var dest = event.target;
      var action = event.action;
      var dropLoc = dest.getDropLocation();
      var selectedIn:Array = event.target.selectedIndices;
    
      //descending sort to remove items that have been dropped into target grid
      selectedIn.sort(16|2);        
      if (!overTargetItem) {
        for(var i = 0; i < selectedIn.length; i++){
          //add the selected items 
          listSource.dataProvider.addItem(event.target.selectedItems[i]);
        }
        if (action == "move") {
            for(var i = 0; i < selectedIn.length; i++){
              //remove this item 
              event.target.dataProvider.removeItemAt(selectedIn[i]);                              
            }
        }
        
        if (event.target.dataProvider.length == 0) {
          event.target.dataProvider.removeAll();          
        }
        listSource.selectedIndex = 0;
        event.target.selectedIndex = 0;
      }
      alreadyDraggedOver = false;
      alreadyEnter = false;
      overSourceItem = false;   
      listSource.hideDropFeedback();
      _global.listOrig = '';                                    
      _global.nongroupawardAdd(); 
      listDestination = event.target;   
  }   
      


}

function processImages() {
    
  }

function setDefaultStyles() {
  _global.styles.Tree.setStyle("backgroundColor", 0xFFFFFF);
  _global.styles.Tree.setStyle("borderColor", 0xFFFFFF);
  _global.styles.HBox.setStyle("color", 0x000000);  
  _global.styles.Tree.setStyle("marginTop", 2);
  _global.styles.Tree.setStyle("marginRight", 2); 
  _global.styles.Tree.setStyle("marginBottom", 2);  
  _global.styles.Tree.setStyle("marginLeft", 2);
  _global.styles.Panel.setStyle("marginTop", 2);
  _global.styles.Panel.setStyle("marginRight", 2);  
  _global.styles.Panel.setStyle("marginBottom", 2); 
  _global.styles.Panel.setStyle("marginLeft", 2);
  _global.styles.HBox.setStyle("marginTop", 2);
  _global.styles.HBox.setStyle("marginRight", 2); 
  _global.styles.HBox.setStyle("marginBottom", 2);  
  _global.styles.HBox.setStyle("marginLeft", 2);
  _global.styles.VBox.setStyle("marginTop", 2);
  _global.styles.VBox.setStyle("marginRight", 2); 
  _global.styles.VBox.setStyle("marginBottom", 2);  
  _global.styles.VBox.setStyle("marginLeft", 2);  
  _global.styles.Tree.setStyle("paddingTop", 2);
  _global.styles.Tree.setStyle("paddingRight", 2);  
  _global.styles.Tree.setStyle("paddingBottom", 2); 
  _global.styles.Tree.setStyle("paddingLeft", 2);
  _global.styles.Panel.setStyle("paddingTop", 2);
  _global.styles.Panel.setStyle("paddingRight", 2); 
  _global.styles.Panel.setStyle("paddingBottom", 2);  
  _global.styles.Panel.setStyle("paddingLeft", 2);
  _global.styles.HBox.setStyle("paddingTop", 2);
  _global.styles.HBox.setStyle("paddingRight", 2);  
  _global.styles.HBox.setStyle("paddingBottom", 2); 
  _global.styles.HBox.setStyle("paddingLeft", 2);
  _global.styles.VBox.setStyle("paddingTop", 2);
  _global.styles.VBox.setStyle("paddingRight", 2);  
  _global.styles.VBox.setStyle("paddingBottom", 2); 
  _global.styles.VBox.setStyle("paddingLeft", 2);   


  
}

 


  var groupID:String = "0";
  var overSourceItem:Boolean = false;
  var overTargetItem:Boolean = false;


function applyFilter( term:String, grid:mx.controls.DataGrid, columns:Array ):Void {
   var filterTerm:String = term.toString().toLowerCase();
   if(filterTerm.length > 0) {
      if(_global.unfilteredData[grid.id] == undefined){
         if (_global.unfilteredData == undefined){
            _global.unfilteredData = {};
         }
         _global.unfilteredData[grid.id] = grid.dataProvider.slice(0);
      }
      var filteredData:Array = [];
      for(var i = 0; i< _global.unfilteredData[grid.id].length; i++) {
         var item:Object = _global.unfilteredData[grid.id][i];
         var added:Boolean = false;
         
         for(var j = 0; j< columns.length; j++){
             if(!added){
               var value:String = item[columns[j]].toString().toLowerCase();
               if(value.indexOf(filterTerm) != -1)   {
                  filteredData.push(item);
                  added = true;
               }
            }
            else {
               break;
            }
         }
      }
   grid.dataProvider = filteredData;
   }
   else {
      if(_global.unfilteredData[grid.id] != undefined) grid.dataProvider = _global.unfilteredData[grid.id];
   }
}


  function updateGroupRelationships() {

    mx.managers.CursorManager.setBusyCursor();
    //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    //declare service
    var myService:mx.remoting.NetServiceProxy;
    var responseHandler = {};
    var ChildGroupAndContacts = ChildGroupAndContacts;
    responseHandler.onResult = function( results: Object ):Void {
      mx.managers.CursorManager.removeAllCursors();
      ChildGroupAndContacts.dataProvider = results._items;
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({
      event: "groups.updateGroupRelationships",
      datagrid: ChildGroupAndContacts.dataProvider,
      groupID: _root.groupID
    });   
  } 
  
  function getChildrenQ(groupID) {

    mx.managers.CursorManager.setBusyCursor();
  //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    //declare service
    var myService:mx.remoting.NetServiceProxy;
    var ChildGroupAndContacts = ChildGroupAndContacts;
    ChildGroupAndContacts.removeAll();    
    var responseHandler = {};
    //var contactsInGroup = contactsingroup;
    responseHandler.onResult = function( results: Object ):Void {
      mx.managers.CursorManager.removeAllCursors();
      ChildGroupAndContacts.dataProvider = results._items;
      _root.processImages();
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    myService = connection.getService("remote.MyProxy", responseHandler );    
    myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({
      event: "groups.getChildGroupsAndContacts",
      groupID: groupID});     
    
  }
  
  function buildCategoryTree(openit,nodeID) {
    mx.managers.CursorManager.setBusyCursor();
  //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    //declare service
    var myService:mx.remoting.NetServiceProxy;
    var ProductCategories = ProductCategories;  
    var responseHandler = {};
    //var contactsInGroup = contactsingroup;
    responseHandler.onResult = function( results: Object ):Void {
      mx.managers.CursorManager.removeAllCursors();
      ProductCategories.dataProvider = results;
      if (openit) {
        _root.ProductCategories.setIsOpen(nodeID,true);
      }
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    
    myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({event: "groups.buildTree"});   

  }
  function treeClick() {

    var thisNodeID = ProductCategories.getNodeDisplayedAt(ProductCategories.selectedIndex).getProperty('id');
    _root.groupID = thisNodeID;
    getChildrenQ(thisNodeID);
  }
  
  function createGroup() {

    var currentGroup = ProductCategories.getNodeDisplayedAt(ProductCategories.selectedIndex).getProperty('id');
    var xtoOPen = ProductCategories.getNodeDisplayedAt(ProductCategories.selectedIndex);
    var groupName = groupName.text;
    if (currentGroup == undefined) {
      alert("you need to select a parent group");
    } else {
      mx.managers.CursorManager.setBusyCursor();
      //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
      //declare service
      var myService:mx.remoting.NetServiceProxy;
      var ProductCategories = ProductCategories;  
      var responseHandler = {};
      //var contactsInGroup = contactsingroup;
      responseHandler.onResult = function( results: Object ):Void {
        mx.managers.CursorManager.removeAllCursors();
        _root.buildCategoryTree(true,xtoOPen);
      }
      responseHandler.onStatus  = function( stat: Object ):Void {
        alert("Error while calling cfc:" + stat.description);
      }
      myService = connection.getService("remote.MyProxy", responseHandler );  
      myService.process({
        event: "groups.createGroup",
        parentID: currentGroup,
        name: groupName
      })

    }
  }

  function updateGroups() {
    mx.managers.CursorManager.setBusyCursor();
  //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    var myService:mx.remoting.NetServiceProxy;
    var responseHandler = {};
    responseHandler.onResult = function( results: Object ):Void {
      mx.managers.CursorManager.removeAllCursors();
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({
      event: "groups.removeGroups",
      groups: usergroups.dataProvider
    })
    };
  function removeGroups() {
    var usergroups = usergroups;
    var selectedIn:Array = usergroups.selectedIndices;
      for(var i = 0; i < selectedIn.length; i++){
        // remove this item 
         usergroups.dataProvider.removeItemAt(selectedIn[i])
      }
    updateGroups();
  }
  
  function removekids() {
    var idArr = [];
    var ChildGroupAndContacts = ChildGroupAndContacts;
    //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    var myService:mx.remoting.NetServiceProxy;
    var responseHandler = {};
    mx.managers.CursorManager.setBusyCursor();
    responseHandler.onResult = function( results: Object ):Void {
      mx.managers.CursorManager.removeAllCursors();
      _root.getChildrenQ(_root.groupID);
      
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    myService = connection.getService("remote.MyProxy", responseHandler );  
    for(var i = 0; i < ChildGroupAndContacts.selectedIndices.length; i++){
       idArr.push(ChildGroupAndContacts.getItemAt(ChildGroupAndContacts.selectedIndices[i]).cgrid);
    }
    myService.process({
      event: "groups.removeFromGroup",
      id: idArr
    })    

  }